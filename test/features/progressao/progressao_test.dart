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
