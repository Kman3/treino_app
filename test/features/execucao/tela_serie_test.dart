import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/app.dart';
import 'package:treino_app/core/db/app_database.dart';
import 'package:treino_app/core/db/providers.dart';
import 'package:treino_app/core/notificacoes/aviso_descanso.dart';

import '../../helpers.dart';

/// Conta os cancelamentos da notificação de fim do descanso.
class AvisoContador implements AvisoDescanso {
  int agendados = 0;
  int cancelados = 0;

  @override
  Future<void> pedirPermissao() async {}

  @override
  Future<void> agendar(DateTime quando, {required String texto}) async =>
      agendados++;

  @override
  Future<void> cancelar() async => cancelados++;
}

void main() {
  late AppDatabase db;

  // O banco é aberto dentro do teste para que as consultas rodem na zona de
  // tempo simulado que o `pump` avança.
  Future<void> abrirApp(WidgetTester tester, {AvisoDescanso? aviso}) async {
    // Tela do tamanho de um celular (411 × 914), para a lista de séries caber.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    db = abrirBancoDeTeste();
    await popularSeedDeTeste(db);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          if (aviso != null) avisoDescansoProvider.overrideWithValue(aviso),
        ],
        child: const TreinoApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fecharApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    final fechando = db.close();
    await tester.pump(const Duration(seconds: 1));
    await fechando;
  }

  Future<void> comecarTreino(WidgetTester tester) async {
    await tester.tap(find.text('Começar treino'));
    await tester.pumpAndSettle();
  }

  /// Registra a série atual e, por padrão, pula o descanso que abre.
  Future<void> registrar(
    WidgetTester tester, {
    bool pularDescanso = true,
    String botao = 'Registrar série',
  }) async {
    await tester.tap(find.text(botao));
    await tester.pumpAndSettle();
    if (pularDescanso) {
      await tester.tap(find.text('Pular descanso'));
      await tester.pumpAndSettle();
    }
  }

  testWidgets('Começar treino abre a série 1 sem a barra inferior', (
    tester,
  ) async {
    await abrirApp(tester);
    await comecarTreino(tester);

    expect(find.text('Supino reto com barra'), findsOneWidget);
    expect(find.text('SÉRIE 1 DE 4'), findsOneWidget);
    expect(find.text('TREINO A · EXERCÍCIO 1 DE 6'), findsOneWidget);
    expect(find.text('PRIMEIRA VEZ NESTE EXERCÍCIO'), findsOneWidget);
    expect(find.text('Registrar série'), findsOneWidget);
    expect(find.text('EVOLUÇÃO'), findsNothing);

    await fecharApp(tester);
  });

  group('descanso (02B)', () {
    testWidgets('Registrar abre o descanso com timer e a pergunta', (
      tester,
    ) async {
      await abrirApp(tester);
      await comecarTreino(tester);
      await registrar(tester, pularDescanso: false);

      expect(find.text('DESCANSO'), findsOneWidget);
      expect(find.text('2:30'), findsOneWidget);
      expect(find.text('COMO FOI A SÉRIE 1?'), findsOneWidget);
      expect(find.text('Fez 60 kg × 10 mesmo?'), findsOneWidget);
      expect(find.textContaining('PRÓXIMA · SUPINO RETO'), findsOneWidget);
      expect(find.text('Série registrada'), findsOneWidget);
      // Barra discreta no topo: 1 de 19 séries e 60 × 10 de volume.
      expect(find.text('5% · 600 KG'), findsOneWidget);

      await fecharApp(tester);
    });

    testWidgets('o timer conta, aceita ±15 s e acaba sozinho', (tester) async {
      await abrirApp(tester);
      await comecarTreino(tester);
      await registrar(tester, pularDescanso: false);

      await tester.pump(const Duration(seconds: 10));
      expect(find.text('2:20'), findsOneWidget);

      // `pump()` sem tempo: o `pumpAndSettle` deixaria o relógio andar.
      await tester.tap(find.text('+15s'));
      await tester.pump();
      await tester.pump();
      expect(find.text('2:35'), findsOneWidget);

      await tester.tap(find.text('−15s'));
      await tester.pump();
      await tester.pump();
      expect(find.text('2:20'), findsOneWidget);

      // Fim do timer: volta sozinho para a próxima série.
      await tester.pump(const Duration(seconds: 141));
      await tester.pumpAndSettle();
      expect(find.text('DESCANSO'), findsNothing);
      expect(find.text('SÉRIE 2 DE 4'), findsOneWidget);

      await fecharApp(tester);
    });

    testWidgets('em segundo plano, o fim do timer não apaga a notificação', (
      tester,
    ) async {
      final aviso = AvisoContador();
      await abrirApp(tester, aviso: aviso);
      await comecarTreino(tester);
      await registrar(tester, pularDescanso: false);
      expect(aviso.agendados, 1);
      final cancelamentos = aviso.cancelados;

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump(const Duration(seconds: 151));
      await tester.pump();
      expect(aviso.cancelados, cancelamentos);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(find.text('SÉRIE 2 DE 4'), findsOneWidget);

      await fecharApp(tester);
    });

    testWidgets('responder e confirmar fecham a pergunta', (tester) async {
      await abrirApp(tester);
      await comecarTreino(tester);
      await registrar(tester, pularDescanso: false);

      await tester.tap(find.bySemanticsLabel('Na medida'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('✓ Sim, igual'));
      await tester.pumpAndSettle();

      expect(find.text('COMO FOI A SÉRIE 1?'), findsNothing);
      final serie = await db.select(db.series).getSingle();
      expect(serie.rir, 2);
      expect(serie.confirmado, isTrue);

      await fecharApp(tester);
    });

    testWidgets('Pular fecha a pergunta e mantém o timer', (tester) async {
      await abrirApp(tester);
      await comecarTreino(tester);
      await registrar(tester, pularDescanso: false);

      await tester.tap(find.text('Pular'));
      await tester.pumpAndSettle();
      expect(find.text('COMO FOI A SÉRIE 1?'), findsNothing);
      expect(find.text('DESCANSO'), findsOneWidget);

      final serie = await db.select(db.series).getSingle();
      expect(serie.rir, isNull);
      expect(serie.confirmado, isFalse);

      await fecharApp(tester);
    });

    testWidgets('Desfazer no descanso apaga a série e encerra o descanso', (
      tester,
    ) async {
      await abrirApp(tester);
      await comecarTreino(tester);
      await registrar(tester, pularDescanso: false);

      await tester.tap(find.text('Desfazer'));
      await tester.pumpAndSettle();
      expect(find.text('DESCANSO'), findsNothing);
      expect(find.text('SÉRIE 1 DE 4'), findsOneWidget);

      await fecharApp(tester);
    });

    testWidgets(
      'Ajustar com "No limite" sugere carga menor, e dá para manter',
      (tester) async {
        await abrirApp(tester);
        await comecarTreino(tester);
        await registrar(tester, pularDescanso: false);

        await tester.tap(find.text('Ajustar'));
        await tester.pumpAndSettle();
        expect(find.text('AJUSTAR SÉRIE 1'), findsOneWidget);
        await tester.tap(find.bySemanticsLabel('No limite').last);
        await tester.pumpAndSettle();
        expect(
          find.text('Próxima série com 57,5 kg, um passo a menos.'),
          findsOneWidget,
        );
        await tester.tap(find.text('Salvar'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Pular descanso'));
        await tester.pumpAndSettle();
        expect(find.text('SÉRIE 2 DE 4'), findsOneWidget);
        expect(find.text('57,5'), findsOneWidget);
        expect(find.textContaining('CARGA MENOR SUGERIDA'), findsOneWidget);

        await tester.tap(find.text('Manter 60 kg'));
        await tester.pumpAndSettle();
        expect(find.text('60'), findsOneWidget);
        expect(find.textContaining('CARGA MENOR SUGERIDA'), findsNothing);

        await fecharApp(tester);
      },
    );

    testWidgets('no Ajustar dá para digitar as reps ou desistir', (
      tester,
    ) async {
      await abrirApp(tester);
      await comecarTreino(tester);
      await registrar(tester, pularDescanso: false);
      await tester.tap(find.text('Ajustar'));
      await tester.pumpAndSettle();

      // Fechar tocando fora não muda nada.
      await tester.tap(find.bySemanticsLabel(RegExp(r'^Reps: 10')));
      await tester.pumpAndSettle();
      expect(find.text('OK'), findsOneWidget);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('OK'), findsNothing);
      expect(find.bySemanticsLabel(RegExp(r'^Reps: 10')), findsOneWidget);

      await tester.tap(find.bySemanticsLabel(RegExp(r'^Reps: 10')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '7');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel(RegExp(r'^Reps: 7')), findsOneWidget);
      expect(find.text('−3 vs. plano'), findsOneWidget);

      await fecharApp(tester);
    });
  });

  testWidgets('o aviso de Desfazer some depois de 5 s', (tester) async {
    await abrirApp(tester);
    await comecarTreino(tester);

    await registrar(tester);
    expect(find.text('Desfazer'), findsOneWidget);

    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    expect(find.text('Desfazer'), findsNothing);

    await fecharApp(tester);
  });

  testWidgets('Alterar muda a carga e grava como editado', (tester) async {
    await abrirApp(tester);
    await comecarTreino(tester);

    await tester.tap(find.text('✎ Alterar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Aumentar Carga'));
    await tester.pumpAndSettle();
    expect(find.text('+2,5 vs. plano'), findsOneWidget);

    await tester.tap(find.text('Pronto'));
    await tester.pumpAndSettle();
    expect(find.text('62,5'), findsOneWidget);

    await registrar(tester);
    expect(find.text('62,5 KG × 10'), findsOneWidget);
    expect(find.text('EDITADO'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('tocar numa série feita permite corrigir', (tester) async {
    await abrirApp(tester);
    await comecarTreino(tester);
    await registrar(tester);
    await registrar(tester);
    expect(find.text('SÉRIE 3 DE 4'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(RegExp(r'^Série 1, ')));
    await tester.pumpAndSettle();
    expect(find.text('CORRIGIR SÉRIE 1'), findsOneWidget);

    await tester.tap(find.byTooltip('Diminuir Reps'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('60 KG × 9'), findsOneWidget);
    expect(find.text('EDITADO'), findsOneWidget);
    expect(find.text('Série 1 corrigida'), findsOneWidget);
    // Continua na série em que estava.
    expect(find.text('SÉRIE 3 DE 4'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('excluir uma série feita faz ela voltar a ser a atual', (
    tester,
  ) async {
    await abrirApp(tester);
    await comecarTreino(tester);
    await registrar(tester);
    await registrar(tester);

    await tester.tap(find.bySemanticsLabel(RegExp(r'^Série 1, ')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir série'));
    await tester.pumpAndSettle();

    expect(find.text('SÉRIE 1 DE 4'), findsOneWidget);
    expect(find.text('Série 1 excluída'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('no começo do exercício, o anterior aparece para corrigir', (
    tester,
  ) async {
    await abrirApp(tester);
    await comecarTreino(tester);
    for (var i = 0; i < 4; i++) {
      await registrar(tester);
    }
    // Espera o aviso de "Desfazer" sumir para ele não cobrir a lista.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();

    expect(find.text('Supino inclinado com halteres'), findsOneWidget);
    expect(
      find.text('EXERCÍCIO ANTERIOR · SUPINO RETO COM BARRA'),
      findsOneWidget,
    );

    final serie4 = find.bySemanticsLabel(RegExp(r'^Série 4, '));
    await tester.scrollUntilVisible(serie4, 100);
    await tester.ensureVisible(serie4);
    await tester.pumpAndSettle();
    await tester.tap(serie4);
    await tester.pumpAndSettle();
    expect(find.text('CORRIGIR SÉRIE 4'), findsOneWidget);
    expect(find.text('Supino reto com barra'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('o cartão de novo PR aparece inteiro junto da pergunta', (
    tester,
  ) async {
    await abrirApp(tester);
    await comecarTreino(tester);
    await tester.tap(find.text('Tentar bater o PR'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await registrar(tester);
    }
    await registrar(tester, pularDescanso: false); // 72,5 kg × 3

    expect(find.text('COMO FOI A SÉRIE 4?'), findsOneWidget);
    // O anel grande vira a pílula, e o cartão inteiro fica à vista.
    expect(
      find.text('NOVO PR · SUPINO RETO COM BARRA').hitTestable(),
      findsOneWidget,
    );
    expect(find.text('OK').hitTestable(), findsOneWidget);

    // Respondida a pergunta, o anel grande volta.
    await tester.tap(find.bySemanticsLabel('Na medida').last);
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('✓ Sim, igual'));
    await tester.pump();
    await tester.pump();
    expect(find.text('COMO FOI A SÉRIE 4?'), findsNothing);
    expect(find.text('NOVO PR · SUPINO RETO COM BARRA'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('Tentar bater o PR muda a carga e pode ser desfeito', (
    tester,
  ) async {
    await abrirApp(tester);
    await comecarTreino(tester);
    expect(find.text('0% · 0 KG'), findsOneWidget);

    await tester.tap(find.text('Tentar bater o PR'));
    await tester.pumpAndSettle();
    expect(find.text('SÉRIE 1 DE 4 · 50%'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('72,5 KG × 3'), findsOneWidget);
    expect(find.text('Carga progressiva até o PR'), findsOneWidget);
    // Com a carga progressiva, o botão de aquecimento some.
    expect(find.textContaining('Aquecimento ·'), findsNothing);

    await tester.tap(find.text('Desfazer'));
    await tester.pumpAndSettle();
    expect(find.text('SÉRIE 1 DE 4'), findsOneWidget);
    expect(find.textContaining('Aquecimento ·'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('Aquecimento vira a série atual e pode ser desfeito', (
    tester,
  ) async {
    await abrirApp(tester);
    await comecarTreino(tester);

    await tester.tap(find.text('Aquecimento · 42,5 kg × 6'));
    await tester.pumpAndSettle();
    expect(find.text('AQUECIMENTO · 70% DA CARGA'), findsOneWidget);
    expect(find.text('Registrar aquecimento'), findsOneWidget);

    await tester.tap(find.text('Desfazer'));
    await tester.pumpAndSettle();
    expect(find.text('SÉRIE 1 DE 4'), findsOneWidget);
    expect(find.text('Registrar série'), findsOneWidget);

    // Registrado, o aquecimento não conta no progresso nem no volume, e o
    // descanso dele não pergunta a dificuldade.
    await tester.tap(find.text('Aquecimento · 42,5 kg × 6'));
    await tester.pumpAndSettle();
    await registrar(
      tester,
      pularDescanso: false,
      botao: 'Registrar aquecimento',
    );
    expect(find.text('1:00'), findsOneWidget);
    expect(find.textContaining('COMO FOI'), findsNothing);
    await tester.tap(find.text('Pular descanso'));
    await tester.pumpAndSettle();

    expect(find.text('SÉRIE 1 DE 4'), findsOneWidget);
    expect(find.text('0% · 0 KG'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp(r'^Aquecimento, 42,5 kg × 6')),
      findsOne,
    );

    await fecharApp(tester);
  });

  testWidgets('pausar volta ao início, que oferece continuar', (tester) async {
    await abrirApp(tester);
    await comecarTreino(tester);
    await registrar(tester);

    await tester.tap(find.byTooltip('Pausar treino'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pausar'));
    await tester.pumpAndSettle();

    expect(find.text('Treino A em andamento — continuar?'), findsOneWidget);
    await tester.tap(find.text('Continuar treino'));
    await tester.pumpAndSettle();
    expect(find.text('SÉRIE 2 DE 4'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('Perfil desliga a sugestão de carga menor', (tester) async {
    await abrirApp(tester);
    await tester.tap(find.text('PERFIL'));
    await tester.pumpAndSettle();

    expect(find.text('Sugerir carga menor na próxima série'), findsOneWidget);
    await tester.tap(find.text('Sugerir carga menor na próxima série'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usar o peso do PR direto'));
    await tester.pumpAndSettle();

    final p = await db.select(db.preferencias).getSingle();
    expect(p.sugestaoCargaMenor, isFalse);
    expect(p.modoNovoZero, 'direto');

    await fecharApp(tester);
  });
}
