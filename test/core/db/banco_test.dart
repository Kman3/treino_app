import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/core/db/app_database.dart';

import '../../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = abrirBancoDeTeste());
  tearDown(() => db.close());

  test('cria as tabelas da seção 5 do PRD e os ajustes de execução', () async {
    final linhas = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' "
          "AND name NOT LIKE 'sqlite_%'",
        )
        .get();

    expect(
      linhas.map((l) => l.read<String>('name')),
      unorderedEquals([
        'exercicios',
        'planos_treino',
        'sessoes_plano',
        'itens_plano',
        'treinos',
        'series',
        'substituicoes',
        'ajustes_execucao',
        'preferencias',
        'estados_sync',
      ]),
    );
  });

  test('tabelas do usuário têm as colunas de sync', () async {
    for (final tabela in [
      'planos_treino',
      'sessoes_plano',
      'itens_plano',
      'treinos',
      'series',
      'substituicoes',
      'ajustes_execucao',
      'preferencias',
    ]) {
      final colunas = await db
          .customSelect('PRAGMA table_info($tabela)')
          .map((l) => l.read<String>('name'))
          .get();
      expect(
        colunas,
        containsAll(['id', 'atualizado_em', 'excluido_em', 'sincronizado_em']),
        reason: tabela,
      );
    }
  });

  test('chaves estrangeiras estão ligadas', () async {
    final ativo = await db
        .customSelect('PRAGMA foreign_keys')
        .map((l) => l.read<int>('foreign_keys'))
        .getSingle();
    expect(ativo, 1);

    // Sessão apontando para um plano que não existe.
    await expectLater(
      db
          .into(db.sessoesPlano)
          .insert(
            SessoesPlanoCompanion.insert(
              id: 's1',
              planoId: 'nao-existe',
              dia: 'A',
              foco: 'x',
              ordem: 0,
            ),
          ),
      throwsA(isA<Exception>()),
    );
  });

  test('rir só aceita valores de 0 a 4', () async {
    await popularSeedDeTeste(db);
    final sessao = await db.select(db.sessoesPlano).get();
    await db
        .into(db.treinos)
        .insert(
          TreinosCompanion.insert(
            id: 't1',
            sessaoPlanoId: sessao.first.id,
            iniciadoEm: DateTime(2026, 10, 20),
          ),
        );

    SeriesCompanion serie(String id, int? rir) => SeriesCompanion.insert(
      id: id,
      treinoId: 't1',
      exercicioId: 'supino-reto-barra',
      numero: 1,
      registradaEm: DateTime(2026, 10, 20),
      rir: Value(rir),
    );

    await db.into(db.series).insert(serie('ok-nulo', null));
    await db.into(db.series).insert(serie('ok-zero', 0));
    await db.into(db.series).insert(serie('ok-quatro', 4));
    await expectLater(
      db.into(db.series).insert(serie('invalido', 5)),
      throwsA(isA<Exception>()),
    );
  });

  test(
    'quandoMudar com chaves diferentes observa tabelas diferentes',
    () async {
      await popularSeedDeTeste(db);
      final sessao = (await db.select(db.sessoesPlano).get()).first;

      // Abre primeiro um observador que não olha `series`: com SQL igual, o
      // drift reaproveitaria este stream para o segundo.
      final semSeries = db.quandoMudar('a', {db.treinos}).listen((_) {});
      addTearDown(semSeries.cancel);

      final emissoes = db.quandoMudar('b', {db.series}).take(2).toList();
      await Future<void>.delayed(Duration.zero);

      await db
          .into(db.treinos)
          .insert(
            TreinosCompanion.insert(
              id: 't1',
              sessaoPlanoId: sessao.id,
              iniciadoEm: DateTime(2026, 11, 8),
            ),
          );
      await db
          .into(db.series)
          .insert(
            SeriesCompanion.insert(
              id: 's1',
              treinoId: 't1',
              exercicioId: 'supino-reto-barra',
              numero: 1,
              registradaEm: DateTime(2026, 11, 8),
            ),
          );

      expect(await emissoes.timeout(const Duration(seconds: 2)), hasLength(2));
    },
  );

  test('datas ficam gravadas como texto ISO 8601', () async {
    await popularSeedDeTeste(db, agora: DateTime(2026, 10, 20, 15));
    final inicio = await db
        .customSelect('SELECT inicio_em FROM planos_treino')
        .map((l) => l.read<String>('inicio_em'))
        .getSingle();
    expect(inicio, startsWith('2026-10-20T00:00:00'));
  });
}
