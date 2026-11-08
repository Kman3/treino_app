import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notificacoes/aviso_descanso.dart';
import 'app_database.dart';
import 'repositorios/evolucao_repository.dart';
import 'repositorios/exercicio_repository.dart';
import 'repositorios/plano_repository.dart';
import 'repositorios/preferencias_repository.dart';
import 'repositorios/treino_repository.dart';

/// Substituído em `main.dart` (banco do aparelho) e nos testes (em memória).
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider precisa de override'),
);

final planoRepositoryProvider = Provider(
  (ref) => PlanoRepository(ref.watch(databaseProvider)),
);

final treinoRepositoryProvider = Provider(
  (ref) => TreinoRepository(ref.watch(databaseProvider)),
);

final preferenciasRepositoryProvider = Provider(
  (ref) => PreferenciasRepository(ref.watch(databaseProvider)),
);

final exercicioRepositoryProvider = Provider(
  (ref) => ExercicioRepository(ref.watch(databaseProvider)),
);

final evolucaoRepositoryProvider = Provider(
  (ref) => EvolucaoRepository(ref.watch(databaseProvider)),
);

/// Substituído em `main.dart` pela notificação local no Android.
final avisoDescansoProvider = Provider<AvisoDescanso>(
  (ref) => const AvisoDescansoNulo(),
);
