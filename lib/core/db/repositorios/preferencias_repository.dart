import 'package:clock/clock.dart';

import '../app_database.dart';

/// Perfil → Preferências de treino, numa linha só.
class PreferenciasRepository {
  PreferenciasRepository(this._db, {DateTime Function()? agora})
    : _agora = agora ?? clock.now;

  final AppDatabase _db;
  final DateTime Function() _agora;

  /// As preferências salvas, ou as padrão se a pessoa nunca mudou nada.
  Future<Preferencia> obter() async {
    final salva = await (_db.select(
      _db.preferencias,
    )..where((p) => p.id.equals(Preferencias.idLocal))).getSingleOrNull();
    return salva ??
        Preferencia(
          id: Preferencias.idLocal,
          sugestaoCargaMenor: true,
          modoNovoZero: '1rm',
          atualizadoEm: _agora(),
        );
  }

  Stream<Preferencia> watch() => _db
      .quandoMudar('preferencias', {_db.preferencias})
      .asyncMap((_) => obter());

  /// Muda só o que for informado.
  Future<void> salvar({bool? sugestaoCargaMenor, String? modoNovoZero}) async {
    final atual = await obter();
    await _db
        .into(_db.preferencias)
        .insertOnConflictUpdate(
          atual
              .copyWith(
                sugestaoCargaMenor: sugestaoCargaMenor,
                modoNovoZero: modoNovoZero,
                atualizadoEm: _agora(),
              )
              .toCompanion(true),
        );
  }
}
