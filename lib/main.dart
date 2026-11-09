import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/backup/backup_controller.dart';
import 'core/backup/backup_nuvem.dart';
import 'core/backup/backup_supabase.dart';
import 'core/backup/config_backup.dart';
import 'core/db/app_database.dart';
import 'core/db/providers.dart';
import 'core/db/seed.dart';
import 'core/notificacoes/aviso_descanso.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await popularSeedDosAssets(db);
  final aviso = await AvisoDescansoLocal.criar();
  final nuvem = await _abrirBackup();

  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      avisoDescansoProvider.overrideWithValue(aviso),
      backupNuvemProvider.overrideWithValue(nuvem),
    ],
  );
  runApp(
    UncontrolledProviderScope(container: container, child: const TreinoApp()),
  );

  // Backup ao abrir e ao voltar para o app (seção 5 do PRD). Sem conta ou sem
  // internet, não atrapalha: o erro fica no Perfil e tenta de novo depois.
  final backup = container.read(backupControllerProvider.notifier);
  unawaited(backup.sincronizar());
  AppLifecycleListener(onResume: () => unawaited(backup.sincronizar()));
}

/// O Supabase só entra quando o build tem a URL e a chave (`.env`).
Future<BackupNuvem?> _abrirBackup() async {
  if (!ConfigBackup.configurado) return null;
  try {
    await Supabase.initialize(
      url: ConfigBackup.url,
      publishableKey: ConfigBackup.chavePublica,
    );
    return BackupSupabase(Supabase.instance.client);
  } on Exception catch (e) {
    debugPrint('Backup desligado: $e');
    return null;
  }
}
