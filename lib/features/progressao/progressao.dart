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
  final double incremento;
  if (equipamento == 'halteres') {
    incremento = kg <= 10 ? 1 : 2;
  } else {
    incremento = passo > 0 ? passo : 2.5;
  }
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

/// Plano da série [numero] (de 1 a [series]) no modo PR.
///
/// Se a carga da escada deixaria menos de [repsMinimasPr] reps, ela desce
/// para o maior peso disponível que ainda dá essas reps (nunca abaixo da
/// carga planejada). Ex.: agachamento 70 kg × 8 → 80 kg × 3 em vez de 85 × 1.
PlanoDaSerie planoPr({
  required double cargaBase,
  required int repsBase,
  required int series,
  required int numero,
  required String equipamento,
  required double passo,
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
  if (reps() >= minimo) {
    return (cargaKg: carga, reps: reps(), percentual: percentual);
  }

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
  return (cargaKg: carga, reps: reps(), percentual: carga / cargaBase);
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
