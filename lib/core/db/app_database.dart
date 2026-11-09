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
    Preferencias,
    EstadosSync,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Sem [executor], abre o arquivo `treino_app` na pasta de dados do app.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'treino_app'));

  /// 1: tabelas da seção 5 do PRD.
  /// 2: `ajustes_execucao` e `series.aquecimento` (modo PR e aquecimento).
  /// 3: descanso em `treinos`, `series.manter_carga`,
  ///    `ajustes_execucao.novo_zero_respondido` e `preferencias`.
  /// 4: troca de exercício por treino ou para sempre (`substituicoes`) e
  ///    "Senti dor" (`ajustes_execucao.removido` e `.dor`).
  /// 5: `estados_sync`, o estado do backup no Supabase neste aparelho.
  @override
  int get schemaVersion => 5;

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
      from2To3: (m, esquema) async {
        await m.addColumn(esquema.treinos, esquema.treinos.descansoTerminaEm);
        await m.addColumn(esquema.treinos, esquema.treinos.descansoSerieId);
        await m.addColumn(esquema.series, esquema.series.manterCarga);
        await m.addColumn(
          esquema.ajustesExecucao,
          esquema.ajustesExecucao.novoZeroRespondido,
        );
        await m.createTable(esquema.preferencias);
      },
      from3To4: (m, esquema) async {
        final subs = esquema.substituicoes;
        await m.addColumn(subs, subs.treinoId);
        await m.addColumn(subs, subs.cargaKg);
        await m.addColumn(subs, subs.cargaOriginalKg);
        final ajustes = esquema.ajustesExecucao;
        await m.addColumn(ajustes, ajustes.removido);
        await m.addColumn(ajustes, ajustes.dor);
      },
      from4To5: (m, esquema) async {
        await m.createTable(esquema.estadosSync);
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
