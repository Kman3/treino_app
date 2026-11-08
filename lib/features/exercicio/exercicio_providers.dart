import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import '../../core/db/repositorios/evolucao_repository.dart';
import '../../core/db/repositorios/plano_repository.dart';

final exercicioProvider = FutureProvider.autoDispose.family<Exercicio?, String>(
  (ref, id) => ref.watch(exercicioRepositoryProvider).exercicio(id),
);

final substitutosProvider = FutureProvider.autoDispose
    .family<List<Exercicio>, String>((ref, id) async {
      final exercicio = await ref.watch(exercicioProvider(id).future);
      if (exercicio == null) return const [];
      return ref.watch(exercicioRepositoryProvider).substitutos(exercicio);
    });

final evolucaoDoExercicioProvider = StreamProvider.autoDispose
    .family<Evolucao?, String>(
      (ref, id) => ref.watch(evolucaoRepositoryProvider).watchDoExercicio(id),
    );

final itemPlanoProvider = FutureProvider.autoDispose.family<ItemPlano?, String>(
  (ref, id) => ref.watch(planoRepositoryProvider).item(id),
);

/// Evolução de todos os exercícios com histórico (aba Evolução).
final evolucoesProvider = StreamProvider.autoDispose<Map<String, Evolucao>>(
  (ref) => ref.watch(evolucaoRepositoryProvider).watchTodas(),
);

/// Sessões do plano ativo com os exercícios (aba Evolução).
final sessoesDoPlanoProvider = StreamProvider.autoDispose<List<SessaoComItens>>(
  (ref) => ref.watch(planoRepositoryProvider).watchSessoesComItens(),
);
