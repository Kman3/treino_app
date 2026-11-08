import '../../core/db/app_database.dart';
import '../../core/db/repositorios/plano_repository.dart';
import '../progressao/progressao.dart';

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
  }) : _todas = series,
       _ajustes = {for (final a in ajustes) a.itemPlanoId: a};

  final Treino treino;
  final SessaoComItens sessao;

  /// Por exercício, as séries do treino anterior em que ele apareceu.
  final Map<String, List<Serie>> ultimaVez;

  final List<Serie> _todas;
  final Map<String, AjusteExecucao> _ajustes;

  /// Séries do plano registradas neste treino (sem aquecimentos).
  late final List<Serie> series = _todas.where((s) => !s.aquecimento).toList();

  List<Serie> seriesDoItem(String itemPlanoId) =>
      series.where((s) => s.itemPlanoId == itemPlanoId).toList()
        ..sort((a, b) => a.numero.compareTo(b.numero));

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
      );
    }
    return (
      cargaKg: tipo == TipoCarga.externa ? base : null,
      reps: item.item.repsMax,
      percentual: null,
    );
  }

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
