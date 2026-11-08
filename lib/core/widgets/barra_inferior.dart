import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'icone_caramelo.dart';

/// Barra inferior: Treino, Dieta (desabilitada na fase 1), Evolução e Perfil.
///
/// [indiceAtual] e [aoSelecionar] usam o índice das abas navegáveis
/// (0 = Treino, 1 = Evolução, 2 = Perfil); a Dieta não tem índice.
class BarraInferior extends StatelessWidget {
  const BarraInferior({
    super.key,
    required this.indiceAtual,
    required this.aoSelecionar,
  });

  final int indiceAtual;
  final ValueChanged<int> aoSelecionar;

  static const _itens = [
    _Item(Icons.fitness_center, 'Treino', indice: 0),
    _Item(Icons.restaurant_outlined, 'Dieta'),
    _Item(Icons.show_chart, 'Evolução', indice: 1),
    // O Perfil usa o ícone do app: o Caramelo é o "avatar" de quem treina.
    _Item(null, 'Perfil', indice: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Cores.ferro800,
        border: Border(top: BorderSide(color: Cores.ferro700)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (final item in _itens)
              Expanded(
                child: _BotaoItem(
                  item: item,
                  ativo: item.indice == indiceAtual,
                  aoTocar: item.indice == null
                      ? null
                      : () => aoSelecionar(item.indice!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Item {
  const _Item(this.icone, this.rotulo, {this.indice});

  /// Nulo = o ícone do app ([IconeCaramelo]).
  final IconData? icone;
  final String rotulo;
  final int? indice;
}

class _BotaoItem extends StatelessWidget {
  const _BotaoItem({required this.item, required this.ativo, this.aoTocar});

  final _Item item;
  final bool ativo;
  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    final habilitado = aoTocar != null;
    final cor = ativo ? Cores.brasa : Cores.ferro400;

    return Semantics(
      button: true,
      enabled: habilitado,
      selected: ativo,
      label: habilitado ? item.rotulo : '${item.rotulo}, em breve',
      excludeSemantics: true,
      child: InkWell(
        onTap: aoTocar,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Opacity(
            opacity: habilitado ? 1 : 0.45,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (item.icone case final icone?)
                  Icon(icone, color: cor, size: 24)
                else
                  // Colorido, o ícone do app fica apagado fora da aba ativa.
                  Opacity(
                    opacity: ativo ? 1 : 0.55,
                    child: const IconeCaramelo(tamanho: 24),
                  ),
                const SizedBox(height: Espacos.xs),
                Text(
                  habilitado ? item.rotulo.toUpperCase() : 'EM BREVE',
                  style: Textos.rotulo.copyWith(color: cor, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
