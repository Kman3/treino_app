import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/app.dart';
import 'package:treino_app/core/db/app_database.dart';
import 'package:treino_app/core/db/providers.dart';

import '../../helpers.dart';

void main() {
  late AppDatabase db;

  // O banco é aberto dentro do teste para que as consultas rodem na zona de
  // tempo simulado que o `pump` avança.
  Future<void> abrirApp(WidgetTester tester) async {
    // Tela do tamanho de um celular (411 × 914), para a lista de séries caber.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    db = abrirBancoDeTeste();
    await popularSeedDeTeste(db);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
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

  testWidgets('Registrar série avança e Desfazer volta', (tester) async {
    await abrirApp(tester);
    await comecarTreino(tester);

    await tester.tap(find.text('Registrar série'));
    await tester.pumpAndSettle();
    expect(find.text('SÉRIE 2 DE 4'), findsOneWidget);
    expect(find.text('Série registrada'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp(r'^Série 1, 60 kg × 10')), findsOne);
    // Barra discreta no topo: 1 de 19 séries e 60 × 10 de volume.
    expect(find.text('5% · 600 KG'), findsOneWidget);

    await tester.tap(find.text('Desfazer'));
    await tester.pumpAndSettle();
    expect(find.text('SÉRIE 1 DE 4'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('o aviso de Desfazer some depois de 5 s', (tester) async {
    await abrirApp(tester);
    await comecarTreino(tester);

    await tester.tap(find.text('Registrar série'));
    await tester.pumpAndSettle();
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

    await tester.tap(find.text('Registrar série'));
    await tester.pumpAndSettle();
    expect(find.text('62,5 KG × 10'), findsOneWidget);
    expect(find.text('EDITADO'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('tocar numa série feita permite corrigir', (tester) async {
    await abrirApp(tester);
    await comecarTreino(tester);
    await tester.tap(find.text('Registrar série'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Registrar série'));
    await tester.pumpAndSettle();
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
    await tester.tap(find.text('Registrar série'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Registrar série'));
    await tester.pumpAndSettle();

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
      await tester.tap(find.text('Registrar série'));
      await tester.pumpAndSettle();
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

    // Registrado, o aquecimento não conta no progresso nem no volume.
    await tester.tap(find.text('Aquecimento · 42,5 kg × 6'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Registrar aquecimento'));
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
    await tester.tap(find.text('Registrar série'));
    await tester.pumpAndSettle();

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
}
