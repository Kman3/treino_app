import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

/// Execuções reais de treino e as séries registradas nelas.
class TreinoRepository {
  TreinoRepository(this._db, {DateTime Function()? agora})
    : _agora = agora ?? DateTime.now;

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
              atualizadoEm: Value(agora),
            ),
          );
      return;
    }
    await (_db.update(
      _db.ajustesExecucao,
    )..where((a) => a.id.equals(existente.id))).write(
      AjustesExecucaoCompanion(
        progressaoPr: progressaoPr == null
            ? const Value.absent()
            : Value(progressaoPr),
        aquecimento: aquecimento == null
            ? const Value.absent()
            : Value(aquecimento),
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
