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

/// Etapa 3: descanso, pergunta de dificuldade, sugestão de carga menor,
/// PR atual e novo zero.
void main() {
  late AppDatabase db;
  late DateTime agora;
  late PlanoRepository planos;
  late PreferenciasRepository preferencias;
  late AvisoFalso aviso;
  late SessaoTreinoController controller;

  setUp(() async {
    db = abrirBancoDeTeste();
    agora = DateTime(2026, 11, 8, 7);
    DateTime relogio() => agora;
    planos = PlanoRepository(db, agora: relogio);
    preferencias = PreferenciasRepository(db, agora: relogio);
    aviso = AvisoFalso();
    controller = SessaoTreinoController(
      db,
      planos,
      TreinoRepository(db, agora: relogio),
      preferencias: preferencias,
      aviso: aviso,
      agora: relogio,
    );
    await popularSeedDeTeste(db, agora: agora);
  });
  tearDown(() => db.close());

  Future<EstadoExecucao> iniciarTreinoDoDia() async {
    final dia = (await planos.treinoDoDia())!;
    final id = await controller.iniciar(dia.sessao.sessao.id);
    return (await controller.carregar(id))!;
  }

  Future<EstadoExecucao> recarregar(EstadoExecucao estado) async =>
      (await controller.carregar(estado.treino.id))!;

  /// Registra a série atual e avança o relógio, como num treino de verdade.
  Future<EstadoExecucao> registrar(
    EstadoExecucao estado, {
    double? cargaKg,
    int? reps,
  }) async {
    await controller.registrar(estado, cargaKg: cargaKg, reps: reps);
    agora = agora.add(const Duration(minutes: 3));
    return recarregar(estado);
  }

  group('descanso', () {
    test(
      'registrar abre o descanso pelo tempo do plano e agenda o aviso',
      () async {
        final estado = await iniciarTreinoDoDia();
        final inicio = agora;
        await controller.registrar(estado);
        final depois = await recarregar(estado);

        final fim = inicio.add(const Duration(seconds: 150));
        expect(depois.descansoTerminaEm, fim);
        expect(depois.serieDoDescanso!.numero, 1);
        expect(aviso.agendadoPara, fim);
        expect(aviso.permissoes, 1);
      },
    );

    test('±15 s mudam o fim, sem ficar antes de agora', () async {
      var estado = await iniciarTreinoDoDia();
      final inicio = agora;
      await controller.registrar(estado);
      estado = await recarregar(estado);

      await controller.ajustarDescanso(estado, 15);
      estado = await recarregar(estado);
      expect(
        estado.descansoTerminaEm,
        inicio.add(const Duration(seconds: 165)),
      );

      for (var i = 0; i < 20; i++) {
        await controller.ajustarDescanso(estado, -15);
        estado = await recarregar(estado);
      }
      expect(estado.descansoTerminaEm, agora);
    });

    test('encerrar e desfazer a série acabam o descanso', () async {
      var estado = await iniciarTreinoDoDia();
      await controller.registrar(estado);
      estado = await recarregar(estado);
      await controller.encerrarDescanso(estado);
      estado = await recarregar(estado);
      expect(estado.descansoTerminaEm, isNull);
      expect(aviso.agendadoPara, isNull);

      final serie = await controller.registrar(estado);
      estado = await recarregar(estado);
      expect(estado.descansoTerminaEm, isNotNull);
      await controller.desfazer(serie!.id);
      estado = await recarregar(estado);
      expect(estado.descansoTerminaEm, isNull);
      expect(aviso.agendadoPara, isNull);
    });

    test('fim em segundo plano mantém a notificação que tocou', () async {
      var estado = await iniciarTreinoDoDia();
      await controller.registrar(estado);
      estado = await recarregar(estado);
      final fim = aviso.agendadoPara;

      await controller.encerrarDescanso(estado, manterAviso: true);
      estado = await recarregar(estado);
      expect(estado.descansoTerminaEm, isNull);
      expect(aviso.agendadoPara, fim);
    });

    test('aquecimento descansa 60 s', () async {
      var estado = await iniciarTreinoDoDia();
      await controller.definirAquecimento(
        estado,
        estado.atual!.item,
        ativo: true,
      );
      estado = await recarregar(estado);
      final inicio = agora;
      await controller.registrar(estado);
      estado = await recarregar(estado);
      expect(estado.descansoTerminaEm, inicio.add(const Duration(seconds: 60)));
    });

    test('dificuldade, confirmação e ajuste são gravados na série', () async {
      var estado = await registrar(await iniciarTreinoDoDia());
      final serie = estado.series.single;
      await controller.responderDificuldade(serie, 1);
      await controller.confirmar(serie);
      estado = await recarregar(estado);
      expect(estado.series.single.rir, 1);
      expect(estado.series.single.confirmado, isTrue);

      await controller.ajustar(
        estado.series.single,
        cargaKg: 60,
        reps: 8,
        rir: 0,
      );
      estado = await recarregar(estado);
      final ajustada = estado.series.single;
      expect(ajustada.reps, 8);
      expect(ajustada.rir, 0);
      expect(ajustada.editado, isTrue);
    });
  });

  group('sugestão de carga menor', () {
    test('2 reps abaixo do mínimo: próxima série um passo abaixo', () async {
      // Supino: faixa 6–10. 4 reps = 2 abaixo do mínimo.
      final estado = await registrar(await iniciarTreinoDoDia(), reps: 4);
      expect(estado.atual!.numero, 2);
      expect(estado.atual!.cargaPlanKg, 57.5);
      expect(estado.serieQueSugeriu(estado.atual!.item, 2)!.numero, 1);
      // As linhas das séries seguintes já mostram a carga que vão pedir.
      expect(estado.planoDa(estado.atual!.item, 3).cargaKg, 57.5);
      expect(estado.planoDa(estado.atual!.item, 4).cargaKg, 57.5);
    });

    test(
      '"No limite" também vale, e a carga menor segue nas próximas',
      () async {
        var estado = await registrar(await iniciarTreinoDoDia());
        await controller.responderDificuldade(estado.series.single, 0);
        estado = await recarregar(estado);
        expect(estado.atual!.cargaPlanKg, 57.5);

        estado = await registrar(estado); // série 2 com 57,5, sem pedido novo
        expect(estado.atual!.numero, 3);
        expect(estado.atual!.cargaPlanKg, 57.5);
      },
    );

    test('"Manter carga" volta ao plano e pode ser desfeito', () async {
      var estado = await registrar(await iniciarTreinoDoDia(), reps: 4);
      final gatilho = estado.serieQueSugeriu(estado.atual!.item, 2)!;

      await controller.manterCarga(gatilho, manter: true);
      estado = await recarregar(estado);
      expect(estado.atual!.cargaPlanKg, 60);
      expect(estado.serieQueSugeriu(estado.atual!.item, 2), isNull);

      await controller.manterCarga(gatilho, manter: false);
      estado = await recarregar(estado);
      expect(estado.atual!.cargaPlanKg, 57.5);
    });

    test('desligada em Preferências, o plano não muda', () async {
      await preferencias.salvar(sugestaoCargaMenor: false);
      final estado = await registrar(await iniciarTreinoDoDia(), reps: 4);
      expect(estado.atual!.cargaPlanKg, 60);
    });

    test('a última série não passa sugestão adiante', () async {
      var estado = await iniciarTreinoDoDia();
      for (var i = 0; i < 3; i++) {
        estado = await registrar(estado);
      }
      estado = await registrar(estado, reps: 2); // série 4 de 4
      expect(estado.atual!.item.exercicio.id, 'supino-inclinado-halteres');
      expect(estado.atual!.cargaPlanKg, 22);
    });
  });

  group('PR atual e novo zero', () {
    /// Treino A com a primeira série do supino em [carga] × 5, depois B e C,
    /// para o próximo treino do dia voltar ao A.
    Future<void> historicoSupino(double carga) async {
      final estado = await registrar(
        await iniciarTreinoDoDia(),
        cargaKg: carga,
        reps: 5,
      );
      await controller.finalizar(estado);
      for (var i = 0; i < 2; i++) {
        agora = agora.add(const Duration(days: 1));
        await controller.finalizar(await iniciarTreinoDoDia());
      }
      agora = agora.add(const Duration(days: 1));
    }

    Future<EstadoExecucao> comPr(EstadoExecucao estado) async {
      await controller.definirPr(estado, estado.atual!.item, ativo: true);
      return recarregar(estado);
    }

    test('PR atual vem dos treinos anteriores', () async {
      await historicoSupino(75);
      final estado = await iniciarTreinoDoDia();
      expect(estado.prAtualDe(estado.atual!.item), 75);
    });

    test('a escada mira PR + 1 passo, com no mínimo 3 reps', () async {
      await historicoSupino(75);
      final estado = await comPr(await iniciarTreinoDoDia());
      final supino = estado.atual!.item;

      final ultima = estado.planoDa(supino, 4);
      expect(ultima.cargaKg, 77.5);
      expect(ultima.reps, 3);
      expect(estado.planoDa(supino, 3).cargaKg, 60);
    });

    test('PR muito acima do plano fica só como referência', () async {
      await historicoSupino(100); // acima de 135% de 60 kg
      final estado = await comPr(await iniciarTreinoDoDia());
      expect(estado.planoDa(estado.atual!.item, 4).cargaKg, 72.5);
    });

    test(
      'PR batido pergunta o novo zero e aplica a conversão do 1RM',
      () async {
        var estado = await comPr(await iniciarTreinoDoDia());
        final supino = estado.atual!.item;
        for (var i = 0; i < 3; i++) {
          estado = await registrar(estado);
        }
        // Última série: 72,5 kg × 6 (a meta era 3).
        estado = await registrar(estado, cargaKg: 72.5, reps: 6);

        final pr = estado.novoPrDo(supino)!;
        expect(pr.cargaPr, 72.5);
        expect(pr.prAnteriorKg, isNull);
        // 72,5 × 6 → 1RM 87 kg → para 10 reps: 65,25 → 65 kg.
        expect(pr.novaBaseUmRm, 65);
        expect(pr.umRmSobe, isTrue);
        expect(pr.datas, hasLength(1));

        await controller.decidirNovoZero(estado, pr, novaCargaKg: 65);
        estado = await recarregar(estado);
        expect(estado.novoPrDo(estado.sessao.itens.first), isNull);
        expect(estado.sessao.itens.first.item.cargaPlanKg, 65);

        // Desfazer devolve a carga e a pergunta.
        await controller.desfazerNovoZero(estado, pr, cargaAnteriorKg: 60);
        estado = await recarregar(estado);
        expect(estado.sessao.itens.first.item.cargaPlanKg, 60);
        expect(estado.novoPrDo(estado.sessao.itens.first), isNotNull);
      },
    );

    test('"Agora não" não muda o plano', () async {
      var estado = await comPr(await iniciarTreinoDoDia());
      final supino = estado.atual!.item;
      for (var i = 0; i < 4; i++) {
        estado = await registrar(estado);
      }
      final pr = estado.novoPrDo(supino)!;
      await controller.decidirNovoZero(estado, pr);
      estado = await recarregar(estado);

      expect(estado.novoPrDo(estado.sessao.itens.first), isNull);
      expect(estado.sessao.itens.first.item.cargaPlanKg, 60);
    });

    test('sem a meta de reps não há novo PR', () async {
      var estado = await comPr(await iniciarTreinoDoDia());
      final supino = estado.atual!.item;
      for (var i = 0; i < 3; i++) {
        estado = await registrar(estado);
      }
      estado = await registrar(estado, cargaKg: 72.5, reps: 2);
      expect(estado.novoPrDo(supino), isNull);
    });

    test('o histórico conta os dias com aquela carga ou mais', () async {
      await historicoSupino(72.5);
      var estado = await comPr(await iniciarTreinoDoDia());
      final supino = estado.atual!.item;
      for (var i = 0; i < 3; i++) {
        estado = await registrar(estado);
      }
      // PR anterior 72,5 → a escada mira 75; feito 75 × 3.
      expect(estado.atual!.cargaPlanKg, 75);
      estado = await registrar(estado);

      final pr = estado.novoPrDo(supino)!;
      expect(pr.prAnteriorKg, 72.5);
      expect(pr.datas, hasLength(1));
    });
  });
}
