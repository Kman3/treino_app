import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/core/db/app_database.dart';
import 'package:treino_app/core/db/repositorios/evolucao_repository.dart';
import 'package:treino_app/core/db/repositorios/exercicio_repository.dart';
import 'package:treino_app/core/db/repositorios/plano_repository.dart';
import 'package:treino_app/core/db/repositorios/treino_repository.dart';
import 'package:treino_app/features/execucao/estado_execucao.dart';
import 'package:treino_app/features/execucao/sessao_treino_controller.dart';
import 'package:treino_app/features/execucao/versao_reduzida.dart';

import '../../helpers.dart';

/// Etapa 4: versão de 20 minutos, "Ocupado", "Senti dor" e evolução.
void main() {
  late AppDatabase db;
  late DateTime agora;
  late PlanoRepository planos;
  late TreinoRepository treinos;
  late ExercicioRepository exercicios;
  late SessaoTreinoController controller;

  setUp(() async {
    db = abrirBancoDeTeste();
    agora = DateTime(2026, 11, 8, 7);
    DateTime relogio() => agora;
    planos = PlanoRepository(db, agora: relogio);
    treinos = TreinoRepository(db, agora: relogio);
    exercicios = ExercicioRepository(db, agora: relogio);
    controller = SessaoTreinoController(
      db,
      planos,
      treinos,
      exercicios: exercicios,
      agora: relogio,
    );
    await popularSeedDeTeste(db, agora: agora);
  });
  tearDown(() => db.close());

  Future<EstadoExecucao> iniciar({bool vinteMinutos = false}) async {
    final dia = (await planos.treinoDoDia())!;
    final id = await controller.iniciar(
      dia.sessao.sessao.id,
      vinteMinutos: vinteMinutos,
    );
    return (await controller.carregar(id))!;
  }

  Future<EstadoExecucao> recarregar(EstadoExecucao estado) async =>
      (await controller.carregar(estado.treino.id))!;

  Future<EstadoExecucao> registrar(
    EstadoExecucao estado, {
    double? cargaKg,
    int? reps,
  }) async {
    await controller.registrar(estado, cargaKg: cargaKg, reps: reps);
    agora = agora.add(const Duration(minutes: 3));
    final depois = await recarregar(estado);
    await controller.encerrarDescanso(depois);
    return recarregar(depois);
  }

  Future<Exercicio> exercicio(String id) async =>
      (await exercicios.exercicio(id))!;

  group('versão de 20 minutos', () {
    test('fica com os multiarticulares, 2 séries e até 60 s', () async {
      final sessao = (await planos.treinoDoDia())!.sessao;
      final reduzida = versaoVinteMinutos(sessao.itens);

      expect(reduzida.map((i) => i.exercicio.id), [
        'supino-reto-barra',
        'supino-inclinado-halteres',
        'desenvolvimento-halteres',
      ]);
      expect(reduzida.map((i) => i.item.series), everyElement(2));
      expect(reduzida.map((i) => i.item.descansoS), everyElement(60));
      expect(reduzida.first.item.cargaPlanKg, 60);
    });

    test('o treino usa a versão reduzida sem mudar o plano', () async {
      final estado = await iniciar(vinteMinutos: true);
      expect(estado.vinteMinutos, isTrue);
      expect(estado.sessao.itens, hasLength(3));
      expect(estado.totalSeries, 6);

      final inicio = agora;
      await controller.registrar(estado);
      final depois = await recarregar(estado);
      expect(depois.descansoTerminaEm, inicio.add(const Duration(seconds: 60)));

      final doPlano = await planos.sessaoComItens(estado.sessao.sessao.id);
      expect(doPlano!.itens, hasLength(6));
      expect(doPlano.itens.first.item.series, 4);
    });
  });

  group('Ocupado', () {
    test('troca só hoje: as próximas séries usam o substituto', () async {
      var estado = await registrar(await iniciar());
      final item = estado.atual!.item;
      final maquina = await exercicio('supino-maquina');

      final troca = await controller.trocar(
        estado,
        item,
        maquina,
        sempre: false,
        cargaKg: 60,
      );
      estado = await recarregar(estado);
      final trocado = estado.atual!.item;
      expect(trocado.exercicio.id, 'supino-maquina');
      expect(trocado.original!.id, 'supino-reto-barra');
      expect(estado.atual!.numero, 2);
      expect(estado.atual!.cargaPlanKg, 60);

      estado = await registrar(estado);
      final series = estado.seriesDoItem(item.item.id);
      expect(series.map((s) => s.exercicioId), [
        'supino-reto-barra',
        'supino-maquina',
      ]);
      // O plano continua com o supino reto.
      expect(
        (await planos.item(item.item.id))!.exercicioId,
        'supino-reto-barra',
      );

      await controller.desfazerTroca(troca);
      estado = await recarregar(estado);
      expect(estado.atual!.item.exercicio.id, 'supino-reto-barra');
      expect(estado.atual!.item.original, isNull);
    });

    test('troca para sempre muda o plano; desfazer devolve', () async {
      final estado = await iniciar();
      final item = estado.atual!.item;
      final troca = await controller.trocar(
        estado,
        item,
        await exercicio('supino-maquina'),
        sempre: true,
        cargaKg: 55,
      );

      var noPlano = (await planos.item(item.item.id))!;
      expect(noPlano.exercicioId, 'supino-maquina');
      expect(noPlano.cargaPlanKg, 55);
      final depois = await recarregar(estado);
      expect(depois.atual!.item.exercicio.id, 'supino-maquina');
      expect(depois.atual!.item.original, isNull);

      await controller.desfazerTroca(troca);
      noPlano = (await planos.item(item.item.id))!;
      expect(noPlano.exercicioId, 'supino-reto-barra');
      expect(noPlano.cargaPlanKg, 60);
    });

    test('substitutos são do mesmo padrão de movimento', () async {
      final nomes = (await exercicios.substitutos(
        await exercicio('supino-reto-barra'),
      )).map((e) => e.id);
      expect(
        nomes,
        unorderedEquals([
          'supino-inclinado-halteres',
          'supino-maquina',
          'flexao-bracos',
        ]),
      );
    });
  });

  group('Senti dor', () {
    test('antes da primeira série, o exercício sai do treino', () async {
      var estado = await iniciar();
      final item = estado.atual!.item;
      final registro = await controller.sentiDor(estado, item, tirar: true);

      estado = await recarregar(estado);
      expect(
        estado.sessao.itens.first.exercicio.id,
        'supino-inclinado-halteres',
      );
      expect(estado.removidos.single.item.id, item.item.id);

      await controller.desfazerDor(estado, registro);
      estado = await recarregar(estado);
      expect(estado.sessao.itens.first.exercicio.id, 'supino-reto-barra');
      expect(estado.removidos, isEmpty);
    });

    test('no meio, as séries feitas ficam e ganham a marca de dor', () async {
      var estado = await registrar(await registrar(await iniciar()));
      final item = estado.atual!.item;
      await controller.sentiDor(estado, item, tirar: true);

      estado = await recarregar(estado);
      final ficou = estado.sessao.itens.first;
      expect(ficou.item.series, 2);
      expect(estado.dorEm(ficou), isTrue);
      expect(estado.seriesDoItem(ficou.item.id).map((s) => s.dor), [
        true,
        true,
      ]);
      expect(estado.atual!.indiceItem, 1);
      expect(estado.totalSeries, 2 + 3 + 3 + 3 + 3 + 3);
    });

    test('trocar por outro registra a dor e mantém o exercício', () async {
      var estado = await iniciar();
      final item = estado.atual!.item;
      await controller.sentiDor(estado, item, tirar: false);
      estado = await recarregar(estado);
      expect(estado.sessao.itens.first.item.id, item.item.id);
      expect(estado.dorEm(estado.sessao.itens.first), isTrue);
    });
  });

  group('evolução', () {
    late EvolucaoRepository evolucao;
    setUp(() => evolucao = EvolucaoRepository(db));

    Future<void> treinoCom(
      List<(double, int)> series, {
      int diasAtras = 0,
    }) async {
      // Sempre o Treino A: o "treino do dia" avança a cada treino finalizado.
      final sessaoA = (await planos.sessoesComItens()).first;
      final item = sessaoA.itens.first.item;
      final quando = agora;
      agora = DateTime(2026, 11, 8, 7).subtract(Duration(days: diasAtras));
      final treino = await treinos.iniciar(sessaoA.sessao.id);
      for (final (i, (carga, reps)) in series.indexed) {
        await treinos.registrarSerie(
          treinoId: treino.id,
          item: item,
          numero: i + 1,
          cargaPlanKg: 60,
          repsPlan: 10,
          cargaKg: carga,
          reps: reps,
        );
      }
      // Um aquecimento pesado não pode virar o melhor ponto.
      await treinos.registrarSerie(
        treinoId: treino.id,
        item: item,
        numero: 0,
        cargaPlanKg: 42.5,
        repsPlan: 6,
        cargaKg: 200,
        reps: 6,
        aquecimento: true,
      );
      await treinos.finalizar(treino.id);
      agora = quando;
    }

    test('1RM da melhor série de cada treino, com recorde', () async {
      await treinoCom([(60, 10), (60, 8)], diasAtras: 14);
      await treinoCom([(62.5, 10), (62.5, 7)], diasAtras: 7);
      await treinoCom([(60, 8)], diasAtras: 0);

      final e = (await evolucao.doExercicio('supino-reto-barra'))!;
      expect(e.metrica, MetricaEvolucao.umRm);
      expect(e.pontos.map((p) => p.valor), [
        closeTo(80, 1e-9),
        closeTo(83.33, 0.01),
        closeTo(76, 1e-9),
      ]);
      expect(e.pontos.map((p) => p.recorde), [false, true, false]);
      expect(e.pontos[1].cargaKg, 62.5);
      expect(e.pontos[1].reps, 10);
    });

    test('a janela de 8 semanas deixa de fora o treino antigo', () async {
      await treinoCom([(50, 10)], diasAtras: 70);
      await treinoCom([(60, 10)], diasAtras: 3);

      final e = (await evolucao.doExercicio('supino-reto-barra'))!;
      expect(e.pontos, hasLength(2));
      expect(e.ultimasSemanas(agora), hasLength(1));
      expect(e.ultimo!.recorde, isTrue);
    });
  });
}
