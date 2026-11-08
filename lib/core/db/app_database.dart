import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

export 'tables.dart';

part 'app_database.g.dart';

/// Banco local: a fonte da verdade do app. O Supabase guarda só uma cópia.
@DriftDatabase(
  tables: [
    Exercicios,
    PlanosTreino,
    SessoesPlano,
    ItensPlano,
    Treinos,
    Series,
    Substituicoes,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Sem [executor], abre o arquivo `treino_app` na pasta de dados do app.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'treino_app'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
