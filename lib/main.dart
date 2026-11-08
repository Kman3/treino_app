import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/db/app_database.dart';
import 'core/db/providers.dart';
import 'core/db/seed.dart';
import 'core/notificacoes/aviso_descanso.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await popularSeedDosAssets(db);
  final aviso = await AvisoDescansoLocal.criar();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        avisoDescansoProvider.overrideWithValue(aviso),
      ],
      child: const TreinoApp(),
    ),
  );
}
