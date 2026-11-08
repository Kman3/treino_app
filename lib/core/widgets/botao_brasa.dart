import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum VarianteBotao { primario, secundario }

/// Botão de ação com altura de 50 px. Cada tela tem no máximo um primário.
///
/// Sem [onPressed] o botão fica desabilitado. Com [carregando] ele mantém a
/// aparência ativa, mostra um indicador e ignora toques.
class BotaoBrasa extends StatelessWidget {
  const BotaoBrasa({
    super.key,
    required this.rotulo,
    this.onPressed,
    this.variante = VarianteBotao.primario,
    this.carregando = false,
  });

  final String rotulo;
  final VoidCallback? onPressed;
  final VarianteBotao variante;
  final bool carregando;

  static const _altura = 50.0;
  static const _forma = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(Raios.botao)),
  );

  @override
  Widget build(BuildContext context) {
    final primario = variante == VarianteBotao.primario;
    final acao = carregando ? () {} : onPressed;

    final conteudo = carregando
        ? SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: primario ? Cores.ferro900 : Cores.giz,
            ),
          )
        : Text(rotulo);

    final botao = primario
        ? FilledButton(
            onPressed: acao,
            style: FilledButton.styleFrom(
              backgroundColor: Cores.brasa,
              foregroundColor: Cores.ferro900,
              disabledBackgroundColor: Cores.ferro700,
              disabledForegroundColor: Cores.ferro400,
              textStyle: Textos.botao,
              shape: _forma,
            ),
            child: conteudo,
          )
        : OutlinedButton(
            onPressed: acao,
            style: OutlinedButton.styleFrom(
              foregroundColor: Cores.giz,
              disabledForegroundColor: Cores.ferro400,
              side: const BorderSide(color: Cores.ferro400),
              textStyle: Textos.botao,
              shape: _forma,
            ),
            child: conteudo,
          );

    return Semantics(
      label: carregando ? '$rotulo, carregando' : null,
      child: SizedBox(height: _altura, width: double.infinity, child: botao),
    );
  }
}
