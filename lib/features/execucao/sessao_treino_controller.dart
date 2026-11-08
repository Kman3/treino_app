import 'package:clock/clock.dart';

import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import '../../core/db/repositorios/exercicio_repository.dart';
import '../../core/db/repositorios/plano_repository.dart';
import '../../core/db/repositorios/preferencias_repository.dart';
import '../../core/db/repositorios/treino_repository.dart';
import '../../core/notificacoes/aviso_descanso.dart';
import 'estado_execucao.dart';

/// Descanso depois da série de aquecimento, se o plano não pedir menos.
const descansoAquecimentoS = 60;

/// Única porta de entrada para mudar o treino em andamento. Cada ação grava no
/// banco na hora; a tela só lê o [EstadoExecucao] que o banco devolve.
class SessaoTreinoController {
  SessaoTreinoController(
    this._db,
    this._planos,
    this._treinos, {
    PreferenciasRepository? preferencias,
    ExercicioRepository? exercicios,
    AvisoDescanso aviso = const AvisoDescansoNulo(),
    DateTime Function()? agora,
  }) : _preferencias = preferencias ?? PreferenciasRepository(_db),
       _exercicios = exercicios ?? ExercicioRepository(_db, agora: agora),
       // Parâmetro nomeado não pode ser privado (`this._aviso`).
       // ignore: prefer_initializing_formals
       _aviso = aviso,
       _agora = agora ?? clock.now;

  final AppDatabase _db;
  final PlanoRepository _planos;
  final TreinoRepository _treinos;
  final PreferenciasRepository _preferencias;
  final ExercicioRepository _exercicios;
  final AvisoDescanso _aviso;
  final DateTime Function() _agora;

  /// Inicia um treino da sessão e devolve o id dele. Com [vinteMinutos], o
  /// treino usa a versão reduzida ("Só tenho 20 minutos"), sem mudar o plano.
  Future<String> iniciar(
    String sessaoPlanoId, {
    bool vinteMinutos = false,
  }) async {
    final treino = await _treinos.iniciar(
      sessaoPlanoId,
      modo: vinteMinutos ? ModoTreino.vinteMin : ModoTreino.normal,
    );
    return treino.id;
  }

  Future<EstadoExecucao?> carregar(String treinoId) async {
    final treino = await _treinos.treino(treinoId);
    if (treino == null) return null;
    final doPlano = await _planos.sessaoComItens(treino.sessaoPlanoId);
    if (doPlano == null) return null;
    final series = await _treinos.seriesDoTreino(treinoId);
    final ajustes = await _treinos.ajustesDoTreino(treinoId);
    final trocas = await _exercicios.trocasDoTreino(treinoId);
    final montado = montarSessaoDoTreino(
      doPlano,
      treino: treino,
      trocas: trocas,
      catalogo: trocas.isEmpty ? const {} : await _exercicios.catalogo(),
      ajustes: ajustes,
      series: series,
    );
    final sessao = montado.sessao;
    final exercicioIds = sessao.itens.map((i) => i.exercicio.id);
    final ultimaVez = await _treinos.ultimaVez(
      exercicioIds,
      excetoTreinoId: treinoId,
    );
    final preferencias = await _preferencias.obter();
    final recordes = await _treinos.recordes(
      exercicioIds,
      excetoTreinoId: treinoId,
    );

    EstadoExecucao montar([Map<String, List<DateTime>> datas = const {}]) =>
        EstadoExecucao(
          treino: treino,
          sessao: sessao,
          series: series,
          ultimaVez: ultimaVez,
          ajustes: ajustes,
          preferencias: preferencias,
          prAnterior: recordes,
          datasNovoPr: datas,
          trocas: trocas,
          removidos: montado.removidos,
        );

    final estado = montar();
    final novos = estado.novosPrPendentes;
    if (novos.isEmpty) return estado;
    return montar({
      for (final pr in novos)
        pr.item.item.id: await _treinos.datasComCarga(
          pr.item.exercicio.id,
          pr.cargaPr,
        ),
    });
  }

  /// Emite de novo a cada série gravada, desfeita, ajuste, descanso ou
  /// mudança de preferência.
  Stream<EstadoExecucao?> watch(String treinoId) {
    return _db
        .quandoMudar('execucao', {
          _db.treinos,
          _db.series,
          _db.ajustesExecucao,
          _db.itensPlano,
          _db.exercicios,
          _db.preferencias,
          _db.substituicoes,
        })
        .asyncMap((_) => carregar(treinoId));
  }

  /// "⇄ Ocupado": troca o exercício por [novo], só neste treino ou para
  /// sempre no plano. As séries já feitas ficam com o exercício antigo.
  Future<Substituicao> trocar(
    EstadoExecucao estado,
    ItemComExercicio item,
    Exercicio novo, {
    required bool sempre,
    required double? cargaKg,
  }) async {
    final anterior = estado.trocaDo(item);
    if (!sempre) {
      return _exercicios.trocarNoTreino(
        treinoId: estado.treino.id,
        item: item.item,
        exercicioOriginalId: anterior?.exercicioOriginalId ?? item.exercicio.id,
        exercicioNovoId: novo.id,
        cargaKg: cargaKg,
      );
    }
    // A troca deste treino daria lugar à do plano: sai antes.
    if (anterior != null) await _exercicios.desfazerTroca(anterior);
    return _exercicios.trocarSempre(
      itemPlanoId: item.item.id,
      exercicioNovoId: novo.id,
      cargaKg: cargaKg,
    );
  }

  Future<void> desfazerTroca(Substituicao troca) =>
      _exercicios.desfazerTroca(troca);

  /// "Senti dor": registra a dor nas séries já feitas do exercício e, com
  /// [tirar], tira o exercício do resto deste treino. Devolve o que mudou,
  /// para desfazer.
  Future<RegistroDor> sentiDor(
    EstadoExecucao estado,
    ItemComExercicio item, {
    required bool tirar,
  }) async {
    final treinoId = estado.treino.id;
    final ids = await _treinos.marcarDor(
      treinoId: treinoId,
      itemPlanoId: item.item.id,
      dor: true,
    );
    await _treinos.salvarAjuste(
      treinoId: treinoId,
      itemPlanoId: item.item.id,
      dor: true,
      removido: tirar ? true : null,
    );
    // O descanso de uma série desse exercício não faz mais sentido.
    final descanso = estado.serieDoDescanso;
    if (tirar && descanso?.itemPlanoId == item.item.id) {
      await encerrarDescanso(estado);
    }
    return (itemPlanoId: item.item.id, seriesIds: ids);
  }

  Future<void> desfazerDor(EstadoExecucao estado, RegistroDor registro) async {
    await _treinos.marcarDor(
      treinoId: estado.treino.id,
      itemPlanoId: registro.itemPlanoId,
      dor: false,
      apenas: registro.seriesIds,
    );
    await _treinos.salvarAjuste(
      treinoId: estado.treino.id,
      itemPlanoId: registro.itemPlanoId,
      dor: false,
      removido: false,
    );
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

  /// Registra a série atual e abre o descanso. Sem [cargaKg]/[reps], grava o
  /// planejado.
  Future<Serie?> registrar(
    EstadoExecucao estado, {
    double? cargaKg,
    int? reps,
  }) async {
    final posicao = estado.atual;
    if (posicao == null) return null;

    final serie = await _treinos.registrarSerie(
      treinoId: estado.treino.id,
      item: posicao.item.item,
      numero: posicao.numero,
      cargaPlanKg: posicao.cargaPlanKg,
      repsPlan: posicao.repsPlan,
      cargaKg: cargaKg ?? posicao.cargaPlanKg,
      reps: reps ?? posicao.repsPlan,
      aquecimento: posicao.aquecimento,
    );

    final segundos = posicao.aquecimento
        ? math.min(descansoAquecimentoS, posicao.item.item.descansoS)
        : posicao.item.item.descansoS;
    await _abrirDescanso(
      estado.treino.id,
      serie.id,
      _agora().add(Duration(seconds: segundos)),
      exercicio: posicao.item.exercicio.nome,
    );
    return serie;
  }

  Future<void> _abrirDescanso(
    String treinoId,
    String serieId,
    DateTime terminaEm, {
    required String exercicio,
  }) async {
    await _treinos.definirDescanso(
      treinoId,
      terminaEm: terminaEm,
      serieId: serieId,
    );
    await _aviso.pedirPermissao();
    await _aviso.agendar(terminaEm, texto: 'Hora da próxima série: $exercicio');
  }

  /// −15 s / +15 s no descanso em andamento. Nunca termina antes de agora.
  Future<void> ajustarDescanso(EstadoExecucao estado, int segundos) async {
    final terminaEm = estado.descansoTerminaEm;
    final serie = estado.serieDoDescanso;
    if (terminaEm == null || serie == null) return;
    final agora = _agora();
    var novo = terminaEm.add(Duration(seconds: segundos));
    if (novo.isBefore(agora)) novo = agora;
    await _abrirDescanso(
      estado.treino.id,
      serie.id,
      novo,
      exercicio: estado.itemDa(serie)?.exercicio.nome ?? '',
    );
  }

  /// Fim do descanso: pelo timer, por "Pular descanso" ou por desfazer a série.
  ///
  /// Com [manterAviso], a notificação de fim continua na tela. É o caso do
  /// timer zerar com o app em segundo plano: o aviso acabou de tocar, e
  /// cancelá-lo apagaria a notificação antes de a pessoa ver.
  Future<void> encerrarDescanso(
    EstadoExecucao estado, {
    bool manterAviso = false,
  }) async {
    await _treinos.definirDescanso(estado.treino.id, terminaEm: null);
    if (!manterAviso) await _aviso.cancelar();
  }

  /// Resposta de "Como foi?" (RIR de 0 a 4).
  Future<void> responderDificuldade(Serie serie, int rir) =>
      _treinos.responderDificuldade(serie.id, rir);

  /// "✓ Sim, igual".
  Future<void> confirmar(Serie serie) => _treinos.confirmarSerie(serie.id);

  /// Recusa a carga menor sugerida por [serie] para a próxima ("Manter carga"),
  /// ou volta a aceitá-la.
  Future<void> manterCarga(Serie serie, {required bool manter}) =>
      _treinos.definirManterCarga(serie.id, manter: manter);

  /// Corrige uma série já registrada, mesmo de um exercício anterior.
  Future<void> corrigir(Serie serie, {double? cargaKg, required int reps}) =>
      _treinos.corrigirSerie(serie, cargaKg: cargaKg, reps: reps);

  /// Tela 02C: grava os valores reais, a dificuldade e marca como confirmada.
  Future<void> ajustar(
    Serie serie, {
    double? cargaKg,
    required int reps,
    int? rir,
  }) async {
    await _treinos.corrigirSerie(serie, cargaKg: cargaKg, reps: reps);
    if (rir != null) await _treinos.responderDificuldade(serie.id, rir);
    await _treinos.confirmarSerie(serie.id);
  }

  /// Desfaz um registro feito por engano. A série volta a faltar, e a atual
  /// passa a ser a primeira que falta na ordem do treino. Se era a série do
  /// descanso, o descanso acaba junto.
  Future<void> desfazer(String serieId) async {
    await _treinos.excluirSerie(serieId);
    final treino = await (_db.select(
      _db.treinos,
    )..where((t) => t.descansoSerieId.equals(serieId))).getSingleOrNull();
    if (treino != null) {
      await _treinos.definirDescanso(treino.id, terminaEm: null);
      await _aviso.cancelar();
    }
  }

  /// Resposta para "usar o PR como novo ponto de partida?". Com [novaCargaKg],
  /// as séries normais do exercício passam a usar essa carga daqui em diante;
  /// sem ela, nada muda no plano.
  Future<void> decidirNovoZero(
    EstadoExecucao estado,
    NovoPr pr, {
    double? novaCargaKg,
  }) async {
    if (novaCargaKg != null) {
      await _planos.atualizarCargaPlano(pr.item.item.id, novaCargaKg);
    }
    await _treinos.salvarAjuste(
      treinoId: estado.treino.id,
      itemPlanoId: pr.item.item.id,
      novoZeroRespondido: true,
    );
  }

  /// Desfaz [decidirNovoZero]: devolve a carga anterior e a pergunta volta.
  Future<void> desfazerNovoZero(
    EstadoExecucao estado,
    NovoPr pr, {
    required double cargaAnteriorKg,
  }) async {
    await _planos.atualizarCargaPlano(pr.item.item.id, cargaAnteriorKg);
    await _treinos.salvarAjuste(
      treinoId: estado.treino.id,
      itemPlanoId: pr.item.item.id,
      novoZeroRespondido: false,
    );
  }

  Future<void> finalizar(EstadoExecucao estado) async {
    await _treinos.definirDescanso(estado.treino.id, terminaEm: null);
    await _aviso.cancelar();
    await _treinos.finalizar(
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
    preferencias: ref.watch(preferenciasRepositoryProvider),
    exercicios: ref.watch(exercicioRepositoryProvider),
    aviso: ref.watch(avisoDescansoProvider),
  ),
);

/// O que "Senti dor" mudou: o exercício e as séries marcadas com dor.
typedef RegistroDor = ({String itemPlanoId, List<String> seriesIds});

/// Descartado ao sair da tela, para que reabrir o treino leia o banco de novo.
final estadoExecucaoProvider = StreamProvider.autoDispose
    .family<EstadoExecucao?, String>(
      (ref, treinoId) =>
          ref.watch(sessaoTreinoControllerProvider).watch(treinoId),
    );
