import 'package:drift/drift.dart' show Value;

import '../../core/db/app_database.dart';
import '../../core/db/repositorios/plano_repository.dart';
import '../progressao/progressao.dart';
import 'versao_reduzida.dart';

/// A sessão como este treino a executa: na versão de 20 minutos, com as trocas
/// feitas só hoje e sem os exercícios tirados por dor. Um exercício tirado no
/// meio fica com as séries que já tinha feito; tirado antes da primeira, sai
/// da lista e vai para [removidos].
({SessaoComItens sessao, List<ItemComExercicio> removidos})
montarSessaoDoTreino(
  SessaoComItens doPlano, {
  required Treino treino,
  required Map<String, Substituicao> trocas,
  required Map<String, Exercicio> catalogo,
  required List<AjusteExecucao> ajustes,
  required List<Serie> series,
}) {
  var itens = ehVinteMinutos(treino)
      ? versaoVinteMinutos(doPlano.itens)
      : doPlano.itens;

  itens = [
    for (final i in itens)
      switch ((
        trocas[i.item.id],
        catalogo[trocas[i.item.id]?.exercicioNovoId],
      )) {
        (final troca?, final novo?) => ItemComExercicio(
          i.item.copyWith(
            exercicioId: novo.id,
            cargaPlanKg: Value(troca.cargaKg),
          ),
          novo,
          original: i.exercicio,
        ),
        _ => i,
      },
  ];

  final tirados = {
    for (final a in ajustes)
      if (a.removido) a.itemPlanoId,
  };
  final removidos = <ItemComExercicio>[];
  final ficam = <ItemComExercicio>[];
  for (final i in itens) {
    if (!tirados.contains(i.item.id)) {
      ficam.add(i);
      continue;
    }
    final feitas = series
        .where((s) => !s.aquecimento && s.itemPlanoId == i.item.id)
        .map((s) => s.numero);
    if (feitas.isEmpty) {
      removidos.add(i);
    } else {
      final ultima = feitas.reduce((a, b) => a > b ? a : b);
      ficam.add(
        ItemComExercicio(
          i.item.copyWith(series: ultima),
          i.exercicio,
          original: i.original,
        ),
      );
    }
  }
  return (sessao: SessaoComItens(doPlano.sessao, ficam), removidos: removidos);
}

/// A série que a pessoa vai fazer agora, já com a carga e as reps planejadas
/// para ela (que mudam no modo PR e no aquecimento).
class PosicaoSerie {
  const PosicaoSerie({
    required this.indiceItem,
    required this.item,
    required this.numero,
    required this.cargaPlanKg,
    required this.repsPlan,
    this.percentual,
    this.aquecimento = false,
  });

  /// Posição do exercício na sessão, começando em 0.
  final int indiceItem;
  final ItemComExercicio item;

  /// Número da série dentro do exercício, começando em 1. O aquecimento é 0.
  final int numero;

  /// Carga planejada. Nula em exercícios por tempo ou peso corporal.
  final double? cargaPlanKg;

  /// Reps (ou segundos) planejados.
  final int repsPlan;

  /// Fração da carga do plano (0,5 = 50%), no modo PR e no aquecimento.
  final double? percentual;

  final bool aquecimento;
}

/// PR batido no modo PR, à espera da resposta "usar como novo zero?".
class NovoPr {
  const NovoPr({
    required this.item,
    required this.serie,
    required this.prAnteriorKg,
    required this.novaBaseUmRm,
    required this.datas,
  });

  final ItemComExercicio item;

  /// A última série da escada, a do PR.
  final Serie serie;
  final double? prAnteriorKg;

  /// Carga do plano pela conversão do 1RM (Epley) para as reps do plano.
  final double novaBaseUmRm;

  /// Dias em que essa carga (ou mais) já foi feita, incluindo hoje.
  final List<DateTime> datas;

  double get cargaPr => serie.cargaKg!;
  double get cargaPlanoAtual => item.item.cargaPlanKg!;

  /// A conversão pelo 1RM sobe a carga do plano?
  bool get umRmSobe => novaBaseUmRm > cargaPlanoAtual;
}

/// Estado do treino em andamento, sempre reconstruído a partir do banco.
///
/// A série atual é a primeira que falta no exercício de menor ordem que ainda
/// não terminou; por isso fechar e reabrir o app retoma no ponto certo.
class EstadoExecucao {
  EstadoExecucao({
    required this.treino,
    required this.sessao,
    required List<Serie> series,
    this.ultimaVez = const {},
    List<AjusteExecucao> ajustes = const [],
    this.preferencias,
    this.prAnterior = const {},
    this.datasNovoPr = const {},
    this.trocas = const {},
    this.removidos = const [],
  }) : _todas = series,
       _ajustes = {for (final a in ajustes) a.itemPlanoId: a};

  final Treino treino;

  /// A sessão como este treino a executa (ver [montarSessaoDoTreino]).
  final SessaoComItens sessao;

  /// Por item do plano, a troca feita só neste treino.
  final Map<String, Substituicao> trocas;

  /// Exercícios tirados por dor antes da primeira série.
  final List<ItemComExercicio> removidos;

  bool get vinteMinutos => ehVinteMinutos(treino);

  Substituicao? trocaDo(ItemComExercicio item) => trocas[item.item.id];

  /// A pessoa registrou dor neste exercício hoje.
  bool dorEm(ItemComExercicio item) => _ajustes[item.item.id]?.dor ?? false;

  /// Por exercício, as séries do treino anterior em que ele apareceu.
  final Map<String, List<Serie>> ultimaVez;

  /// Nulo = as padrão (sugestão ligada, novo zero pelo 1RM).
  final Preferencia? preferencias;

  /// Por exercício, a maior carga registrada antes deste treino (o PR atual).
  final Map<String, double> prAnterior;

  /// Por item com novo PR, os dias em que essa carga (ou mais) já foi feita.
  final Map<String, List<DateTime>> datasNovoPr;

  bool get sugestaoLigada => preferencias?.sugestaoCargaMenor ?? true;

  ModoNovoZero get modoNovoZero =>
      ModoNovoZero.de(preferencias?.modoNovoZero ?? ModoNovoZero.umRm.valor);

  double? prAtualDe(ItemComExercicio item) => prAnterior[item.exercicio.id];

  final List<Serie> _todas;
  final Map<String, AjusteExecucao> _ajustes;

  /// Séries do plano registradas neste treino (sem aquecimentos).
  late final List<Serie> series = _todas.where((s) => !s.aquecimento).toList();

  List<Serie> seriesDoItem(String itemPlanoId) =>
      series.where((s) => s.itemPlanoId == itemPlanoId).toList()
        ..sort((a, b) => a.numero.compareTo(b.numero));

  Serie? serieDoItem(String itemPlanoId, int numero) => series
      .where((s) => s.itemPlanoId == itemPlanoId && s.numero == numero)
      .firstOrNull;

  ItemComExercicio? itemDa(Serie serie) =>
      sessao.itens.where((i) => i.item.id == serie.itemPlanoId).firstOrNull;

  Serie? aquecimentoDoItem(String itemPlanoId) => _todas
      .where((s) => s.aquecimento && s.itemPlanoId == itemPlanoId)
      .firstOrNull;

  /// O exercício aceita carga progressiva: carga externa planejada e ao
  /// menos 2 séries.
  bool aceitaPr(ItemComExercicio item) =>
      item.exercicio.tipoCarga == TipoCarga.externa &&
      item.item.cargaPlanKg != null &&
      item.item.series >= 2;

  bool prAtivo(ItemComExercicio item) =>
      aceitaPr(item) && (_ajustes[item.item.id]?.progressaoPr ?? false);

  /// Aquecimento pedido e ainda não registrado. Com o modo PR ligado ele não
  /// vale: as primeiras séries leves já servem de aquecimento.
  bool aquecimentoPendente(ItemComExercicio item) =>
      (_ajustes[item.item.id]?.aquecimento ?? false) &&
      !prAtivo(item) &&
      aquecimentoDoItem(item.item.id) == null &&
      seriesDoItem(item.item.id).isEmpty;

  /// O botão de aquecimento aparece antes da primeira série de um exercício
  /// com carga, enquanto o modo PR estiver desligado.
  bool podeAquecer(PosicaoSerie posicao) =>
      !posicao.aquecimento &&
      posicao.item.exercicio.tipoCarga == TipoCarga.externa &&
      posicao.item.item.cargaPlanKg != null &&
      !prAtivo(posicao.item) &&
      aquecimentoDoItem(posicao.item.item.id) == null &&
      seriesDoItem(posicao.item.item.id).isEmpty;

  /// Carga e reps planejadas para a série [numero] (1 = primeira) do item.
  PlanoDaSerie planoDa(ItemComExercicio item, int numero) {
    final base = item.item.cargaPlanKg;
    final tipo = item.exercicio.tipoCarga;
    if (prAtivo(item)) {
      return planoPr(
        cargaBase: base!,
        repsBase: item.item.repsMax,
        series: item.item.series,
        numero: numero,
        equipamento: item.exercicio.equipamento,
        passo: item.exercicio.passoCargaKg,
        prAtualKg: prAtualDe(item),
      );
    }
    return (
      cargaKg: tipo == TipoCarga.externa
          ? (_reducao(item, numero)?.carga ?? base)
          : null,
      reps: item.item.repsMax,
      percentual: null,
    );
  }

  /// A série anterior que sugeriu a carga menor em vigor para a série
  /// [numero], se a pessoa não escolheu manter a carga. É ela que o botão
  /// "Manter carga" da 02A desliga.
  Serie? serieQueSugeriu(ItemComExercicio item, int numero) =>
      _reducao(item, numero)?.gatilho;

  /// Carga menor sugerida para a série [numero]. A série mais recente que
  /// pediu redução decide: um passo abaixo do que ela fez, ou a carga dela
  /// mesma se a pessoa escolheu manter. Sem pedido, vale o plano.
  ({double carga, Serie? gatilho})? _reducao(
    ItemComExercicio item,
    int numero,
  ) {
    if (!sugestaoLigada || prAtivo(item)) return null;
    final base = item.item.cargaPlanKg;
    final exercicio = item.exercicio;
    if (base == null || exercicio.tipoCarga != TipoCarga.externa) return null;

    for (var n = numero - 1; n >= 1; n--) {
      final anterior = serieDoItem(item.item.id, n);
      // Série ainda por fazer: a prévia das próximas olha as já feitas.
      if (anterior == null) continue;
      final feita = anterior.cargaKg;
      if (feita == null) return null;
      final pediu = sugerirCargaMenor(
        repsFeitas: anterior.reps ?? 0,
        repsMin: item.item.repsMin,
        rir: anterior.rir,
        ultimaSerie: false,
      );
      if (!pediu) continue;
      if (anterior.manterCarga) {
        return feita < base ? (carga: feita, gatilho: null) : null;
      }
      final menor = arredondarCarga(
        feita -
            incrementoCarga(
              feita,
              exercicio.equipamento,
              exercicio.passoCargaKg,
            ),
        equipamento: exercicio.equipamento,
        passo: exercicio.passoCargaKg,
      );
      return (carga: menor, gatilho: anterior);
    }
    return null;
  }

  /// Série que abriu o descanso em andamento. Nula sem descanso, ou se a
  /// série foi desfeita.
  Serie? get serieDoDescanso {
    final id = treino.descansoSerieId;
    if (treino.descansoTerminaEm == null || id == null) return null;
    return _todas.where((s) => s.id == id).firstOrNull;
  }

  DateTime? get descansoTerminaEm =>
      serieDoDescanso == null ? null : treino.descansoTerminaEm;

  /// PR batido no modo PR ainda sem resposta para "usar como novo zero?".
  NovoPr? novoPrDo(ItemComExercicio item) {
    if (!prAtivo(item)) return null;
    if (_ajustes[item.item.id]?.novoZeroRespondido ?? false) return null;
    final ultima = serieDoItem(item.item.id, item.item.series);
    final carga = ultima?.cargaKg;
    if (ultima == null || carga == null) return null;
    final bateu = bateuPr(
      cargaFinal: carga,
      repsFeitas: ultima.reps ?? 0,
      repsMeta: ultima.repsPlan ?? 1,
      cargaBase: item.item.cargaPlanKg!,
      prAnteriorKg: prAtualDe(item),
    );
    if (!bateu) return null;
    return NovoPr(
      item: item,
      serie: ultima,
      prAnteriorKg: prAtualDe(item),
      novaBaseUmRm: novaBasePorUmRm(
        carga: carga,
        reps: ultima.reps ?? 1,
        repsPlano: item.item.repsMax,
        equipamento: item.exercicio.equipamento,
        passo: item.exercicio.passoCargaKg,
      ),
      datas: datasNovoPr[item.item.id] ?? const [],
    );
  }

  List<NovoPr> get novosPrPendentes =>
      sessao.itens.map(novoPrDo).nonNulls.toList();

  late final PosicaoSerie? atual = _calcularAtual();

  /// Primeira série que falta: se uma do meio foi excluída, é ela que volta.
  PosicaoSerie? _calcularAtual() {
    for (final (indice, item) in sessao.itens.indexed) {
      if (aquecimentoPendente(item)) {
        final plano = planoAquecimento(
          cargaBase: item.item.cargaPlanKg!,
          repsMin: item.item.repsMin,
          equipamento: item.exercicio.equipamento,
          passo: item.exercicio.passoCargaKg,
        );
        return PosicaoSerie(
          indiceItem: indice,
          item: item,
          numero: 0,
          cargaPlanKg: plano.cargaKg,
          repsPlan: plano.reps,
          percentual: plano.percentual,
          aquecimento: true,
        );
      }
      final feitas = seriesDoItem(item.item.id).map((s) => s.numero).toSet();
      for (var numero = 1; numero <= item.item.series; numero++) {
        if (!feitas.contains(numero)) {
          final plano = planoDa(item, numero);
          return PosicaoSerie(
            indiceItem: indice,
            item: item,
            numero: numero,
            cargaPlanKg: plano.cargaKg,
            repsPlan: plano.reps,
            percentual: plano.percentual,
          );
        }
      }
    }
    return null;
  }

  bool get completo => atual == null;

  int get totalSeries =>
      sessao.itens.fold(0, (total, i) => total + i.item.series);

  int get seriesFeitas => series.length;

  /// Fração do treino feita, pelas séries do plano (0 a 1).
  double get progresso => totalSeries == 0 ? 0 : seriesFeitas / totalSeries;

  /// Volume levantado nas séries do plano: soma de carga × reps, em kg.
  double get volumeKg => series
      .where((s) => s.cargaKg != null && s.reps != null)
      .fold(0, (total, s) => total + s.cargaKg! * s.reps!);

  /// A série de mesmo número na última vez, ou a última feita naquele dia.
  Serie? ultimaVezDa(PosicaoSerie posicao) {
    if (posicao.aquecimento) return null;
    final anteriores = ultimaVez[posicao.item.exercicio.id];
    if (anteriores == null || anteriores.isEmpty) return null;
    return anteriores.firstWhere(
      (s) => s.numero == posicao.numero,
      orElse: () => anteriores.last,
    );
  }
}
