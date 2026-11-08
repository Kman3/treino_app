import 'package:flutter/material.dart';

import '../marca.dart';

/// O ícone do app (cão caramelo sobre Ferro 900), com os cantos de 22% do
/// ícone. Sem [rotuloAcessivel], é decorativo e o leitor de tela o ignora.
class IconeCaramelo extends StatelessWidget {
  const IconeCaramelo({super.key, required this.tamanho, this.rotuloAcessivel});

  final double tamanho;
  final String? rotuloAcessivel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(tamanho * 0.22),
      child: Image.asset(
        Marca.icone,
        width: tamanho,
        height: tamanho,
        filterQuality: FilterQuality.medium,
        semanticLabel: rotuloAcessivel,
        excludeFromSemantics: rotuloAcessivel == null,
      ),
    );
  }
}
