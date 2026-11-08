import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/core/widgets/timer_ring.dart';

void main() {
  test('relógio arredonda para cima', () {
    expect(formatarRelogio(const Duration(milliseconds: 149900)), '2:30');
    expect(formatarRelogio(const Duration(seconds: 65)), '1:05');
    expect(formatarRelogio(const Duration(milliseconds: -300)), '0:00');
  });

  testWidgets('o tique bate na virada de cada segundo do descanso', (
    tester,
  ) async {
    final inicio = clock.now();
    final fim = inicio.add(const Duration(milliseconds: 2500));
    final batidas = <int>[];
    final tique = TiqueDoDescanso(
      fim: () => fim,
      aoBater: () =>
          batidas.add(clock.now().difference(inicio).inMilliseconds),
    );

    await tester.pump(const Duration(milliseconds: 3600));
    tique.parar();

    // 2,5 s → viradas em 2, 1 e 0 s restantes; depois do fim, a cada ~1 s.
    expect(batidas, [501, 1501, 2501, 3502]);
  });

  testWidgets('dois tiques do mesmo descanso batem juntos', (tester) async {
    final fim = clock.now().add(const Duration(milliseconds: 9300));
    final a = <String>[];
    final b = <String>[];
    String agora() => formatarRelogio(fim.difference(clock.now()));

    final primeiro = TiqueDoDescanso(fim: () => fim, aoBater: () => a.add(agora()));
    await tester.pump(const Duration(milliseconds: 700));
    // O segundo nasce 0,7 s depois, como o painel Ajustar aberto no meio.
    final segundo = TiqueDoDescanso(fim: () => fim, aoBater: () => b.add(agora()));
    await tester.pump(const Duration(seconds: 3));
    primeiro.parar();
    segundo.parar();

    expect(a, ['0:09', '0:08', '0:07', '0:06']);
    expect(b, ['0:08', '0:07', '0:06']);
  });
}
