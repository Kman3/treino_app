import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Escala de dificuldade "Como foi?": 5 níveis lado a lado. O valor é o RIR.
class EscalaRir extends StatelessWidget {
  const EscalaRir({
    super.key,
    required this.niveis,
    required this.selecionado,
    required this.aoEscolher,
    this.compacta = false,
  });

  final List<({String rotulo, int rir})> niveis;

  /// RIR escolhido, ou nulo se ainda não respondeu.
  final int? selecionado;
  final ValueChanged<int> aoEscolher;

  /// Barra baixa, para a tela de ajuste (02C).
  final bool compacta;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (i, nivel) in niveis.indexed) ...[
          if (i > 0) const SizedBox(width: Espacos.xs),
          Expanded(
            child: _Opcao(
              nivel: nivel,
              escolhida: nivel.rir == selecionado,
              compacta: compacta,
              aoEscolher: aoEscolher,
            ),
          ),
        ],
      ],
    );
  }
}

class _Opcao extends StatelessWidget {
  const _Opcao({
    required this.nivel,
    required this.escolhida,
    required this.compacta,
    required this.aoEscolher,
  });

  final ({String rotulo, int rir}) nivel;
  final bool escolhida;
  final bool compacta;
  final ValueChanged<int> aoEscolher;

  @override
  Widget build(BuildContext context) {
    final forma = BorderRadius.circular(Raios.botao);
    return Semantics(
      button: true,
      selected: escolhida,
      label: nivel.rotulo,
      excludeSemantics: true,
      child: Material(
        color: escolhida ? Cores.brasa : Cores.ferro700,
        borderRadius: forma,
        child: InkWell(
          borderRadius: forma,
          onTap: () => aoEscolher(nivel.rir),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: compacta ? 48 : 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    nivel.rotulo,
                    textAlign: TextAlign.center,
                    style: Textos.secundario.copyWith(
                      color: escolhida ? Cores.ferro900 : Cores.giz,
                      fontWeight: escolhida ? FontWeight.w700 : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
