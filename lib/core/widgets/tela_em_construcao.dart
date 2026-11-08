import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Ocupa as abas que ainda não foram implementadas.
class TelaEmConstrucao extends StatelessWidget {
  const TelaEmConstrucao({
    super.key,
    required this.titulo,
    required this.etapa,
  });

  final String titulo;
  final String etapa;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Espacos.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Textos.titulo),
            const SizedBox(height: Espacos.s),
            Text('Chega na $etapa.', style: Textos.secundario),
          ],
        ),
      ),
    );
  }
}
