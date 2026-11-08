// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart' hide isNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/core/db/app_database.dart';

import 'generated/schema.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verificador;

  setUpAll(() {
    verificador = SchemaVerifier(GeneratedHelper());
  });

  // Confere que cada migração leva o esquema exatamente ao da versão nova.
  group('migrações sem dados', () {
    const versoes = GeneratedHelper.versions;
    for (final (i, de) in versoes.indexed) {
      group('da v$de', () {
        for (final para in versoes.skip(i + 1)) {
          test('para v$para', () async {
            final esquema = await verificador.schemaAt(de);
            final db = AppDatabase(esquema.newConnection());
            await verificador.migrateAndValidate(db, para);
            await db.close();
          });
        }
      });
    }
  });

  test('v2 → v4 mantém séries e ajustes e cria as preferências', () async {
    final esquema = await verificador.schemaAt(2);
    final sql = esquema.rawDatabase;
    const agora = '2026-11-08T07:00:00.000';
    sql
      ..execute(
        "INSERT INTO exercicios (id, nome, musculos_alvo, padrao_movimento, "
        "equipamento, tipo_carga, passo_carga_kg) VALUES ('supino', 'Supino', "
        "'Peitoral', 'empurrar-horizontal', 'barra', 'externa', 2.5)",
      )
      ..execute(
        "INSERT INTO planos_treino (id, divisao, semanas, inicio_em, "
        "atualizado_em) VALUES ('p1', 'ABC', 4, '$agora', '$agora')",
      )
      ..execute(
        "INSERT INTO sessoes_plano (id, plano_id, dia, foco, ordem, "
        "atualizado_em) VALUES ('s1', 'p1', 'A', 'Peito', 0, '$agora')",
      )
      ..execute(
        "INSERT INTO itens_plano (id, sessao_plano_id, exercicio_id, ordem, "
        "series, reps_min, reps_max, descanso_s, carga_plan_kg, atualizado_em) "
        "VALUES ('i1', 's1', 'supino', 0, 4, 6, 10, 150, 60, '$agora')",
      )
      ..execute(
        "INSERT INTO treinos (id, sessao_plano_id, iniciado_em, atualizado_em) "
        "VALUES ('t1', 's1', '$agora', '$agora')",
      )
      ..execute(
        "INSERT INTO series (id, treino_id, item_plano_id, exercicio_id, "
        "numero, carga_kg, reps, aquecimento, registrada_em, atualizado_em) "
        "VALUES ('serie1', 't1', 'i1', 'supino', 1, 60, 10, 0, '$agora', "
        "'$agora')",
      )
      ..execute(
        "INSERT INTO ajustes_execucao (id, treino_id, item_plano_id, "
        "progressao_pr, atualizado_em) VALUES ('a1', 't1', 'i1', 1, '$agora')",
      );

    final db = AppDatabase(esquema.newConnection());
    await verificador.migrateAndValidate(db, 4);

    final serie = await db.select(db.series).getSingle();
    expect(serie.cargaKg, 60);
    expect(serie.manterCarga, isFalse);
    final treino = await db.select(db.treinos).getSingle();
    expect(treino.descansoTerminaEm, isNull);
    final ajuste = await db.select(db.ajustesExecucao).getSingle();
    expect(ajuste.progressaoPr, isTrue);
    expect(ajuste.novoZeroRespondido, isFalse);
    expect(await db.select(db.preferencias).get(), isEmpty);

    await db.close();
  });

  test('v3 → v4 mantém trocas e ajustes, com os campos novos vazios', () async {
    final esquema = await verificador.schemaAt(3);
    final sql = esquema.rawDatabase;
    const agora = '2026-11-08T07:00:00.000';
    sql
      ..execute(
        "INSERT INTO exercicios (id, nome, musculos_alvo, padrao_movimento, "
        "equipamento, tipo_carga, passo_carga_kg) VALUES "
        "('supino', 'Supino', 'Peitoral', 'empurrar-horizontal', 'barra', "
        "'externa', 2.5), ('maquina', 'Supino máquina', 'Peitoral', "
        "'empurrar-horizontal', 'maquina', 'externa', 5)",
      )
      ..execute(
        "INSERT INTO planos_treino (id, divisao, semanas, inicio_em, "
        "atualizado_em) VALUES ('p1', 'ABC', 4, '$agora', '$agora')",
      )
      ..execute(
        "INSERT INTO sessoes_plano (id, plano_id, dia, foco, ordem, "
        "atualizado_em) VALUES ('s1', 'p1', 'A', 'Peito', 0, '$agora')",
      )
      ..execute(
        "INSERT INTO itens_plano (id, sessao_plano_id, exercicio_id, ordem, "
        "series, reps_min, reps_max, descanso_s, carga_plan_kg, atualizado_em) "
        "VALUES ('i1', 's1', 'supino', 0, 4, 6, 10, 150, 60, '$agora')",
      )
      ..execute(
        "INSERT INTO treinos (id, sessao_plano_id, iniciado_em, atualizado_em) "
        "VALUES ('t1', 's1', '$agora', '$agora')",
      )
      ..execute(
        "INSERT INTO substituicoes (id, item_plano_id, exercicio_original_id, "
        "exercicio_novo_id, escopo, atualizado_em) VALUES ('sub1', 'i1', "
        "'supino', 'maquina', 'sessao', '$agora')",
      )
      ..execute(
        "INSERT INTO ajustes_execucao (id, treino_id, item_plano_id, "
        "progressao_pr, atualizado_em) VALUES ('a1', 't1', 'i1', 1, '$agora')",
      );

    final db = AppDatabase(esquema.newConnection());
    await verificador.migrateAndValidate(db, 4);

    final troca = await db.select(db.substituicoes).getSingle();
    expect(troca.exercicioNovoId, 'maquina');
    expect(troca.treinoId, isNull);
    expect(troca.cargaKg, isNull);
    final ajuste = await db.select(db.ajustesExecucao).getSingle();
    expect(ajuste.progressaoPr, isTrue);
    expect(ajuste.removido, isFalse);
    expect(ajuste.dor, isFalse);

    await db.close();
  });

  test('v1 → v4 mantém treinos e séries já gravados', () async {
    final esquema = await verificador.schemaAt(1);
    final sql = esquema.rawDatabase;
    const agora = '2026-11-08T07:00:00.000';
    sql
      ..execute(
        "INSERT INTO exercicios (id, nome, musculos_alvo, padrao_movimento, "
        "equipamento, tipo_carga, passo_carga_kg) VALUES ('supino', 'Supino', "
        "'Peitoral', 'empurrar-horizontal', 'barra', 'externa', 2.5)",
      )
      ..execute(
        "INSERT INTO planos_treino (id, divisao, semanas, inicio_em, "
        "atualizado_em) VALUES ('p1', 'ABC', 4, '$agora', '$agora')",
      )
      ..execute(
        "INSERT INTO sessoes_plano (id, plano_id, dia, foco, ordem, "
        "atualizado_em) VALUES ('s1', 'p1', 'A', 'Peito', 0, '$agora')",
      )
      ..execute(
        "INSERT INTO treinos (id, sessao_plano_id, iniciado_em, atualizado_em) "
        "VALUES ('t1', 's1', '$agora', '$agora')",
      )
      ..execute(
        "INSERT INTO series (id, treino_id, exercicio_id, numero, carga_kg, "
        "reps, registrada_em, atualizado_em) VALUES ('serie1', 't1', 'supino', "
        "1, 60, 10, '$agora', '$agora')",
      );

    final db = AppDatabase(esquema.newConnection());
    await verificador.migrateAndValidate(db, 4);

    final serie = await db.select(db.series).getSingle();
    expect(serie.id, 'serie1');
    expect(serie.cargaKg, 60);
    expect(serie.reps, 10);
    expect(serie.aquecimento, isFalse);
    expect(await db.select(db.ajustesExecucao).get(), isEmpty);

    await db.close();
  });
}
