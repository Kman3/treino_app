import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

/// Catálogo de exercícios, substitutos e as trocas feitas pelo "Ocupado".
class ExercicioRepository {
  ExercicioRepository(this._db, {DateTime Function()? agora})
    : _agora = agora ?? clock.now;

  final AppDatabase _db;
  final DateTime Function() _agora;

  Future<Exercicio?> exercicio(String id) => (_db.select(
    _db.exercicios,
  )..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<Map<String, Exercicio>> catalogo() async => {
    for (final e in await _db.select(_db.exercicios).get()) e.id: e,
  };

  /// Exercícios do mesmo padrão de movimento, menos o próprio, por nome.
  Future<List<Exercicio>> substitutos(Exercicio exercicio) {
    return (_db.select(_db.exercicios)
          ..where(
            (e) =>
                e.padraoMovimento.equals(exercicio.padraoMovimento) &
                e.id.equals(exercicio.id).not(),
          )
          ..orderBy([(e) => OrderingTerm.asc(e.nome)]))
        .get();
  }

  /// Troca só neste treino. As séries já feitas continuam com o exercício
  /// antigo; as que faltam usam o novo, com [cargaKg].
  Future<Substituicao> trocarNoTreino({
    required String treinoId,
    required ItemPlano item,
    required String exercicioOriginalId,
    required String exercicioNovoId,
    required double? cargaKg,
  }) {
    final agora = _agora();
    return _db
        .into(_db.substituicoes)
        .insertReturning(
          SubstituicoesCompanion.insert(
            id: const Uuid().v4(),
            itemPlanoId: item.id,
            exercicioOriginalId: exercicioOriginalId,
            exercicioNovoId: exercicioNovoId,
            escopo: EscopoSubstituicao.sessao,
            treinoId: Value(treinoId),
            cargaKg: Value(cargaKg),
            atualizadoEm: Value(agora),
          ),
        );
  }

  /// Troca para sempre: o item do plano passa a usar o exercício novo com
  /// [cargaKg]. A linha guarda o exercício e a carga de antes, para desfazer.
  /// Lê o item do banco: o do treino pode estar trocado ou reduzido.
  Future<Substituicao> trocarSempre({
    required String itemPlanoId,
    required String exercicioNovoId,
    required double? cargaKg,
  }) {
    return _db.transaction(() async {
      final agora = _agora();
      final item = await (_db.select(
        _db.itensPlano,
      )..where((i) => i.id.equals(itemPlanoId))).getSingle();
      final troca = await _db
          .into(_db.substituicoes)
          .insertReturning(
            SubstituicoesCompanion.insert(
              id: const Uuid().v4(),
              itemPlanoId: item.id,
              exercicioOriginalId: item.exercicioId,
              exercicioNovoId: exercicioNovoId,
              escopo: EscopoSubstituicao.sempre,
              cargaKg: Value(cargaKg),
              cargaOriginalKg: Value(item.cargaPlanKg),
              atualizadoEm: Value(agora),
            ),
          );
      await (_db.update(
        _db.itensPlano,
      )..where((i) => i.id.equals(item.id))).write(
        ItensPlanoCompanion(
          exercicioId: Value(exercicioNovoId),
          cargaPlanKg: Value(cargaKg),
          atualizadoEm: Value(agora),
        ),
      );
      return troca;
    });
  }

  /// Desfaz uma troca. Na troca para sempre, o item do plano volta ao
  /// exercício e à carga de antes.
  Future<void> desfazerTroca(Substituicao troca) {
    return _db.transaction(() async {
      final agora = _agora();
      await (_db.update(
        _db.substituicoes,
      )..where((s) => s.id.equals(troca.id))).write(
        SubstituicoesCompanion(
          excluidoEm: Value(agora),
          atualizadoEm: Value(agora),
        ),
      );
      if (troca.escopo == EscopoSubstituicao.sempre) {
        await (_db.update(
          _db.itensPlano,
        )..where((i) => i.id.equals(troca.itemPlanoId))).write(
          ItensPlanoCompanion(
            exercicioId: Value(troca.exercicioOriginalId),
            cargaPlanKg: Value(troca.cargaOriginalKg),
            atualizadoEm: Value(agora),
          ),
        );
      }
    });
  }

  /// Por item do plano, a troca em vigor só neste treino (a mais recente).
  Future<Map<String, Substituicao>> trocasDoTreino(String treinoId) async {
    final linhas =
        await (_db.select(_db.substituicoes)
              ..where(
                (s) =>
                    s.treinoId.equals(treinoId) &
                    s.escopo.equals(EscopoSubstituicao.sessao) &
                    s.excluidoEm.isNull(),
              )
              ..orderBy([(s) => OrderingTerm.desc(s.atualizadoEm)]))
            .get();
    final porItem = <String, Substituicao>{};
    for (final s in linhas) {
      porItem.putIfAbsent(s.itemPlanoId, () => s);
    }
    return porItem;
  }
}
