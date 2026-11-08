import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/providers.dart';
import '../../core/db/repositorios/plano_repository.dart';

final treinoDoDiaProvider = StreamProvider<TreinoDoDia?>(
  (ref) => ref.watch(planoRepositoryProvider).watchTreinoDoDia(),
);

/// Prévia de outra sessão do ciclo, ao tocar no dia no cabeçalho.
final sessaoProvider = StreamProvider.family<SessaoComItens?, String>(
  (ref, sessaoId) => ref.watch(planoRepositoryProvider).watchSessao(sessaoId),
);
