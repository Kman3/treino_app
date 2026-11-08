import 'package:drift/drift.dart';

import '../app_database.dart';

class ItemComExercicio {
  const ItemComExercicio(this.item, this.exercicio);

  final ItemPlano item;
  final Exercicio exercicio;
}

class SessaoComItens {
  const SessaoComItens(this.sessao, this.itens);

  final SessaoPlano sessao;
  final List<ItemComExercicio> itens;

  /// Tempo de execução estimado por série, além do descanso.
  static const _execucaoPorSerieS = 45;

  int get duracaoEstimadaMin {
    final segundos = itens.fold<int>(
      0,
      (total, i) =>
          total + i.item.series * (_execucaoPorSerieS + i.item.descansoS),
    );
    return (segundos / 60).round();
  }
}

/// O que a tela 01 mostra: a sessão do dia e onde ela está no ciclo.
class TreinoDoDia {
  const TreinoDoDia({
    required this.plano,
    required this.sessoes,
    required this.sessao,
    required this.semana,
    this.emAndamento,
  });

  final PlanoTreino plano;

  /// Todas as sessões do plano, na ordem do ciclo (A, B, C…).
  final List<SessaoPlano> sessoes;
  final SessaoComItens sessao;

  /// Semana atual do mesociclo, de 1 a `plano.semanas`.
  final int semana;

  /// Treino desta sessão já iniciado e não finalizado, para retomar.
  final Treino? emAndamento;
}

class PlanoRepository {
  PlanoRepository(this._db, {DateTime Function()? agora})
    : _agora = agora ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _agora;

  Future<PlanoTreino?> planoAtivo() {
    return (_db.select(_db.planosTreino)
          ..where((p) => p.ativo.equals(true) & p.excluidoEm.isNull())
          ..orderBy([(p) => OrderingTerm.desc(p.inicioEm)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<SessaoPlano>> sessoesDoPlano(String planoId) {
    return (_db.select(_db.sessoesPlano)
          ..where((s) => s.planoId.equals(planoId) & s.excluidoEm.isNull())
          ..orderBy([(s) => OrderingTerm.asc(s.ordem)]))
        .get();
  }

  Future<SessaoComItens?> sessaoComItens(String sessaoId) async {
    final sessao = await (_db.select(
      _db.sessoesPlano,
    )..where((s) => s.id.equals(sessaoId))).getSingleOrNull();
    if (sessao == null) return null;

    final consulta =
        _db.select(_db.itensPlano).join([
            innerJoin(
              _db.exercicios,
              _db.exercicios.id.equalsExp(_db.itensPlano.exercicioId),
            ),
          ])
          ..where(
            _db.itensPlano.sessaoPlanoId.equals(sessaoId) &
                _db.itensPlano.excluidoEm.isNull(),
          )
          ..orderBy([OrderingTerm.asc(_db.itensPlano.ordem)]);

    final linhas = await consulta.get();
    return SessaoComItens(sessao, [
      for (final l in linhas)
        ItemComExercicio(
          l.readTable(_db.itensPlano),
          l.readTable(_db.exercicios),
        ),
    ]);
  }

  /// A sessão em andamento, se houver; senão a seguinte à última finalizada
  /// no ciclo; sem histórico, a primeira.
  Future<TreinoDoDia?> treinoDoDia() async {
    final plano = await planoAtivo();
    if (plano == null) return null;
    final sessoes = await sessoesDoPlano(plano.id);
    if (sessoes.isEmpty) return null;

    final idsSessoes = sessoes.map((s) => s.id);
    Future<Treino?> ultimoTreino(List<String> status) {
      return (_db.select(_db.treinos)
            ..where(
              (t) =>
                  t.sessaoPlanoId.isIn(idsSessoes) &
                  t.status.isIn(status) &
                  t.excluidoEm.isNull(),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.iniciadoEm)])
            ..limit(1))
          .getSingleOrNull();
    }

    final emAndamento = await ultimoTreino([StatusTreino.andamento]);
    final SessaoPlano sessaoDoDia;
    if (emAndamento != null) {
      sessaoDoDia = sessoes.firstWhere(
        (s) => s.id == emAndamento.sessaoPlanoId,
      );
    } else {
      final ultimo = await ultimoTreino([
        StatusTreino.concluido,
        StatusTreino.parcial,
      ]);
      final indice = ultimo == null
          ? -1
          : sessoes.indexWhere((s) => s.id == ultimo.sessaoPlanoId);
      sessaoDoDia = sessoes[(indice + 1) % sessoes.length];
    }

    return TreinoDoDia(
      plano: plano,
      sessoes: sessoes,
      sessao: (await sessaoComItens(sessaoDoDia.id))!,
      semana: _semanaDoCiclo(plano),
      emAndamento: emAndamento,
    );
  }

  /// Emite de novo sempre que plano, histórico ou catálogo mudam.
  Stream<TreinoDoDia?> watchTreinoDoDia() {
    return _db
        .quandoMudar('treino_do_dia', {
          _db.planosTreino,
          _db.sessoesPlano,
          _db.itensPlano,
          _db.exercicios,
          _db.treinos,
        })
        .asyncMap((_) => treinoDoDia());
  }

  Stream<SessaoComItens?> watchSessao(String sessaoId) {
    return _db
        .quandoMudar('sessao', {
          _db.sessoesPlano,
          _db.itensPlano,
          _db.exercicios,
        })
        .asyncMap((_) => sessaoComItens(sessaoId));
  }

  int _semanaDoCiclo(PlanoTreino plano) {
    final agora = _agora();
    final hoje = DateTime.utc(agora.year, agora.month, agora.day);
    final inicio = DateTime.utc(
      plano.inicioEm.year,
      plano.inicioEm.month,
      plano.inicioEm.day,
    );
    final dias = hoje.difference(inicio).inDays;
    return (dias ~/ 7 + 1).clamp(1, plano.semanas);
  }
}
