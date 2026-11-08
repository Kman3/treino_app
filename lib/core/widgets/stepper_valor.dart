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
                      // Número e unidade encolhem juntos: um FittedBox só no
                      // número perde a linha de base e joga o "KG" para baixo.
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                formatarKg(valor),
                                style: Textos.numeroLista.copyWith(
                                  fontSize: 44,
                                  color: cor,
                                ),
                              ),
                              if (unidade.isNotEmpty) ...[
                                const SizedBox(width: 2),
                                Text(
                                  unidade.toUpperCase(),
                                  style: Textos.rotulo,
                                ),
                              ],
                            ],
                          ),
                        ),
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
    final novo = await showDialog<double>(
      context: context,
      builder: (_) => _DialogoNumero(
        titulo: rotulo,
        inicial: formatarKg(valor),
        unidade: unidade,
        decimais: decimais,
      ),
    );
    if (novo != null && novo >= minimo) {
      aoMudar(decimais ? _arredondar(novo) : novo.roundToDouble());
    }
  }
}

/// Teclado numérico do [StepperValor].
///
/// O controlador do texto vive e morre com o diálogo. Descartá-lo assim que o
/// diálogo devolve o valor derruba o app no celular: enquanto o diálogo fecha,
/// o teclado do aparelho ainda atualiza o texto do campo.
class _DialogoNumero extends StatefulWidget {
  const _DialogoNumero({
    required this.titulo,
    required this.inicial,
    required this.unidade,
    required this.decimais,
  });

  final String titulo;
  final String inicial;
  final String unidade;
  final bool decimais;

  @override
  State<_DialogoNumero> createState() => _DialogoNumeroState();
}

class _DialogoNumeroState extends State<_DialogoNumero> {
  late final _controle = TextEditingController(text: widget.inicial);

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  void _confirmar() => Navigator.pop(context, lerNumero(_controle.text));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Cores.ferro800,
      title: Text(widget.titulo, style: Textos.nome),
      content: TextField(
        controller: _controle,
        autofocus: true,
        keyboardType: TextInputType.numberWithOptions(decimal: widget.decimais),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(widget.decimais ? r'[0-9.,]' : r'[0-9]'),
          ),
        ],
        style: Textos.numeroLista,
        decoration: InputDecoration(suffixText: widget.unidade),
        onSubmitted: (_) => _confirmar(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(onPressed: _confirmar, child: const Text('OK')),
      ],
    );
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
