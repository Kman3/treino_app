import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/core/db/app_database.dart';
import 'package:treino_app/core/db/repositorios/plano_repository.dart';
import 'package:treino_app/core/db/repositorios/preferencias_repository.dart';
import 'package:treino_app/core/db/repositorios/treino_repository.dart';
import 'package:treino_app/core/notificacoes/aviso_descanso.dart';
import 'package:treino_app/features/execucao/estado_execucao.dart';
import 'package:treino_app/features/execucao/sessao_treino_controller.dart';

import '../../helpers.dart';

/// Guarda o último aviso agendado, no lugar da notificação de verdade.
class AvisoFalso implements AvisoDescanso {
  DateTime? agendadoPara;
  int permissoes = 0;

  @override
  Future<void> pedirPermissao() async => permissoes++;

  @override
  Future<void> agendar(DateTime quando, {required String texto}) async =>
      agendadoPara = quando;

  @override
  Future<void> cancelar() async => agendadoPara = null;
}

void main() {
  late AppDatabase db;
  late DateTime agora;
  late PlanoRepository planos;
  late PreferenciasRepository preferencias;
  late AvisoFalso aviso;
  late SessaoTreinoController controller;

  SessaoTreinoController novoController() {
    DateTime relogio() => agora;
    planos = PlanoRepository(db, agora: relogio);
    preferencias = PreferenciasRepository(db, agora: relogio);
    aviso = AvisoFalso();
    return SessaoTreinoController(
      db,
      planos,
      TreinoRepository(db, agora: relogio),
      preferencias: preferencias,
      aviso: aviso,
      agora: relogio,
    );
  }

  setUp(() async {
    db = abrirBancoDeTeste();
    agora = DateTime(2026, 11, 8, 7);
    controller = novoController();
    await popularSeedDeTeste(db, agora: agora);
  });
  tearDown(() => db.close());

  Future<EstadoExecucao> iniciarTreinoDoDia() async {
    final dia = (await planos.treinoDoDia())!;
    final id = await controller.iniciar(dia.sessao.sessao.id);
    return (await controller.carregar(id))!;
  }

  /// Registra a série atual e avança o relógio, como num treino de verdade.
  Future<EstadoExecucao> registrar(
    EstadoExecucao estado, {
    double? cargaKg,
    int? reps,
  }) async {
    await controller.registrar(estado, cargaKg: cargaKg, reps: reps);
    agora = agora.add(const Duration(minutes: 2));
    return (await controller.carregar(estado.treino.id))!;
  }

  test('começa na série 1 do primeiro exercício', () async {
    final estado = await iniciarTreinoDoDia();

    expect(estado.atual!.indiceItem, 0);
    expect(estado.atual!.numero, 1);
    expect(estado.atual!.item.exercicio.id, 'supino-reto-barra');
    expect(estado.seriesFeitas, 0);
    expect(estado.totalSeries, 19);
  });

  test('registrar sem alterar grava o plano e não marca editado', () async {
    final depois = await registrar(await iniciarTreinoDoDia());

    final serie = depois.series.single;
    expect(serie.numero, 1);
    expect(serie.cargaKg, 60);
    expect(serie.cargaPlanKg, 60);
    expect(serie.reps, 10);
    expect(serie.repsPlan, 10);
    expect(serie.editado, isFalse);
    expect(serie.confirmado, isFalse);
    expect(serie.rir, isNull);
    expect(depois.atual!.numero, 2);
  });

  test('registrar com valores alterados marca editado', () async {
    final depois = await registrar(
      await iniciarTreinoDoDia(),
      cargaKg: 62.5,
      reps: 8,
    );

    final serie = depois.series.single;
    expect(serie.cargaKg, 62.5);
    expect(serie.reps, 8);
    expect(serie.cargaPlanKg, 60);
    expect(serie.repsPlan, 10);
    expect(serie.editado, isTrue);
  });

  test('a última série do exercício leva ao próximo exercício', () async {
    var estado = await iniciarTreinoDoDia();
    for (var i = 0; i < 4; i++) {
      estado = await registrar(estado);
    }

    expect(estado.atual!.indiceItem, 1);
    expect(estado.atual!.numero, 1);
    expect(estado.atual!.item.exercicio.id, 'supino-inclinado-halteres');
  });

  test('desfazer apaga a série e ela volta a ser a atual', () async {
    var estado = await registrar(await iniciarTreinoDoDia());
    final serieId = estado.series.single.id;

    await controller.desfazer(serieId);
    estado = (await controller.carregar(estado.treino.id))!;

    expect(estado.series, isEmpty);
    expect(estado.atual!.numero, 1);

    // Exclusão lógica: a linha continua no banco para o sync.
    final linha = await (db.select(
      db.series,
    )..where((s) => s.id.equals(serieId))).getSingle();
    expect(linha.excluidoEm, isNotNull);
  });

  test('corrigir uma série já registrada atualiza valores e editado', () async {
    var estado = await registrar(await iniciarTreinoDoDia());
    estado = await registrar(estado);
    final primeira = estado.seriesDoItem(estado.atual!.item.item.id).first;

    await controller.corrigir(primeira, cargaKg: 60, reps: 7);
    estado = (await controller.carregar(estado.treino.id))!;
    var corrigida = estado.series.firstWhere((s) => s.id == primeira.id);
    expect(corrigida.reps, 7);
    expect(corrigida.editado, isTrue);
    // A série atual não muda ao corrigir uma anterior.
    expect(estado.atual!.numero, 3);

    // Voltar ao valor do plano tira a marca de editado.
    await controller.corrigir(corrigida, cargaKg: 60, reps: 10);
    estado = (await controller.carregar(estado.treino.id))!;
    corrigida = estado.series.firstWhere((s) => s.id == primeira.id);
    expect(corrigida.editado, isFalse);
  });

  test('excluir uma série do meio faz ela voltar a ser a atual', () async {
    var estado = await iniciarTreinoDoDia();
    for (var i = 0; i < 3; i++) {
      estado = await registrar(estado);
    }
    final segunda = estado.series.firstWhere((s) => s.numero == 2);

    await controller.desfazer(segunda.id);
    estado = (await controller.carregar(estado.treino.id))!;
    expect(estado.atual!.numero, 2);

    // Registrar de novo preenche o buraco, sem repetir a série 3.
    estado = await registrar(estado);
    expect(
      estado.seriesDoItem(estado.atual!.item.item.id).map((s) => s.numero),
      [1, 2, 3],
    );
    expect(estado.atual!.numero, 4);
  });

  group('tentar bater o PR', () {
    test('a carga sobe entre as séries e a última tem menos reps', () async {
      var estado = await iniciarTreinoDoDia();
      final supino = estado.atual!.item;
      await controller.definirPr(estado, supino, ativo: true);
      estado = (await controller.carregar(estado.treino.id))!;

      final cargas = <double?>[];
      final reps = <int>[];
      for (var i = 0; i < 4; i++) {
        cargas.add(estado.atual!.cargaPlanKg);
        reps.add(estado.atual!.repsPlan);
        estado = await registrar(estado);
      }

      expect(cargas, [30, 47.5, 60, 72.5]);
      expect(reps, [10, 10, 10, 3]);
      // Gravou no plano da série a carga da escada: nada ficou "editado".
      final feitas = estado.seriesDoItem(supino.item.id);
      expect(feitas.map((s) => s.cargaPlanKg), [30, 47.5, 60, 72.5]);
      expect(feitas.every((s) => !s.editado), isTrue);
    });

    test('desligar no meio volta as séries que faltam ao plano', () async {
      var estado = await iniciarTreinoDoDia();
      final supino = estado.atual!.item;
      await controller.definirPr(estado, supino, ativo: true);
      estado = await registrar((await controller.carregar(estado.treino.id))!);

      await controller.definirPr(estado, supino, ativo: false);
      estado = (await controller.carregar(estado.treino.id))!;

      expect(estado.atual!.numero, 2);
      expect(estado.atual!.cargaPlanKg, 60);
      expect(estado.atual!.percentual, isNull);
      // A série já feita mantém o que foi gravado.
      expect(estado.seriesDoItem(supino.item.id).single.cargaKg, 30);
    });

    test('não vale para exercício por tempo', () async {
      // Prancha: último exercício do treino C.
      final dia = (await planos.treinoDoDia())!;
      final c = dia.sessoes.firstWhere((s) => s.dia == 'C');
      final estado = (await controller.carregar(
        await controller.iniciar(c.id),
      ))!;
      final prancha = estado.sessao.itens.last;
      expect(prancha.exercicio.id, 'prancha');
      expect(estado.aceitaPr(prancha), isFalse);
    });
  });

  group('aquecimento', () {
    test(
      'vira a série atual com ~70% da carga e fica fora da contagem',
      () async {
        var estado = await iniciarTreinoDoDia();
        final supino = estado.atual!.item;
        expect(estado.podeAquecer(estado.atual!), isTrue);

        await controller.definirAquecimento(estado, supino, ativo: true);
        estado = (await controller.carregar(estado.treino.id))!;
        expect(estado.atual!.aquecimento, isTrue);
        expect(estado.atual!.numero, 0);
        expect(estado.atual!.cargaPlanKg, 42.5);
        expect(estado.atual!.repsPlan, 6);

        estado = await registrar(estado);
        expect(estado.atual!.aquecimento, isFalse);
        expect(estado.atual!.numero, 1);
        expect(estado.atual!.cargaPlanKg, 60);
        expect(estado.aquecimentoDoItem(supino.item.id)!.cargaKg, 42.5);
        expect(estado.seriesFeitas, 0);
        expect(estado.volumeKg, 0);
        expect(estado.podeAquecer(estado.atual!), isFalse);
      },
    );

    test('cancelar antes de registrar volta para a série 1', () async {
      var estado = await iniciarTreinoDoDia();
      final supino = estado.atual!.item;
      await controller.definirAquecimento(estado, supino, ativo: true);
      await controller.definirAquecimento(estado, supino, ativo: false);
      estado = (await controller.carregar(estado.treino.id))!;

      expect(estado.atual!.aquecimento, isFalse);
      expect(estado.atual!.numero, 1);
    });

    test('com o modo PR ligado, o aquecimento não aparece', () async {
      var estado = await iniciarTreinoDoDia();
      final supino = estado.atual!.item;
      await controller.definirAquecimento(estado, supino, ativo: true);
      await controller.definirPr(estado, supino, ativo: true);
      estado = (await controller.carregar(estado.treino.id))!;

      expect(estado.atual!.aquecimento, isFalse);
      expect(estado.atual!.cargaPlanKg, 30);
      expect(estado.podeAquecer(estado.atual!), isFalse);

      // Desfazer o PR traz o aquecimento pedido de volta.
      await controller.definirPr(estado, supino, ativo: false);
      estado = (await controller.carregar(estado.treino.id))!;
      expect(estado.atual!.aquecimento, isTrue);
    });

    test('"última vez" ignora o aquecimento', () async {
      var estado = await iniciarTreinoDoDia();
      final supino = estado.atual!.item;
      await controller.definirAquecimento(estado, supino, ativo: true);
      estado = (await controller.carregar(estado.treino.id))!;
      estado = await registrar(estado); // aquecimento
      estado = await registrar(estado, cargaKg: 62.5, reps: 8); // série 1
      await controller.finalizar(estado);

      for (var i = 0; i < 2; i++) {
        agora = agora.add(const Duration(days: 1));
        await controller.finalizar(await iniciarTreinoDoDia());
      }
      agora = agora.add(const Duration(days: 1));

      estado = await iniciarTreinoDoDia();
      final ultima = estado.ultimaVezDa(estado.atual!)!;
      expect(ultima.aquecimento, isFalse);
      expect(ultima.cargaKg, 62.5);
    });
  });

  test('volume e progresso contam carga × reps das séries do plano', () async {
    var estado = await iniciarTreinoDoDia();
    estado = await registrar(estado); // 60 × 10
    estado = await registrar(estado, cargaKg: 62.5, reps: 8); // 62,5 × 8

    expect(estado.volumeKg, 600 + 500);
    expect(estado.progresso, closeTo(2 / 19, 1e-9));
  });

  test('fechar e reabrir o app retoma na série certa', () async {
    var estado = await iniciarTreinoDoDia();
    for (var i = 0; i < 5; i++) {
      estado = await registrar(estado);
    }

    // Um controller novo, como depois de reiniciar o app.
    controller = novoController();
    final dia = (await planos.treinoDoDia())!;
    expect(dia.emAndamento?.id, estado.treino.id);

    final retomado = (await controller.carregar(dia.emAndamento!.id))!;
    expect(retomado.atual!.indiceItem, 1);
    expect(retomado.atual!.numero, 2);
    expect(retomado.seriesFeitas, 5);
  });

  test('treino completo é finalizado como concluído', () async {
    var estado = await iniciarTreinoDoDia();
    while (!estado.completo) {
      estado = await registrar(estado);
    }
    await controller.finalizar(estado);

    final treino = (await controller.carregar(estado.treino.id))!.treino;
    expect(treino.status, StatusTreino.concluido);
    expect(treino.finalizadoEm, isNotNull);
    expect((await planos.treinoDoDia())!.sessao.sessao.dia, 'B');
  });

  test('encerrar antes do fim finaliza como parcial', () async {
    final estado = await registrar(await iniciarTreinoDoDia());
    await controller.finalizar(estado);

    final treino = (await controller.carregar(estado.treino.id))!.treino;
    expect(treino.status, StatusTreino.parcial);
  });

  test('"última vez" traz as séries do treino anterior', () async {
    // Primeiro treino A: só a primeira série, com 62,5 × 8.
    var estado = await registrar(
      await iniciarTreinoDoDia(),
      cargaKg: 62.5,
      reps: 8,
    );
    await controller.finalizar(estado);

    // Fecha o ciclo B e C para voltar ao A.
    for (var i = 0; i < 2; i++) {
      agora = agora.add(const Duration(days: 1));
      final outro = await iniciarTreinoDoDia();
      await controller.finalizar(outro);
    }
    agora = agora.add(const Duration(days: 1));

    estado = await iniciarTreinoDoDia();
    expect(estado.sessao.sessao.dia, 'A');
    final ultima = estado.ultimaVezDa(estado.atual!)!;
    expect(ultima.cargaKg, 62.5);
    expect(ultima.reps, 8);
  });
}
