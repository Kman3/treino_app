import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../formatacao.dart';
import '../theme/tokens.dart';

/// Valor com botões −/+ e teclado numérico ao tocar no número.
///
/// Quando [valor] difere de [planejado], o número e a borda ficam em
/// `atencao` e a diferença aparece abaixo.
class StepperValor extends StatelessWidget {
  const StepperValor({
    super.key,
    required this.rotulo,
    required this.unidade,
    required this.valor,
    required this.passo,
    required this.aoMudar,
    this.planejado,
    this.minimo = 0,
    this.decimais = true,
  });

  final String rotulo;
  final String unidade;
  final double valor;
  final double passo;
  final ValueChanged<double> aoMudar;
  final double? planejado;
  final double minimo;

  /// Falso para reps e segundos, que são inteiros.
  final bool decimais;

  bool get _editado => planejado != null && valor != planejado;

  @override
  Widget build(BuildContext context) {
    final cor = _editado ? Cores.atencao : Cores.giz;
    final noMinimo = valor - passo < minimo;

    return Container(
      padding: const EdgeInsets.all(Espacos.m),
      decoration: BoxDecoration(
        color: Cores.ferro800,
        borderRadius: BorderRadius.circular(Raios.cartao),
        border: Border.all(color: _editado ? Cores.atencao : Cores.ferro700),
      ),
      child: Column(
        children: [
          Text(rotulo.toUpperCase(), style: Textos.rotulo),
          const SizedBox(height: Espacos.s),
          Row(
            children: [
              _BotaoPasso(
                icone: Icons.remove,
                rotulo: 'Diminuir $rotulo',
                aoTocar: noMinimo
                    ? null
                    : () => aoMudar(_arredondar(valor - passo)),
              ),
              Expanded(
                child: Semantics(
                  button: true,
                  label:
                      '$rotulo: ${formatarKg(valor)} $unidade. Toque para digitar',
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: () => _digitar(context),
                    borderRadius: BorderRadius.circular(Raios.botao),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Espacos.xs),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            child: FittedBox(
                              child: Text(
                                formatarKg(valor),
                                style: Textos.numeroLista.copyWith(
                                  fontSize: 44,
                                  color: cor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(unidade.toUpperCase(), style: Textos.rotulo),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _BotaoPasso(
                icone: Icons.add,
                rotulo: 'Aumentar $rotulo',
                aoTocar: () => aoMudar(_arredondar(valor + passo)),
              ),
            ],
          ),
          SizedBox(
            height: 18,
            child: _editado
                ? Text(
                    '${formatarDiferenca(valor - planejado!)} vs. plano',
                    style: Textos.rotulo.copyWith(color: Cores.atencao),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  double _arredondar(double v) => double.parse(v.toStringAsFixed(2));

  Future<void> _digitar(BuildContext context) async {
    final controle = TextEditingController(text: formatarKg(valor));
    final novo = await showDialog<double>(
      context: context,
      builder: (context) {
        void confirmar() => Navigator.pop(context, lerNumero(controle.text));
        return AlertDialog(
          backgroundColor: Cores.ferro800,
          title: Text(rotulo, style: Textos.nome),
          content: TextField(
            controller: controle,
            autofocus: true,
            keyboardType: TextInputType.numberWithOptions(decimal: decimais),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(decimais ? r'[0-9.,]' : r'[0-9]'),
              ),
            ],
            style: Textos.numeroLista,
            decoration: InputDecoration(suffixText: unidade),
            onSubmitted: (_) => confirmar(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(onPressed: confirmar, child: const Text('OK')),
          ],
        );
      },
    );
    controle.dispose();
    if (novo != null && novo >= minimo) {
      aoMudar(decimais ? _arredondar(novo) : novo.roundToDouble());
    }
  }
}

class _BotaoPasso extends StatelessWidget {
  const _BotaoPasso({required this.icone, required this.rotulo, this.aoTocar});

  final IconData icone;
  final String rotulo;
  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: aoTocar,
      tooltip: rotulo,
      iconSize: 24,
      constraints: const BoxConstraints.tightFor(width: 52, height: 52),
      style: IconButton.styleFrom(
        backgroundColor: Cores.ferro700,
        foregroundColor: Cores.giz,
        disabledBackgroundColor: Cores.ferro800,
        disabledForegroundColor: Cores.ferro700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Raios.botao),
        ),
      ),
      icon: Icon(icone),
    );
  }
}
