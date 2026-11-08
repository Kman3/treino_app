import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:treino_app/core/db/app_database.dart';
import 'package:treino_app/core/db/seed.dart';

AppDatabase abrirBancoDeTeste() {
  // Cada teste abre um banco novo de propósito.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}

/// Popula o banco com os mesmos arquivos de seed que o app embarca.
Future<bool> popularSeedDeTeste(AppDatabase db, {DateTime? agora}) {
  return popularSeed(
    db,
    exerciciosJson: File(caminhoSeedExercicios).readAsStringSync(),
    planoJson: File(caminhoSeedPlano).readAsStringSync(),
    agora: agora,
  );
}
