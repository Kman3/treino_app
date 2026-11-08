/// Regras de carga em Dart puro, sem Flutter, para testar isoladamente.
library;

import 'dart:math' as math;

/// Percentual da carga planejada usado na série extra de aquecimento.
const percentualAquecimento = 0.70;

/// Meta mínima de reps da última série do modo PR. Abaixo disso a tentativa
/// vira quase um teste de 1RM, então a carga é reduzida até caber em 3 reps.
const repsMinimasPr = 3;

/// Escada do modo "Tentar bater o PR": começa leve e termina acima da carga
/// planejada, com a penúltima série na carga planejada (100%).
///
/// 4 séries: 50% → 80% → 100% → 120%.
List<double> percentuaisPr(int series) {
  return switch (series) {
    <= 1 => const [1.0],
    2 => const [0.80, 1.20],
    3 => const [0.60, 1.00, 1.20],
    4 => const [0.50, 0.80, 1.00, 1.20],
    5 => const [0.50, 0.70, 0.85, 1.00, 1.20],
    _ => [
      // Sobe em linha reta de 50% até a carga planejada e termina em 120%.
      for (var i = 0; i < series - 1; i++) 0.50 + 0.50 * i / (series - 2),
      1.20,
    ],
  };
}

/// Menor diferença entre dois pesos disponíveis perto de [kg].
double incrementoCarga(double kg, String equipamento, double passo) {
  if (equipamento == 'halteres') return kg <= 10 ? 1 : 2;
  return passo > 0 ? passo : 2.5;
}

/// Arredonda a carga para um peso que existe na academia:
///
/// - halteres: de 1 em 1 kg até 10 kg e de 2 em 2 kg acima disso;
/// - os demais: múltiplo do passo do exercício (2,5 kg na barra, que é o
///   par de anilhas de 1,25 kg; 5 kg nas máquinas de placas).
///
/// Com [paraBaixo], pega o peso disponível imediatamente abaixo.
double arredondarCarga(
  double kg, {
  required String equipamento,
  required double passo,
  bool paraBaixo = false,
}) {
  final incremento = incrementoCarga(kg, equipamento, passo);
  final passos = kg / incremento;
  final arredondado =
      (paraBaixo ? (passos + 1e-9).floor() : passos.round()) * incremento;
  return math.max(incremento, double.parse(arredondado.toStringAsFixed(2)));
}

/// Reps que equivalem ao mesmo esforço com outra carga, pela fórmula de
/// Epley (1RM ≈ carga × (1 + reps / 30)). Serve para baixar a meta de reps
/// da série acima da carga planejada.
int repsEquivalentes({
  required double cargaBase,
  required int repsBase,
  required double carga,
}) {
  if (carga <= cargaBase) return repsBase;
  final umRm = cargaBase * (1 + repsBase / 30);
  final reps = (30 * (umRm / carga - 1) + 1e-9).floor();
  return reps.clamp(1, repsBase);
}

/// Carga e reps planejadas para uma série.
typedef PlanoDaSerie = ({double? cargaKg, int reps, double? percentual});

/// A mira acima do PR só vale até este múltiplo da carga planejada. Um PR
/// antigo muito acima do plano atual (ex.: depois de uma pausa) fica só como
/// referência, sem transformar a última série num salto perigoso.
const limiteMiraPr = 1.35;

/// Plano da série [numero] (de 1 a [series]) no modo PR.
///
/// Se a carga da escada deixaria menos de [repsMinimasPr] reps, ela desce
/// para o maior peso disponível que ainda dá essas reps (nunca abaixo da
/// carga planejada). Ex.: agachamento 70 kg × 8 → 80 kg × 3 em vez de 85 × 1.
///
/// Com [prAtualKg] igual ou acima da última carga da escada, a última série
/// mira o PR + 1 passo, com meta de pelo menos [repsMinimasPr] reps.
PlanoDaSerie planoPr({
  required double cargaBase,
  required int repsBase,
  required int series,
  required int numero,
  required String equipamento,
  required double passo,
  double? prAtualKg,
}) {
  final percentuais = percentuaisPr(series);
  final percentual = percentuais[(numero - 1).clamp(0, percentuais.length - 1)];
  var carga = arredondarCarga(
    cargaBase * percentual,
    equipamento: equipamento,
    passo: passo,
  );
  int reps() =>
      repsEquivalentes(cargaBase: cargaBase, repsBase: repsBase, carga: carga);
  final minimo = math.min(repsMinimasPr, repsBase);

  if (reps() < minimo) {
    final umRm = cargaBase * (1 + repsBase / 30);
    carga = math.max(
      cargaBase,
      arredondarCarga(
        umRm / (1 + minimo / 30),
        equipamento: equipamento,
        passo: passo,
        paraBaixo: true,
      ),
    );
  }

  final ultima = numero >= series && series > 1;
  if (ultima && prAtualKg != null && prAtualKg >= carga) {
    final mira = prAtualKg + incrementoCarga(prAtualKg, equipamento, passo);
    if (mira <= cargaBase * limiteMiraPr) {
      carga = mira;
      return (
        cargaKg: carga,
        reps: math.max(minimo, reps()),
        percentual: carga / cargaBase,
      );
    }
  }

  final ajustada =
      carga !=
      arredondarCarga(
        cargaBase * percentual,
        equipamento: equipamento,
        passo: passo,
      );
  return (
    cargaKg: carga,
    reps: reps(),
    percentual: ajustada ? carga / cargaBase : percentual,
  );
}

/// Os 5 níveis da pergunta "Como foi?", gravados como RIR (reps na reserva).
const escalaDificuldade = <({String rotulo, int rir})>[
  (rotulo: 'Mole', rir: 4),
  (rotulo: 'Fácil', rir: 3),
  (rotulo: 'Na medida', rir: 2),
  (rotulo: 'Difícil', rir: 1),
  (rotulo: 'No limite', rir: 0),
];

/// Rótulo do nível de dificuldade de um RIR gravado (4 ou mais = "Mole").
String rotuloDificuldade(int rir) =>
    escalaDificuldade.firstWhere((n) => n.rir == rir.clamp(0, 4)).rotulo;

/// A próxima série deve vir com um passo de carga a menos? Sim quando as
/// reps feitas ficaram 2 ou mais abaixo do mínimo da faixa, ou a dificuldade
/// foi "No limite" (RIR 0). Não vale na última série, que não tem próxima.
bool sugerirCargaMenor({
  required int repsFeitas,
  required int repsMin,
  required int? rir,
  required bool ultimaSerie,
}) {
  if (ultimaSerie) return false;
  return repsFeitas <= repsMin - 2 || rir == 0;
}

/// Como calcular a carga das séries normais depois de um PR aceito.
enum ModoNovoZero {
  /// Converte o PR pelo 1RM estimado (Epley) para as reps do plano.
  umRm('1rm'),

  /// Usa o peso do PR direto como carga do plano.
  direto('direto'),

  /// Mostra as duas opções na hora.
  perguntar('perguntar');

  const ModoNovoZero(this.valor);

  /// Como fica gravado no banco.
  final String valor;

  static ModoNovoZero de(String valor) =>
      values.firstWhere((m) => m.valor == valor, orElse: () => umRm);
}

/// O PR foi batido: a última série passou da carga planejada e do recorde
/// anterior, com pelo menos as reps da meta.
bool bateuPr({
  required double cargaFinal,
  required int repsFeitas,
  required int repsMeta,
  required double cargaBase,
  required double? prAnteriorKg,
}) {
  return cargaFinal > cargaBase &&
      (prAnteriorKg == null || cargaFinal > prAnteriorKg) &&
      repsFeitas >= repsMeta;
}

/// Carga para [repsPlano] reps com a força mostrada no PR ([carga] × [reps]),
/// arredondada para baixo ao peso disponível. Ex.: 80 × 5 → 72,5 kg × 8.
double novaBasePorUmRm({
  required double carga,
  required int reps,
  required int repsPlano,
  required String equipamento,
  required double passo,
}) {
  final umRm = carga * (1 + reps / 30);
  return arredondarCarga(
    umRm / (1 + repsPlano / 30),
    equipamento: equipamento,
    passo: passo,
    paraBaixo: true,
  );
}

/// 1RM estimado pela fórmula de Epley. Com 1 rep, a própria carga é o máximo.
double umRmEpley(double carga, int reps) =>
    reps <= 1 ? carga : carga * (1 + reps / 30);

/// Carga para começar um substituto que a pessoa nunca fez, a partir da carga
/// do exercício trocado. Um halter costuma levar ~40% da carga da barra; os
/// outros equipamentos ficam com a mesma carga. É só um ponto de partida: a
/// tela pede para conferir.
double cargaInicialSubstituto({
  required double cargaOriginal,
  required String equipamentoOriginal,
  required String equipamentoNovo,
  required double passoNovo,
}) {
  const porHalter = 0.4;
  var carga = cargaOriginal;
  if (equipamentoOriginal == 'barra' && equipamentoNovo == 'halteres') {
    carga = cargaOriginal * porHalter;
  } else if (equipamentoOriginal == 'halteres' && equipamentoNovo == 'barra') {
    carga = cargaOriginal / porHalter;
  }
  return arredondarCarga(carga, equipamento: equipamentoNovo, passo: passoNovo);
}

/// Plano da série extra de aquecimento: ~70% da carga, reps do mínimo da faixa.
PlanoDaSerie planoAquecimento({
  required double cargaBase,
  required int repsMin,
  required String equipamento,
  required double passo,
}) {
  return (
    cargaKg: arredondarCarga(
      cargaBase * percentualAquecimento,
      equipamento: equipamento,
      passo: passo,
    ),
    reps: repsMin,
    percentual: percentualAquecimento,
  );
}
