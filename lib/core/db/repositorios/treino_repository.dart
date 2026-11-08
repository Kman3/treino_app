import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

/// Execuções reais de treino e as séries registradas nelas.
class TreinoRepository {
  TreinoRepository(this._db, {DateTime Function()? agora})
    : _agora = agora ?? clock.now;

  final AppDatabase _db;
  final DateTime Function() _agora;

  Future<Treino> iniciar(
    String sessaoPlanoId, {
    String modo = ModoTreino.normal,
  }) {
    final agora = _agora();
    return _db
        .into(_db.treinos)
        .insertReturning(
          TreinosCompanion.insert(
            id: const Uuid().v4(),
            sessaoPlanoId: sessaoPlanoId,
            iniciadoEm: agora,
            modo: Value(modo),
            atualizadoEm: Value(agora),
          ),
        );
  }

  Future<void> finalizar(
    String treinoId, {
    String status = StatusTreino.concluido,
  }) async {
    final agora = _agora();
    await (_db.update(_db.treinos)..where((t) => t.id.equals(treinoId))).write(
      TreinosCompanion(
        status: Value(status),
        finalizadoEm: Value(agora),
        atualizadoEm: Value(agora),
      ),
    );
  }

  Future<Treino?> treino(String treinoId) {
    return (_db.select(
      _db.treinos,
    )..where((t) => t.id.equals(treinoId))).getSingleOrNull();
  }

  Stream<Treino?> watchEmAndamento() {
    return (_db.select(_db.treinos)
          ..where(
            (t) =>
                t.status.equals(StatusTreino.andamento) & t.excluidoEm.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.iniciadoEm)])
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Grava uma série. Valores diferentes do plano marcam `editado`.
  Future<Serie> registrarSerie({
    required String treinoId,
    required ItemPlano item,
    required int numero,
    required double? cargaPlanKg,
    required int repsPlan,
    required double? cargaKg,
    required int reps,
    bool aquecimento = false,
  }) {
    final agora = _agora();
    return _db
        .into(_db.series)
        .insertReturning(
          SeriesCompanion.insert(
            id: const Uuid().v4(),
            treinoId: treinoId,
            itemPlanoId: Value(item.id),
            exercicioId: item.exercicioId,
            numero: numero,
            cargaPlanKg: Value(cargaPlanKg),
            repsPlan: Value(repsPlan),
            cargaKg: Value(cargaKg),
            reps: Value(reps),
            aquecimento: Value(aquecimento),
            editado: Value(cargaKg != cargaPlanKg || reps != repsPlan),
            registradaEm: agora,
            atualizadoEm: Value(agora),
          ),
        );
  }

  /// Corrige carga e reps de uma série já registrada. `editado` passa a
  /// refletir a diferença entre os valores novos e o plano daquela série.
  Future<void> corrigirSerie(
    Serie serie, {
    required double? cargaKg,
    required int reps,
  }) async {
    await (_db.update(_db.series)..where((s) => s.id.equals(serie.id))).write(
      SeriesCompanion(
        cargaKg: Value(cargaKg),
        reps: Value(reps),
        editado: Value(cargaKg != serie.cargaPlanKg || reps != serie.repsPlan),
        atualizadoEm: Value(_agora()),
      ),
    );
  }

  /// Grava a resposta da pergunta "Como foi?" (RIR de 0 a 4).
  Future<void> responderDificuldade(String serieId, int rir) =>
      _atualizarSerie(serieId, SeriesCompanion(rir: Value(rir)));

  /// "✓ Sim, igual": a série foi feita como registrada.
  Future<void> confirmarSerie(String serieId) =>
      _atualizarSerie(serieId, const SeriesCompanion(confirmado: Value(true)));

  /// Recusa (ou volta a aceitar) a carga menor que esta série sugeriu para a
  /// próxima.
  Future<void> definirManterCarga(String serieId, {required bool manter}) =>
      _atualizarSerie(serieId, SeriesCompanion(manterCarga: Value(manter)));

  Future<void> _atualizarSerie(String serieId, SeriesCompanion valores) async {
    await (_db.update(_db.series)..where((s) => s.id.equals(serieId))).write(
      valores.copyWith(atualizadoEm: Value(_agora())),
    );
  }

  /// Abre o descanso: grava quando ele termina e qual série o abriu.
  Future<void> definirDescanso(
    String treinoId, {
    required DateTime? terminaEm,
    String? serieId,
  }) async {
    await (_db.update(_db.treinos)..where((t) => t.id.equals(treinoId))).write(
      TreinosCompanion(
        descansoTerminaEm: Value(terminaEm),
        descansoSerieId: terminaEm == null
            ? const Value(null)
            : (serieId == null ? const Value.absent() : Value(serieId)),
        atualizadoEm: Value(_agora()),
      ),
    );
  }

  /// Maior carga já registrada em cada exercício antes deste treino (séries
  /// do plano, sem aquecimento): o PR atual.
  Future<Map<String, double>> recordes(
    Iterable<String> exercicioIds, {
    required String excetoTreinoId,
  }) async {
    final ids = exercicioIds.toSet();
    if (ids.isEmpty) return {};
    final maior = _db.series.cargaKg.max();
    final consulta = _db.selectOnly(_db.series)
      ..addColumns([_db.series.exercicioId, maior])
      ..where(
        _db.series.exercicioId.isIn(ids) &
            _db.series.treinoId.equals(excetoTreinoId).not() &
            _db.series.aquecimento.equals(false) &
            _db.series.excluidoEm.isNull() &
            _db.series.cargaKg.isNotNull(),
      )
      ..groupBy([_db.series.exercicioId]);
    return {
      for (final linha in await consulta.get())
        linha.read(_db.series.exercicioId)!: linha.read(maior)!,
    };
  }

  /// Dias de treino em que o exercício foi feito com [cargaKg] ou mais, do
  /// mais antigo para o mais recente (para "você já fez 80 kg 2 vezes").
  Future<List<DateTime>> datasComCarga(
    String exercicioId,
    double cargaKg,
  ) async {
    final consulta =
        _db.select(_db.series).join([
            innerJoin(
              _db.treinos,
              _db.treinos.id.equalsExp(_db.series.treinoId),
            ),
          ])
          ..where(
            _db.series.exercicioId.equals(exercicioId) &
                _db.series.cargaKg.isBiggerOrEqualValue(cargaKg - 1e-6) &
                _db.series.aquecimento.equals(false) &
                _db.series.excluidoEm.isNull(),
          )
          ..orderBy([OrderingTerm.asc(_db.treinos.iniciadoEm)]);
    final porTreino = <String, DateTime>{};
    for (final linha in await consulta.get()) {
      final treino = linha.readTable(_db.treinos);
      porTreino.putIfAbsent(treino.id, () => treino.iniciadoEm);
    }
    return porTreino.values.toList();
  }

  /// Exclusão lógica, para o sync levar a exclusão ao Supabase.
  Future<void> excluirSerie(String serieId) async {
    final agora = _agora();
    await (_db.update(_db.series)..where((s) => s.id.equals(serieId))).write(
      SeriesCompanion(excluidoEm: Value(agora), atualizadoEm: Value(agora)),
    );
  }

  /// Séries válidas do treino, na ordem em que foram registradas.
  Future<List<Serie>> seriesDoTreino(String treinoId) {
    return (_db.select(_db.series)
          ..where((s) => s.treinoId.equals(treinoId) & s.excluidoEm.isNull())
          ..orderBy([(s) => OrderingTerm.asc(s.registradaEm)]))
        .get();
  }

  /// Ajustes (modo PR, aquecimento) dos exercícios deste treino.
  Future<List<AjusteExecucao>> ajustesDoTreino(String treinoId) {
    return (_db.select(
      _db.ajustesExecucao,
    )..where((a) => a.treinoId.equals(treinoId) & a.excluidoEm.isNull())).get();
  }

  /// Liga ou desliga o modo PR e/ou o aquecimento de um exercício no treino.
  /// Cria a linha na primeira vez; depois só atualiza os campos informados.
  Future<void> salvarAjuste({
    required String treinoId,
    required String itemPlanoId,
    bool? progressaoPr,
    bool? aquecimento,
    bool? novoZeroRespondido,
  }) async {
    final agora = _agora();
    final existente =
        await (_db.select(_db.ajustesExecucao)..where(
              (a) =>
                  a.treinoId.equals(treinoId) &
                  a.itemPlanoId.equals(itemPlanoId),
            ))
            .getSingleOrNull();

    if (existente == null) {
      await _db
          .into(_db.ajustesExecucao)
          .insert(
            AjustesExecucaoCompanion.insert(
              id: const Uuid().v4(),
              treinoId: treinoId,
              itemPlanoId: itemPlanoId,
              progressaoPr: Value(progressaoPr ?? false),
              aquecimento: Value(aquecimento ?? false),
              novoZeroRespondido: Value(novoZeroRespondido ?? false),
              atualizadoEm: Value(agora),
            ),
          );
      return;
    }
    await (_db.update(
      _db.ajustesExecucao,
    )..where((a) => a.id.equals(existente.id))).write(
      AjustesExecucaoCompanion(
        progressaoPr: Value.absentIfNull(progressaoPr),
        aquecimento: Value.absentIfNull(aquecimento),
        novoZeroRespondido: Value.absentIfNull(novoZeroRespondido),
        atualizadoEm: Value(agora),
      ),
    );
  }

  /// Para cada exercício, as séries do treino anterior mais recente em que ele
  /// apareceu, ordenadas pelo número da série.
  Future<Map<String, List<Serie>>> ultimaVez(
    Iterable<String> exercicioIds, {
    required String excetoTreinoId,
  }) async {
    final ids = exercicioIds.toSet();
    if (ids.isEmpty) return {};

    final series =
        await (_db.select(_db.series)
              ..where(
                (s) =>
                    s.exercicioId.isIn(ids) &
                    s.treinoId.equals(excetoTreinoId).not() &
                    s.aquecimento.equals(false) &
                    s.excluidoEm.isNull(),
              )
              ..orderBy([(s) => OrderingTerm.desc(s.registradaEm)]))
            .get();

    final resultado = <String, List<Serie>>{};
    final treinoMaisRecente = <String, String>{};
    for (final s in series) {
      final treinoId = treinoMaisRecente.putIfAbsent(
        s.exercicioId,
        () => s.treinoId,
      );
      if (s.treinoId == treinoId) {
        resultado.putIfAbsent(s.exercicioId, () => []).add(s);
      }
    }
    for (final lista in resultado.values) {
      lista.sort((a, b) => a.numero.compareTo(b.numero));
    }
    return resultado;
  }
}
