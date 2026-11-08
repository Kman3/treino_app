import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/app.dart';
import 'package:treino_app/core/db/app_database.dart';
import 'package:treino_app/core/db/providers.dart';

import '../../helpers.dart';

void main() {
  late AppDatabase db;

  // O banco é aberto dentro do teste (e não no setUp) para que as consultas
  // rodem na mesma zona de tempo simulado que o `pump` avança.
  Future<void> abrirApp(WidgetTester tester) async {
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
    // Desmonta antes de fechar o banco, para encerrar as consultas reativas.
    // O fechamento depende de timers, que só andam com o `pump`.
    await tester.pumpWidget(const SizedBox());
    final fechando = db.close();
    await tester.pump(const Duration(seconds: 1));
    await fechando;
  }

  testWidgets('mostra o treino do dia lido do banco', (tester) async {
    await abrirApp(tester);

    expect(find.text('Treino A'), findsOneWidget);
    expect(find.text('Peito, ombros e tríceps'), findsOneWidget);
    expect(find.text('SEMANA 1 DE 4 · CICLO ABC'), findsOneWidget);
    expect(find.text('Supino reto com barra'), findsOneWidget);
    expect(find.text('Começar treino'), findsOneWidget);

    await fecharApp(tester);
  });

  testWidgets('tocar no B mostra a prévia do Treino B', (tester) async {
    await abrirApp(tester);

    await tester.tap(find.bySemanticsLabel('Treino B'));
    await tester.pumpAndSettle();

    expect(find.text('Treino B'), findsOneWidget);
    expect(find.text('Costas e bíceps'), findsOneWidget);
    expect(find.text('PRÉVIA · HOJE É O TREINO A'), findsOneWidget);
    expect(find.text('Puxada na frente (polia alta)'), findsOneWidget);
    expect(find.text('Começar treino'), findsNothing);

    await fecharApp(tester);
  });

  testWidgets('a aba Dieta aparece desabilitada', (tester) async {
    await abrirApp(tester);

    expect(find.text('EM BREVE'), findsOneWidget);
    expect(find.text('EVOLUÇÃO'), findsOneWidget);

    await tester.tap(find.text('EVOLUÇÃO'));
    await tester.pumpAndSettle();
    expect(find.text('Chega na etapa 4.'), findsOneWidget);

    await fecharApp(tester);
  });
}
