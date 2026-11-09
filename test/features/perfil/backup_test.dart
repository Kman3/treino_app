import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/app.dart';
import 'package:treino_app/core/backup/backup_controller.dart';
import 'package:treino_app/core/db/app_database.dart';
import 'package:treino_app/core/db/providers.dart';

import '../../helpers.dart';
import '../../nuvem_falsa.dart';

/// Perfil → Backup (etapa 5): login por código e o estado do backup.
void main() {
  late AppDatabase db;

  Future<void> abrirPerfil(WidgetTester tester, {NuvemFalsa? nuvem}) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    db = abrirBancoDeTeste();
    await popularSeedDeTeste(db);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          if (nuvem != null) backupNuvemProvider.overrideWithValue(nuvem),
        ],
        child: const TreinoApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('PERFIL'));
    await tester.pumpAndSettle();
    // O campo de e-mail também é rolável: a lista do Perfil é a primeira.
    await tester.scrollUntilVisible(
      find.text('BACKUP'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  Future<void> fecharApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    final fechando = db.close();
    await tester.pump(const Duration(seconds: 1));
    await fechando;
  }

  Future<void> tocar(WidgetTester tester, String texto) async {
    await tester.ensureVisible(find.text(texto));
    await tester.pumpAndSettle();
    await tester.tap(find.text(texto));
    await tester.pumpAndSettle();
  }

  testWidgets('sem configuração, o Perfil avisa que o backup está desligado', (
    tester,
  ) async {
    await abrirPerfil(tester);
    expect(find.textContaining('não está configurado'), findsOneWidget);
    await fecharApp(tester);
  });

  testWidgets('entrar com o código liga o backup e sobe os dados', (
    tester,
  ) async {
    final nuvem = NuvemFalsa();
    await abrirPerfil(tester, nuvem: nuvem);

    await tester.enterText(find.byType(TextField), 'kleber@exemplo.com');
    await tocar(tester, 'Enviar código');
    expect(nuvem.codigoEnviadoPara, 'kleber@exemplo.com');
    expect(
      find.text('Enviamos um código de 6 dígitos para kleber@exemplo.com.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), '000000');
    await tocar(tester, 'Entrar');
    expect(
      find.text('Código inválido ou vencido. Peça outro.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), NuvemFalsa.codigoCerto);
    await tocar(tester, 'Entrar');
    expect(find.text('Conectado como kleber@exemplo.com'), findsOneWidget);
    expect(find.text('Tudo salvo na nuvem.'), findsOneWidget);
    expect(find.textContaining('Último backup: hoje'), findsOneWidget);
    expect(nuvem.contar('planos_treino'), 1);
    expect(nuvem.contar('itens_plano'), 18);

    await tocar(tester, 'Sair da conta');
    await tocar(tester, 'Sair');
    expect(find.text('Enviar código'), findsOneWidget);
    expect(nuvem.conta, isNull);

    await fecharApp(tester);
  });

  testWidgets('sem internet, o erro aparece e nada se perde', (tester) async {
    final nuvem = NuvemFalsa();
    await abrirPerfil(tester, nuvem: nuvem);
    await tester.enterText(find.byType(TextField), 'kleber@exemplo.com');
    await tocar(tester, 'Enviar código');
    await tester.enterText(find.byType(TextField), NuvemFalsa.codigoCerto);
    await tocar(tester, 'Entrar');

    nuvem.semInternet = true;
    await tocar(tester, 'Sincronizar agora');
    expect(
      find.text('Sem internet. O backup tenta de novo quando o app abrir.'),
      findsOneWidget,
    );

    nuvem.semInternet = false;
    await tocar(tester, 'Sincronizar agora');
    expect(find.text('Tudo salvo na nuvem.'), findsOneWidget);

    await fecharApp(tester);
  });
}
