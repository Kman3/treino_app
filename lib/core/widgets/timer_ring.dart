import 'dart:async';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Bate cada vez que o tempo restante até [fim] cruza um segundo inteiro.
///
/// Todos os relógios do mesmo descanso (o anel da 02B e a pílula da 02C)
/// batem no mesmo instante e mostram o mesmo número, e o fim do descanso é
/// percebido na hora certa. Sem [fim], ou depois dele, bate a cada segundo.
class TiqueDoDescanso {
  TiqueDoDescanso({required this.fim, required this.aoBater}) {
    _agendar();
  }

  /// Lido a cada batida: ±15 s mudam o fim sem recriar o tique.
  final DateTime? Function() fim;
  final VoidCallback aoBater;

  Timer? _timer;
  bool _parado = false;

  void _agendar() {
    if (_parado) return;
    final alvo = fim();
    var espera = 1000;
    if (alvo != null) {
      final ms = alvo.difference(clock.now()).inMilliseconds;
      if (ms > 0 && ms % 1000 != 0) espera = ms % 1000;
    }
    // 1 ms depois da virada, para o arredondamento já mostrar o novo número.
    _timer = Timer(Duration(milliseconds: espera + 1), () {
      if (_parado) return;
      aoBater();
      _agendar();
    });
  }

  void parar() {
    _parado = true;
    _timer?.cancel();
  }
}

/// "1:05" para 65 s. Arredonda para cima, como toda contagem regressiva:
/// com 149,9 s restantes ainda mostra 2:30, e só mostra 0:00 no fim.
String formatarRelogio(Duration d) {
  final ms = d.inMilliseconds < 0 ? 0 : d.inMilliseconds;
  final total = (ms / 1000).ceil();
  return '${total ~/ 60}:${(total % 60).toString().padLeft(2, '0')}';
}

/// Timer do descanso: anel grande (02B) ou pílula compacta (02C).
class TimerRing extends StatelessWidget {
  const TimerRing({
    super.key,
    required this.restante,
    required this.total,
    this.compacto = false,
  });

  final Duration restante;
  final Duration total;
  final bool compacto;

  double get _fracao => total.inMilliseconds <= 0
      ? 0
      : (restante.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final texto = formatarRelogio(restante);
    final rotulo = 'Descanso: $texto restantes';

    if (compacto) {
      return Semantics(
        label: rotulo,
        excludeSemantics: true,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Espacos.m,
            vertical: Espacos.xs,
          ),
          decoration: BoxDecoration(
            color: Cores.ferro900,
            borderRadius: BorderRadius.circular(Raios.botao),
            border: Border.all(color: Cores.brasa),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined, size: 16, color: Cores.brasa),
              const SizedBox(width: Espacos.xs),
              Text(texto, style: Textos.numeroLista.copyWith(fontSize: 20)),
            ],
          ),
        ),
      );
    }

    return Semantics(
      label: rotulo,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: 220,
        child: CustomPaint(
          painter: _Anel(_fracao),
          child: Center(child: Text(texto, style: Textos.numeroTimer)),
        ),
      ),
    );
  }
}

class _Anel extends CustomPainter {
  _Anel(this.fracao);

  final double fracao;

  @override
  void paint(Canvas canvas, Size size) {
    const espessura = 10.0;
    final centro = size.center(Offset.zero);
    final raio = size.shortestSide / 2 - espessura / 2;
    final retangulo = Rect.fromCircle(center: centro, radius: raio);

    canvas.drawCircle(
      centro,
      raio,
      Paint()
        ..color = Cores.ferro700
        ..style = PaintingStyle.stroke
        ..strokeWidth = espessura,
    );
    canvas.drawArc(
      retangulo,
      -math.pi / 2,
      2 * math.pi * fracao,
      false,
      Paint()
        ..color = Cores.brasa
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = espessura,
    );
  }

  @override
  bool shouldRepaint(_Anel antigo) => antigo.fracao != fracao;
}
