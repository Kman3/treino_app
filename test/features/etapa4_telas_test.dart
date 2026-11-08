import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/app.dart';
import 'package:treino_app/core/db/app_database.dart';
import 'package:treino_app/core/db/providers.dart';
import 'package:treino_app/core/db/repositorios/plano_repository.dart';
import 'package:treino_app/core/db/repositorios/treino_repository.dart';
import 'package:treino_app/core/widgets/icone_caramelo.dart';
import 'package:treino_app/features/exercicio/grafico_evolucao.dart';

import '../helpers.dart';

/// Telas da etapa 4: versão de 20 minutos, tela 03, "Ocupado", "Senti dor",
/// aba Evolução e textos em 200%.
void main() {
  late AppDatabase db;

  Future<void> abrirApp(
    WidgetTester tester, {
    Future<void> Function(AppDatabase db)? antes,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    db = abrirBancoDeTeste();
    await popularSeedDeTeste(db);
    await antes?.call(db);
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

  Future<void> tocar(WidgetTester tester, Finder alvo) async {
    await tester.ensureVisible(alvo);
    await tester.pumpAndSettle();
    await tester.tap(alvo);
    await tester.pumpAndSettle();
  }

  testWidgets('"Só tenho 20 minutos" mostra a prévia e começa reduzido', (
    tester,
  ) async {
    await abrirApp(tester);

    await tocar(tester, find.text('Só tenho 20 minutos'));
    expect(find.text('SÓ TENHO 20 MINUTOS'), findsOneWidget);
    expect(find.text('Desenvolvimento com halteres'), findsWidgets);
    expect(find.text('2 × 6–10 · 60 kg'), findsOneWidget);

    await tocar(tester, find.text('Começar versão de 20 min'));
    expect(find.text('TREINO A · 20 MIN · EXERCÍCIO 1 DE 3'), findsOneWidget);
    expect(find.text('SÉRIE 1 DE 2'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('tocar num exercício da Hoje abre a tela 03', (tester) async {
    await abrirApp(tester);

    await tocar(tester, find.text('Supino reto com barra'));
    expect(find.text('EXERCÍCIO'), findsOneWidget);
    expect(find.text('MÚSCULOS-ALVO'), findsOneWidget);
    expect(find.text('Peitoral maior'), findsOneWidget);
    expect(find.textContaining('Ainda sem registros'), findsOneWidget);
    // A justificativa do plano vem antes da do padrão de movimento.
    expect(
      find.text(
        'Exercício base de empurrar na horizontal; permite progredir carga '
        'com segurança.',
      ),
      findsOneWidget,
    );
    expect(find.text('RASCUNHO · FONTE AINDA NÃO REVISADA'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Supino na máquina'), 200);
    expect(find.text('Trocar'), findsWidgets);

    await fecharApp(tester);
  });

  testWidgets('"Ocupado" troca o exercício só hoje', (tester) async {
    await abrirApp(tester);
    await tocar(tester, find.text('Começar treino'));

    await tocar(tester, find.text('Ocupado'));
    expect(find.text('OCUPADO? TROQUE O EXERCÍCIO'), findsOneWidget);
    await tocar(tester, find.text('Supino na máquina'));
    expect(find.text('TROCAR POR'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp(r'^Carga inicial: 60 kg')),
      findsOneWidget,
    );

    await tocar(tester, find.text('Trocar só hoje'));
    expect(find.text('Supino na máquina'), findsOneWidget);
    expect(find.text('HOJE NO LUGAR DE SUPINO RETO COM BARRA'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('"Senti dor" tira o exercício do treino, com desfazer', (
    tester,
  ) async {
    await abrirApp(tester);
    await tocar(tester, find.text('Começar treino'));

    await tocar(tester, find.byTooltip('Mais opções'));
    await tocar(tester, find.text('Senti dor'));
    expect(find.text('Dor no Supino reto com barra?'), findsOneWidget);
    await tocar(tester, find.text('Tirar do treino'));

    expect(find.text('Supino inclinado com halteres'), findsOneWidget);
    expect(find.text('TREINO A · EXERCÍCIO 1 DE 5'), findsOneWidget);
    expect(find.textContaining('saiu do treino de hoje'), findsOneWidget);

    await tester.tap(find.text('Desfazer'));
    await tester.pumpAndSettle();
    expect(find.text('Supino reto com barra'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('Evolução mostra o 1RM e abre o gráfico na tela 03', (
    tester,
  ) async {
    await abrirApp(
      tester,
      antes: (db) async {
        final sessaoA = (await PlanoRepository(db).sessoesComItens()).first;
        final treinos = TreinoRepository(db);
        final treino = await treinos.iniciar(sessaoA.sessao.id);
        await treinos.registrarSerie(
          treinoId: treino.id,
          item: sessaoA.itens.first.item,
          numero: 1,
          cargaPlanKg: 60,
          repsPlan: 10,
          cargaKg: 60,
          reps: 10,
        );
        await treinos.finalizar(treino.id);
      },
    );

    await tocar(tester, find.text('EVOLUÇÃO'));
    expect(find.text('Evolução'), findsOneWidget);
    expect(find.text('80 kg'), findsOneWidget);

    await tocar(tester, find.text('Supino reto com barra'));
    expect(find.text('1RM ESTIMADO · 8 SEMANAS'), findsOneWidget);
    expect(find.byType(GraficoEvolucao), findsOneWidget);
    expect(find.textContaining('(60 kg × 10)'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('Perfil → Sobre mostra o logo Caramelo Mutante e a versão', (
    tester,
  ) async {
    await abrirApp(tester);
    // Fora do Perfil, a aba já mostra o ícone do Caramelo (apagado).
    expect(find.byType(IconeCaramelo), findsOneWidget);
    await tocar(tester, find.text('PERFIL'));
    // Na aba e como avatar ao lado do título.
    expect(find.byType(IconeCaramelo), findsNWidgets(2));
    await tester.scrollUntilVisible(find.textContaining('VERSÃO 0.4.0'), 300);
    await tester.pumpAndSettle();

    expect(find.text('SOBRE'), findsOneWidget);
    expect(find.bySemanticsLabel('Caramelo Mutante'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('Evolução e gráfico com texto em 200%', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await abrirApp(
      tester,
      antes: (db) async {
        final sessaoA = (await PlanoRepository(db).sessoesComItens()).first;
        final treinos = TreinoRepository(db);
        final treino = await treinos.iniciar(sessaoA.sessao.id);
        await treinos.registrarSerie(
          treinoId: treino.id,
          item: sessaoA.itens.first.item,
          numero: 1,
          cargaPlanKg: 60,
          repsPlan: 10,
          cargaKg: 62.5,
          reps: 9,
        );
        await treinos.finalizar(treino.id);
      },
    );

    await tocar(tester, find.text('EVOLUÇÃO'));
    await tocar(tester, find.text('Supino reto com barra'));
    expect(find.byType(GraficoEvolucao), findsOneWidget);
    await tester.scrollUntilVisible(find.text('SUBSTITUTOS'), 300);

    await fecharApp(tester);
  });

  testWidgets('com texto em 200%, as telas principais não quebram', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await abrirApp(tester);

    // Em 200%, a prévia ocupa a tela toda: fecha como o botão voltar.
    await tocar(tester, find.text('Só tenho 20 minutos'));
    expect(find.text('Começar versão de 20 min'), findsOneWidget);
    Navigator.of(tester.element(find.text('SÓ TENHO 20 MINUTOS'))).pop();
    await tester.pumpAndSettle();

    await tocar(tester, find.text('Começar treino'));
    expect(find.text('Registrar série'), findsOneWidget);
    await tocar(tester, find.text('Registrar série'));
    expect(find.text('DESCANSO'), findsOneWidget);
    await tocar(tester, find.text('Pular descanso'));

    await tocar(tester, find.text('Sobre o exercício'));
    expect(find.text('MÚSCULOS-ALVO'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tocar(tester, find.text('Ocupado'));
    await tocar(tester, find.text('Supino na máquina'));
    expect(find.text('Trocar só hoje'), findsOneWidget);

    await fecharApp(tester);
  });
}
