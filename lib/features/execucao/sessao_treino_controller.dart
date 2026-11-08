import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import '../../core/db/repositorios/plano_repository.dart';
import '../../core/db/repositorios/treino_repository.dart';
import 'estado_execucao.dart';

/// Única porta de entrada para mudar o treino em andamento. Cada ação grava no
/// banco na hora; a tela só lê o [EstadoExecucao] que o banco devolve.
class SessaoTreinoController {
  SessaoTreinoController(this._db, this._planos, this._treinos);

  final AppDatabase _db;
  final PlanoRepository _planos;
  final TreinoRepository _treinos;

  /// Inicia um treino da sessão e devolve o id dele.
  Future<String> iniciar(String sessaoPlanoId) async {
    final treino = await _treinos.iniciar(sessaoPlanoId);
    return treino.id;
  }

  Future<EstadoExecucao?> carregar(String treinoId) async {
    final treino = await _treinos.treino(treinoId);
    if (treino == null) return null;
    final sessao = await _planos.sessaoComItens(treino.sessaoPlanoId);
    if (sessao == null) return null;

    return EstadoExecucao(
      treino: treino,
      sessao: sessao,
      series: await _treinos.seriesDoTreino(treinoId),
      ultimaVez: await _treinos.ultimaVez(
        sessao.itens.map((i) => i.exercicio.id),
        excetoTreinoId: treinoId,
      ),
      ajustes: await _treinos.ajustesDoTreino(treinoId),
    );
  }

  /// Emite de novo a cada série gravada, desfeita, ajuste ou treino finalizado.
  Stream<EstadoExecucao?> watch(String treinoId) {
    return _db
        .quandoMudar('execucao', {
          _db.treinos,
          _db.series,
          _db.ajustesExecucao,
          _db.itensPlano,
          _db.exercicios,
        })
        .asyncMap((_) => carregar(treinoId));
  }

  /// Liga ou desliga "Tentar bater o PR" no exercício. As séries já feitas
  /// mantêm o que foi gravado; só as que faltam mudam de carga.
  Future<void> definirPr(
    EstadoExecucao estado,
    ItemComExercicio item, {
    required bool ativo,
  }) => _treinos.salvarAjuste(
    treinoId: estado.treino.id,
    itemPlanoId: item.item.id,
    progressaoPr: ativo,
  );

  /// Pede (ou cancela) a série extra de aquecimento antes da primeira série.
  Future<void> definirAquecimento(
    EstadoExecucao estado,
    ItemComExercicio item, {
    required bool ativo,
  }) => _treinos.salvarAjuste(
    treinoId: estado.treino.id,
    itemPlanoId: item.item.id,
    aquecimento: ativo,
  );

  /// Registra a série atual. Sem [cargaKg]/[reps], grava o planejado.
  Future<Serie?> registrar(
    EstadoExecucao estado, {
    double? cargaKg,
    int? reps,
  }) async {
    final posicao = estado.atual;
    if (posicao == null) return null;

    return _treinos.registrarSerie(
      treinoId: estado.treino.id,
      item: posicao.item.item,
      numero: posicao.numero,
      cargaPlanKg: posicao.cargaPlanKg,
      repsPlan: posicao.repsPlan,
      cargaKg: cargaKg ?? posicao.cargaPlanKg,
      reps: reps ?? posicao.repsPlan,
      aquecimento: posicao.aquecimento,
    );
  }

  /// Corrige uma série já registrada, mesmo de um exercício anterior.
  Future<void> corrigir(Serie serie, {double? cargaKg, required int reps}) =>
      _treinos.corrigirSerie(serie, cargaKg: cargaKg, reps: reps);

  /// Desfaz um registro feito por engano. A série volta a faltar, e a atual
  /// passa a ser a primeira que falta na ordem do treino.
  Future<void> desfazer(String serieId) => _treinos.excluirSerie(serieId);

  Future<void> finalizar(EstadoExecucao estado) {
    return _treinos.finalizar(
      estado.treino.id,
      status: estado.completo ? StatusTreino.concluido : StatusTreino.parcial,
    );
  }
}

final sessaoTreinoControllerProvider = Provider(
  (ref) => SessaoTreinoController(
    ref.watch(databaseProvider),
    ref.watch(planoRepositoryProvider),
    ref.watch(treinoRepositoryProvider),
  ),
);

/// Descartado ao sair da tela, para que reabrir o treino leia o banco de novo.
final estadoExecucaoProvider = StreamProvider.autoDispose
    .family<EstadoExecucao?, String>(
      (ref, treinoId) =>
          ref.watch(sessaoTreinoControllerProvider).watch(treinoId),
    );
