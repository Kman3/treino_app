import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/providers.dart';
import '../../core/db/repositorios/plano_repository.dart';

// autoDispose: ao voltar de um treino, a tela lê o banco de novo em vez de
// reaproveitar um valor guardado enquanto ela estava fora da árvore.

final treinoDoDiaProvider = StreamProvider.autoDispose<TreinoDoDia?>(
  (ref) => ref.watch(planoRepositoryProvider).watchTreinoDoDia(),
);

/// Prévia de outra sessão do ciclo, ao tocar no dia no cabeçalho.
final sessaoProvider = StreamProvider.autoDispose
    .family<SessaoComItens?, String>(
      (ref, sessaoId) =>
          ref.watch(planoRepositoryProvider).watchSessao(sessaoId),
    );
