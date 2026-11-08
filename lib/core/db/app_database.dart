import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'app_database.steps.dart';
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
    AjustesExecucao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Sem [executor], abre o arquivo `treino_app` na pasta de dados do app.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'treino_app'));

  /// 1: tabelas da seção 5 do PRD.
  /// 2: `ajustes_execucao` e `series.aquecimento` (modo PR e aquecimento).
  @override
  int get schemaVersion => 2;

  /// Emite ao ouvir e de novo sempre que alguma das [tabelas] muda.
  ///
  /// [chave] precisa ser única por conjunto de tabelas: o drift compartilha
  /// streams de mesma SQL e variáveis, mesmo que leiam tabelas diferentes.
  Stream<void> quandoMudar(String chave, Set<ResultSetImplementation> tabelas) {
    return customSelect(
      'SELECT ? AS chave',
      variables: [Variable.withString(chave)],
      readsFrom: tabelas,
    ).watch();
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // Cada passo usa o esquema congelado daquela versão (app_database.steps.dart,
    // gerado por `dart run drift_dev make-migrations`).
    onUpgrade: stepByStep(
      from1To2: (m, esquema) async {
        await m.createTable(esquema.ajustesExecucao);
        await m.addColumn(esquema.series, esquema.series.aquecimento);
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
