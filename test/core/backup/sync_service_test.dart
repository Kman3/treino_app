import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/core/backup/backup_nuvem.dart';
import 'package:treino_app/core/backup/sync_service.dart';
import 'package:treino_app/core/db/app_database.dart';
import 'package:treino_app/core/db/repositorios/plano_repository.dart';
import 'package:treino_app/core/db/repositorios/treino_repository.dart';

import '../../helpers.dart';
import '../../nuvem_falsa.dart';

/// Etapa 5: backup no Supabase (aqui, numa nuvem em memória).
void main() {
  const kleber = ContaAtual(id: 'conta-kleber', email: 'kleber@exemplo.com');
  late AppDatabase db;
  late NuvemFalsa nuvem;
  late DateTime agora;
  late SyncService sync;
  late TreinoRepository treinos;
  late PlanoRepository planos;

  DateTime relogio() => agora;

  setUp(() async {
    agora = DateTime(2026, 11, 8, 7);
    db = abrirBancoDeTeste();
    await popularSeedDeTeste(db, agora: agora);
    nuvem = NuvemFalsa(conta: kleber);
    sync = SyncService(db, nuvem, agora: relogio);
    treinos = TreinoRepository(db, agora: relogio);
    planos = PlanoRepository(db, agora: relogio);
  });
  tearDown(() => db.close());

  /// Um treino com uma série registrada (60 kg × 10).
  Future<Serie> treinoComUmaSerie(AppDatabase banco, {DateTime? quando}) async {
    final p = PlanoRepository(banco, agora: () => quando ?? agora);
    final t = TreinoRepository(banco, agora: () => quando ?? agora);
    final dia = (await p.treinoDoDia())!;
    final treino = await t.iniciar(dia.sessao.sessao.id);
    return t.registrarSerie(
      treinoId: treino.id,
      item: dia.sessao.itens.first.item,
      numero: 1,
      cargaPlanKg: 60,
      repsPlan: 10,
      cargaKg: 60,
      reps: 10,
    );
  }

  Future<ResultadoSync> sincronizar() {
    agora = agora.add(const Duration(minutes: 1));
    return sync.sincronizar(usuarioId: kleber.id);
  }

  test('o primeiro backup sobe tudo e depois só o que mudou', () async {
    final serie = await treinoComUmaSerie(db);

    final primeiro = await sincronizar();
    expect(nuvem.contar('planos_treino'), 1);
    expect(nuvem.contar('sessoes_plano'), 3);
    expect(nuvem.contar('itens_plano'), 18);
    expect(nuvem.contar('treinos'), 1);
    expect(nuvem.contar('series'), 1);
    expect(primeiro.enviadas, 1 + 3 + 18 + 1 + 1);
    expect(await sync.pendentes(), 0);
    expect(await sync.ultimoBackup(), agora);

    // Tipos como o Postgres espera: booleanos, datas em UTC e o dono.
    final naNuvem = nuvem.linha('series', serie.id)!;
    expect(naNuvem['usuario_id'], kleber.id);
    expect(naNuvem['aquecimento'], false);
    expect(naNuvem['carga_kg'], 60);
    expect(naNuvem['registrada_em'], endsWith('Z'));
    expect(naNuvem.containsKey('sincronizado_em'), isFalse);

    final segundo = await sincronizar();
    expect(segundo.enviadas, 0);

    agora = agora.add(const Duration(minutes: 1));
    await treinos.corrigirSerie(serie, cargaKg: 62.5, reps: 8);
    expect(await sync.pendentes(), 1);
    final terceiro = await sincronizar();
    expect(terceiro.enviadas, 1);
    expect(nuvem.linha('series', serie.id)!['reps'], 8);
  });

  test('desce o treino feito em outro aparelho da mesma conta', () async {
    await sincronizar();
    final sessaoB = (await planos.sessoesComItens())[1];
    final quando = agora
        .add(const Duration(hours: 1))
        .toUtc()
        .toIso8601String();
    nuvem
      ..gravarDireto('treinos', {
        'usuario_id': kleber.id,
        'id': 'treino-do-outro',
        'sessao_plano_id': sessaoB.sessao.id,
        'iniciado_em': quando,
        'finalizado_em': quando,
        'status': 'concluido',
        'modo': 'normal',
        'atualizado_em': quando,
        'excluido_em': null,
      })
      ..gravarDireto('series', {
        'usuario_id': kleber.id,
        'id': 'serie-do-outro',
        'treino_id': 'treino-do-outro',
        'item_plano_id': sessaoB.itens.first.item.id,
        'exercicio_id': sessaoB.itens.first.exercicio.id,
        'numero': 1,
        'carga_plan_kg': 55,
        'reps_plan': 12,
        'carga_kg': 57.5,
        'reps': 11,
        'rir': 2,
        'confirmado': true,
        'editado': true,
        'dor': false,
        'aquecimento': false,
        'manter_carga': false,
        'registrada_em': quando,
        'atualizado_em': quando,
      });

    final resultado = await sincronizar();
    expect(resultado.recebidas, 2);

    final treino = (await treinos.treino('treino-do-outro'))!;
    expect(treino.status, 'concluido');
    final series = await treinos.seriesDoTreino('treino-do-outro');
    expect(series.single.cargaKg, 57.5);
    expect(series.single.confirmado, isTrue);
    expect(series.single.registradaEm, DateTime.parse(quando).toLocal());
    // Veio da nuvem: não sobe de volta.
    expect(await sync.pendentes(), 0);
  });

  test('em conflito vale o atualizado_em mais recente', () async {
    final serie = await treinoComUmaSerie(db);
    await sincronizar();

    // Outro aparelho mudou antes; este mudou depois: vale a deste.
    final antes = agora.add(const Duration(seconds: 10));
    final naNuvem = Map.of(nuvem.linha('series', serie.id)!)
      ..['reps'] = 6
      ..['atualizado_em'] = antes.toUtc().toIso8601String();
    nuvem.gravarDireto('series', naNuvem);
    agora = agora.add(const Duration(seconds: 30));
    await treinos.corrigirSerie(serie, cargaKg: 60, reps: 9);
    await sincronizar();
    expect((await treinos.seriesDoTreino(serie.treinoId)).single.reps, 9);
    expect(nuvem.linha('series', serie.id)!['reps'], 9);

    // Agora a nuvem tem a mais nova: ela vale.
    final depois = agora.add(const Duration(minutes: 5));
    final maisNova = Map.of(nuvem.linha('series', serie.id)!)
      ..['reps'] = 7
      ..['atualizado_em'] = depois.toUtc().toIso8601String();
    nuvem.gravarDireto('series', maisNova);
    agora = depois;
    await sincronizar();
    expect((await treinos.seriesDoTreino(serie.treinoId)).single.reps, 7);
  });

  test(
    'num celular novo, o plano da nuvem toma o lugar do de exemplo',
    () async {
      await treinoComUmaSerie(db);
      await sincronizar();
      final planoOriginal = (await planos.planoAtivo())!.id;

      // Celular novo: banco novo, com o plano de exemplo e ids próprios.
      final novo = abrirBancoDeTeste();
      addTearDown(novo.close);
      await popularSeedDeTeste(novo, agora: agora);
      final planosNovo = PlanoRepository(novo, agora: relogio);
      expect((await planosNovo.planoAtivo())!.id, isNot(planoOriginal));

      final resultado = await SyncService(
        novo,
        nuvem,
        agora: relogio,
      ).sincronizar(usuarioId: kleber.id);

      expect(resultado.restaurou, isTrue);
      expect(await novo.select(novo.planosTreino).get(), hasLength(1));
      expect((await planosNovo.planoAtivo())!.id, planoOriginal);
      expect(await novo.select(novo.treinos).get(), hasLength(1));
      expect(await novo.select(novo.series).get(), hasLength(1));
      expect(await novo.select(novo.itensPlano).get(), hasLength(18));
    },
  );

  test('com histórico local, nada é apagado no primeiro login', () async {
    await treinoComUmaSerie(db);
    nuvem.gravarDireto('planos_treino', {
      'usuario_id': kleber.id,
      'id': 'plano-antigo',
      'divisao': 'AB',
      'semanas': 4,
      'inicio_em': '2026-01-01T03:00:00.000Z',
      'versao': 1,
      'ativo': false,
      'atualizado_em': '2026-01-01T03:00:00.000Z',
      'excluido_em': null,
    });

    final resultado = await sincronizar();
    expect(resultado.restaurou, isFalse);
    expect(await db.select(db.planosTreino).get(), hasLength(2));
    expect(await db.select(db.treinos).get(), hasLength(1));
  });

  test('sem internet nada é marcado e o erro chega com a frase', () async {
    await treinoComUmaSerie(db);
    final antes = await sync.pendentes();
    nuvem.semInternet = true;

    await expectLater(
      sincronizar(),
      throwsA(
        isA<ErroBackup>().having(
          (e) => e.mensagem,
          'mensagem',
          contains('internet'),
        ),
      ),
    );
    expect(await sync.pendentes(), antes);
    expect(await sync.ultimoBackup(), isNull);
  });

  test('sair da conta faz o histórico subir inteiro para a próxima', () async {
    await treinoComUmaSerie(db);
    await sincronizar();
    expect(await sync.pendentes(), 0);

    await sync.esquecerConta();
    expect(await sync.pendentes(), 1 + 3 + 18 + 1 + 1);
    expect(await sync.ultimoBackup(), isNull);
    expect(await db.select(db.estadosSync).get(), isEmpty);
  });

  test('a exclusão de uma série também vai para a nuvem', () async {
    final serie = await treinoComUmaSerie(db);
    await sincronizar();
    agora = agora.add(const Duration(minutes: 1));
    await treinos.excluirSerie(serie.id);
    await sincronizar();
    expect(nuvem.linha('series', serie.id)!['excluido_em'], isNotNull);
    // E o que já estava sincronizado não é reenviado à toa.
    final lida = await (db.select(
      db.series,
    )..where((s) => s.id.equals(serie.id))).getSingle();
    expect(lida.sincronizadoEm, isNotNull);
  });
}
