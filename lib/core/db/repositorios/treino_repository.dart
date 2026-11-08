import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

/// Execuções reais de treino. O registro de séries entra na etapa 2.
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
}
