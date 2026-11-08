import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/db/repositorios/plano_repository.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/botao_brasa.dart';
import '../../core/widgets/stepper_valor.dart';
import 'estado_execucao.dart';

/// Carga e reps (ou segundos) que serão gravados na série.
typedef ValoresSerie = ({double? cargaKg, int reps});

/// O que a pessoa decidiu ao corrigir uma série já registrada.
sealed class ResultadoCorrecao {
  const ResultadoCorrecao();
}

final class SalvarCorrecao extends ResultadoCorrecao {
  const SalvarCorrecao(this.valores);

  final ValoresSerie valores;
}

final class ExcluirSerie extends ResultadoCorrecao {
  const ExcluirSerie();
}

/// Painel "✎ Alterar" da tela 02A, para a série que ainda vai ser registrada.
/// Devolve os valores escolhidos, ou nulo se a pessoa fechar sem confirmar.
Future<ValoresSerie?> abrirPainelAlterar(
  BuildContext context, {
  required PosicaoSerie posicao,
  required ValoresSerie atuais,
}) async {
  final resultado = await _abrir(
    context,
    exercicio: posicao.item.exercicio,
    numero: posicao.numero,
    cargaPlanKg: posicao.cargaPlanKg,
    repsPlan: posicao.repsPlan,
    atuais: atuais,
    corrigindo: false,
  );
  return resultado is SalvarCorrecao ? resultado.valores : null;
}

/// Mesmo painel, para corrigir ou excluir uma série já registrada.
Future<ResultadoCorrecao?> abrirPainelCorrigir(
  BuildContext context, {
  required ItemComExercicio item,
  required Serie serie,
}) {
  final repsPlan = serie.repsPlan ?? item.item.repsMax;
  return _abrir(
    context,
    exercicio: item.exercicio,
    numero: serie.numero,
    cargaPlanKg: serie.cargaPlanKg,
    repsPlan: repsPlan,
    atuais: (cargaKg: serie.cargaKg, reps: serie.reps ?? repsPlan),
    corrigindo: true,
  );
}

Future<ResultadoCorrecao?> _abrir(
  BuildContext context, {
  required Exercicio exercicio,
  required int numero,
  required double? cargaPlanKg,
  required int repsPlan,
  required ValoresSerie atuais,
  required bool corrigindo,
}) {
  return showModalBottomSheet<ResultadoCorrecao>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Cores.ferro800,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Raios.painel)),
    ),
    builder: (_) => _PainelAlterar(
      exercicio: exercicio,
      numero: numero,
      cargaPlanKg: cargaPlanKg,
      repsPlan: repsPlan,
      atuais: atuais,
      corrigindo: corrigindo,
    ),
  );
}

class _PainelAlterar extends StatefulWidget {
  const _PainelAlterar({
    required this.exercicio,
    required this.numero,
    required this.cargaPlanKg,
    required this.repsPlan,
    required this.atuais,
    required this.corrigindo,
  });

  final Exercicio exercicio;
  final int numero;
  final double? cargaPlanKg;
  final int repsPlan;
  final ValoresSerie atuais;

  /// Verdadeiro para uma série já registrada: o botão vira "Salvar" e aparece
  /// a opção de excluir.
  final bool corrigindo;

  @override
  State<_PainelAlterar> createState() => _PainelAlterarState();
}

class _PainelAlterarState extends State<_PainelAlterar> {
  late double _carga = widget.atuais.cargaKg ?? 0;
  late double _reps = widget.atuais.reps.toDouble();

  @override
  Widget build(BuildContext context) {
    final exercicio = widget.exercicio;
    final tipo = exercicio.tipoCarga;
    final passoCarga = exercicio.passoCargaKg > 0
        ? exercicio.passoCargaKg
        : 2.5;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Espacos.l,
          Espacos.l,
          Espacos.l,
          Espacos.l + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${widget.corrigindo ? 'CORRIGIR' : 'ALTERAR'} '
              '${widget.numero == 0 ? 'AQUECIMENTO' : 'SÉRIE ${widget.numero}'}',
              style: Textos.rotulo,
            ),
            const SizedBox(height: Espacos.xs),
            Text(exercicio.nome, style: Textos.nome),
            const SizedBox(height: Espacos.l),
            Row(
              children: [
                if (tipo != TipoCarga.tempo) ...[
                  Expanded(
                    child: StepperValor(
                      rotulo: tipo == TipoCarga.corporal
                          ? 'Carga extra'
                          : 'Carga',
                      unidade: 'kg',
                      valor: _carga,
                      passo: passoCarga,
                      planejado:
                          widget.cargaPlanKg ??
                          (tipo == TipoCarga.corporal ? 0 : null),
                      aoMudar: (v) => setState(() => _carga = v),
                    ),
                  ),
                  const SizedBox(width: Espacos.s),
                ],
                Expanded(
                  child: StepperValor(
                    rotulo: tipo == TipoCarga.tempo ? 'Tempo' : 'Reps',
                    unidade: tipo == TipoCarga.tempo ? 's' : '',
                    valor: _reps,
                    passo: tipo == TipoCarga.tempo ? 5 : 1,
                    minimo: 1,
                    decimais: false,
                    planejado: widget.repsPlan.toDouble(),
                    aoMudar: (v) => setState(() => _reps = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Espacos.l),
            BotaoBrasa(
              rotulo: widget.corrigindo ? 'Salvar' : 'Pronto',
              onPressed: () => Navigator.pop<ResultadoCorrecao>(
                context,
                SalvarCorrecao((
                  cargaKg:
                      tipo == TipoCarga.tempo ||
                          (tipo == TipoCarga.corporal && _carga == 0)
                      ? null
                      : _carga,
                  reps: _reps.round(),
                )),
              ),
            ),
            if (widget.corrigindo) ...[
              const SizedBox(height: Espacos.s),
              SizedBox(
                height: 48,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop<ResultadoCorrecao>(
                    context,
                    const ExcluirSerie(),
                  ),
                  style: TextButton.styleFrom(foregroundColor: Cores.dor),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Excluir série', style: Textos.botao),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
