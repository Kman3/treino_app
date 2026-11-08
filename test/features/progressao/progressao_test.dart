import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/features/progressao/progressao.dart';

void main() {
  group('percentuaisPr', () {
    test('4 séries: 50% → 80% → 100% → 120%', () {
      expect(percentuaisPr(4), [0.50, 0.80, 1.00, 1.20]);
    });

    test('sempre sobe, termina em 120% e passa pelos 100%', () {
      for (var series = 2; series <= 8; series++) {
        final p = percentuaisPr(series);
        expect(p, hasLength(series), reason: '$series séries');
        expect(p.last, 1.20);
        // Com 2 séries a escada é 80% → 120%; a partir de 3, a penúltima é 100%.
        if (series >= 3) expect(p[series - 2], closeTo(1.0, 1e-9));
        for (var i = 1; i < p.length; i++) {
          expect(p[i], greaterThan(p[i - 1]), reason: '$series séries');
        }
      }
    });
  });

  group('arredondarCarga', () {
    test('barra: múltiplos de 2,5 kg (par de anilhas de 1,25)', () {
      expect(arredondarCarga(48, equipamento: 'barra', passo: 2.5), 47.5);
      expect(arredondarCarga(72, equipamento: 'barra', passo: 2.5), 72.5);
      expect(arredondarCarga(30, equipamento: 'barra', passo: 2.5), 30);
    });

    test('halteres: 1 em 1 kg até 10, depois 2 em 2 kg', () {
      expect(arredondarCarga(5.6, equipamento: 'halteres', passo: 1), 6);
      expect(arredondarCarga(17.6, equipamento: 'halteres', passo: 1), 18);
      expect(arredondarCarga(26.4, equipamento: 'halteres', passo: 1), 26);
    });

    test('máquina: placas de 5 kg', () {
      expect(arredondarCarga(36, equipamento: 'maquina', passo: 5), 35);
      expect(arredondarCarga(54, equipamento: 'maquina', passo: 5), 55);
    });

    test('nunca devolve menos que um incremento', () {
      expect(arredondarCarga(0.4, equipamento: 'barra', passo: 2.5), 2.5);
    });
  });

  group('repsEquivalentes (Epley)', () {
    test('carga igual ou menor mantém as reps', () {
      expect(repsEquivalentes(cargaBase: 60, repsBase: 10, carga: 60), 10);
      expect(repsEquivalentes(cargaBase: 60, repsBase: 10, carga: 30), 10);
    });

    test('60 kg × 10 equivale a cerca de 3 reps com 72,5 kg', () {
      expect(repsEquivalentes(cargaBase: 60, repsBase: 10, carga: 72.5), 3);
    });

    test('nunca menos que 1', () {
      expect(repsEquivalentes(cargaBase: 60, repsBase: 3, carga: 100), 1);
    });
  });

  test('escada do PR no supino de 60 kg × 10, 4 séries', () {
    final planos = [
      for (var n = 1; n <= 4; n++)
        planoPr(
          cargaBase: 60,
          repsBase: 10,
          series: 4,
          numero: n,
          equipamento: 'barra',
          passo: 2.5,
        ),
    ];

    expect(planos.map((p) => p.cargaKg), [30, 47.5, 60, 72.5]);
    expect(planos.map((p) => p.reps), [10, 10, 10, 3]);
  });

  test('a última série nunca pede menos de 3 reps', () {
    // Agachamento 70 kg × 8: 120% seria 85 kg × 1; desce para 80 kg × 3.
    final planos = [
      for (var n = 1; n <= 4; n++)
        planoPr(
          cargaBase: 70,
          repsBase: 8,
          series: 4,
          numero: n,
          equipamento: 'barra',
          passo: 2.5,
        ),
    ];

    expect(planos.map((p) => p.cargaKg), [35, 55, 70, 80]);
    expect(planos.map((p) => p.reps), [8, 8, 8, 3]);
    expect(planos.last.percentual, closeTo(80 / 70, 1e-9));
  });

  test('com plano de poucas reps, a última série não fica abaixo do plano', () {
    final ultima = planoPr(
      cargaBase: 100,
      repsBase: 2,
      series: 4,
      numero: 4,
      equipamento: 'barra',
      passo: 2.5,
    );
    expect(ultima.cargaKg, greaterThanOrEqualTo(100));
    expect(ultima.reps, greaterThanOrEqualTo(1));
  });

  test('arredondar para baixo pega o peso disponível abaixo', () {
    expect(
      arredondarCarga(80.6, equipamento: 'barra', passo: 2.5, paraBaixo: true),
      80,
    );
    expect(
      arredondarCarga(80, equipamento: 'barra', passo: 2.5, paraBaixo: true),
      80,
    );
  });

  group('sugerirCargaMenor', () {
    test('2 ou mais reps abaixo do mínimo', () {
      expect(
        sugerirCargaMenor(
          repsFeitas: 4,
          repsMin: 6,
          rir: null,
          ultimaSerie: false,
        ),
        isTrue,
      );
      expect(
        sugerirCargaMenor(
          repsFeitas: 5,
          repsMin: 6,
          rir: 2,
          ultimaSerie: false,
        ),
        isFalse,
      );
    });

    test('"No limite" (RIR 0), mas não na última série', () {
      expect(
        sugerirCargaMenor(
          repsFeitas: 10,
          repsMin: 6,
          rir: 0,
          ultimaSerie: false,
        ),
        isTrue,
      );
      expect(
        sugerirCargaMenor(repsFeitas: 2, repsMin: 6, rir: 0, ultimaSerie: true),
        isFalse,
      );
    });
  });

  test('escala de dificuldade grava RIR 4 → 0', () {
    expect(escalaDificuldade.map((n) => n.rir), [4, 3, 2, 1, 0]);
    expect(rotuloDificuldade(2), 'Na medida');
    expect(rotuloDificuldade(6), 'Mole');
  });

  group('PR', () {
    test('bater = acima do plano e do PR anterior, com as reps da meta', () {
      bool bateu(double carga, int reps, double? pr) => bateuPr(
        cargaFinal: carga,
        repsFeitas: reps,
        repsMeta: 3,
        cargaBase: 60,
        prAnteriorKg: pr,
      );
      expect(bateu(72.5, 3, null), isTrue);
      expect(bateu(72.5, 3, 75), isFalse);
      expect(bateu(77.5, 3, 75), isTrue);
      expect(bateu(77.5, 2, 75), isFalse);
      expect(bateu(60, 10, null), isFalse);
    });

    test('novo zero pelo 1RM: 80 × 5 vira 72,5 × 8 na barra', () {
      expect(
        novaBasePorUmRm(
          carga: 80,
          reps: 5,
          repsPlano: 8,
          equipamento: 'barra',
          passo: 2.5,
        ),
        72.5,
      );
    });

    test('80 × 3 equivale a ~70 × 8: a base não sobe', () {
      // 80 × 3 → 1RM 88 kg; para 8 reps, 69,5 kg → 67,5 kg disponível.
      expect(
        novaBasePorUmRm(
          carga: 80,
          reps: 3,
          repsPlano: 8,
          equipamento: 'barra',
          passo: 2.5,
        ),
        lessThanOrEqualTo(70),
      );
    });

    test('a escada mira o PR + 1 passo na última série', () {
      final ultima = planoPr(
        cargaBase: 60,
        repsBase: 10,
        series: 4,
        numero: 4,
        equipamento: 'barra',
        passo: 2.5,
        prAtualKg: 75,
      );
      expect(ultima.cargaKg, 77.5);
      expect(ultima.reps, 3);
    });

    test('PR abaixo da escada não muda nada', () {
      final ultima = planoPr(
        cargaBase: 60,
        repsBase: 10,
        series: 4,
        numero: 4,
        equipamento: 'barra',
        passo: 2.5,
        prAtualKg: 65,
      );
      expect(ultima.cargaKg, 72.5);
    });
  });

  group('1RM e substitutos', () {
    test('Epley: 100 kg × 10 ≈ 133 kg; 1 rep é a própria carga', () {
      expect(umRmEpley(100, 10), closeTo(133.33, 0.01));
      expect(umRmEpley(80, 1), 80);
    });

    test('halter começa com ~40% da barra, arredondado', () {
      expect(
        cargaInicialSubstituto(
          cargaOriginal: 60,
          equipamentoOriginal: 'barra',
          equipamentoNovo: 'halteres',
          passoNovo: 1,
        ),
        24,
      );
      expect(
        cargaInicialSubstituto(
          cargaOriginal: 60,
          equipamentoOriginal: 'barra',
          equipamentoNovo: 'maquina',
          passoNovo: 5,
        ),
        60,
      );
    });
  });

  test('aquecimento: ~70% da carga, reps do mínimo da faixa', () {
    final plano = planoAquecimento(
      cargaBase: 60,
      repsMin: 6,
      equipamento: 'barra',
      passo: 2.5,
    );
    expect(plano.cargaKg, 42.5);
    expect(plano.reps, 6);
    expect(plano.percentual, 0.70);
  });
}
