import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/db/repositorios/plano_repository.dart';
import '../../core/formatacao.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/botao_brasa.dart';
import '../../core/widgets/escala_rir.dart';
import '../../core/widgets/stepper_valor.dart';
import '../../core/widgets/timer_ring.dart';
import '../progressao/progressao.dart';

/// O que a tela 02C devolve ao salvar.
typedef AjusteDaSerie = ({
  double? cargaKg,
  int reps,
  int? rir,
  bool manterCarga,
});

/// Tela 02C Ajustar, aberta do descanso: corrige carga e reps da série que
/// acabou de ser registrada, com a dificuldade e o timer compacto no topo.
Future<AjusteDaSerie?> abrirPainelAjustar(
  BuildContext context, {
  required ItemComExercicio item,
  required Serie serie,
  required DateTime descansoTerminaEm,
  required Duration descansoTotal,
  required bool sugestaoLigada,
}) {
  return showModalBottomSheet<AjusteDaSerie>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Cores.ferro800,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Raios.painel)),
    ),
    builder: (_) => _PainelAjustar(
      item: item,
      serie: serie,
      descansoTerminaEm: descansoTerminaEm,
      descansoTotal: descansoTotal,
      sugestaoLigada: sugestaoLigada,
    ),
  );
}

class _PainelAjustar extends StatefulWidget {
  const _PainelAjustar({
    required this.item,
    required this.serie,
    required this.descansoTerminaEm,
    required this.descansoTotal,
    required this.sugestaoLigada,
  });

  final ItemComExercicio item;
  final Serie serie;
  final DateTime descansoTerminaEm;
  final Duration descansoTotal;
  final bool sugestaoLigada;

  @override
  State<_PainelAjustar> createState() => _PainelAjustarState();
}

class _PainelAjustarState extends State<_PainelAjustar> {
  late double _carga = widget.serie.cargaKg ?? 0;
  late double _reps = (widget.serie.reps ?? widget.item.item.repsMax)
      .toDouble();
  late int? _rir = widget.serie.rir;
  late bool _manter = widget.serie.manterCarga;

  /// Bate junto com o anel da 02B, para os dois mostrarem o mesmo tempo.
  late final TiqueDoDescanso _relogio;

  @override
  void initState() {
    super.initState();
    _relogio = TiqueDoDescanso(
      fim: () => widget.descansoTerminaEm,
      aoBater: () {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _relogio.parar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercicio = widget.item.exercicio;
    final tipo = exercicio.tipoCarga;
    final serie = widget.serie;
    final ultima = serie.numero >= widget.item.item.series;
    final sugere =
        widget.sugestaoLigada &&
        !serie.aquecimento &&
        tipo == TipoCarga.externa &&
        sugerirCargaMenor(
          repsFeitas: _reps.round(),
          repsMin: widget.item.item.repsMin,
          rir: _rir,
          ultimaSerie: ultima,
        );
    final cargaSugerida = arredondarCarga(
      _carga -
          incrementoCarga(
            _carga,
            exercicio.equipamento,
            exercicio.passoCargaKg,
          ),
      equipamento: exercicio.equipamento,
      passo: exercicio.passoCargaKg,
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Espacos.l,
          Espacos.l,
          Espacos.l,
          Espacos.l + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      serie.aquecimento
                          ? 'AJUSTAR AQUECIMENTO'
                          : 'AJUSTAR SÉRIE ${serie.numero}',
                      style: Textos.rotulo,
                    ),
                  ),
                  TimerRing(
                    restante: widget.descansoTerminaEm.difference(clock.now()),
                    total: widget.descansoTotal,
                    compacto: true,
                  ),
                ],
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
                        passo: exercicio.passoCargaKg > 0
                            ? exercicio.passoCargaKg
                            : 2.5,
                        planejado:
                            serie.cargaPlanKg ??
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
                      planejado: serie.repsPlan?.toDouble(),
                      aoMudar: (v) => setState(() => _reps = v),
                    ),
                  ),
                ],
              ),
              if (!serie.aquecimento) ...[
                const SizedBox(height: Espacos.l),
                const Text('COMO FOI?', style: Textos.rotulo),
                const SizedBox(height: Espacos.s),
                EscalaRir(
                  niveis: escalaDificuldade,
                  selecionado: _rir,
                  compacta: true,
                  aoEscolher: (rir) => setState(() => _rir = rir),
                ),
              ],
              if (sugere) ...[
                const SizedBox(height: Espacos.l),
                _AvisoSugestao(
                  cargaSugerida: cargaSugerida,
                  cargaAtual: _carga,
                  manter: _manter,
                  aoMudar: (manter) => setState(() => _manter = manter),
                ),
              ],
              const SizedBox(height: Espacos.l),
              BotaoBrasa(
                rotulo: 'Salvar',
                onPressed: () => Navigator.pop<AjusteDaSerie>(context, (
                  cargaKg:
                      tipo == TipoCarga.tempo ||
                          (tipo == TipoCarga.corporal && _carga == 0)
                      ? null
                      : _carga,
                  reps: _reps.round(),
                  rir: _rir,
                  manterCarga: sugere && _manter,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvisoSugestao extends StatelessWidget {
  const _AvisoSugestao({
    required this.cargaSugerida,
    required this.cargaAtual,
    required this.manter,
    required this.aoMudar,
  });

  final double cargaSugerida;
  final double cargaAtual;
  final bool manter;
  final ValueChanged<bool> aoMudar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Espacos.m),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Raios.cartao),
        border: Border.all(color: Cores.atencao),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            manter
                ? 'Próxima série mantém ${formatarKg(cargaAtual)} kg.'
                : 'Próxima série com ${formatarKg(cargaSugerida)} kg, '
                      'um passo a menos.',
            style: Textos.corpo.copyWith(color: Cores.atencao),
          ),
          const SizedBox(height: Espacos.xs),
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () => aoMudar(!manter),
              child: Text(
                manter
                    ? 'Usar ${formatarKg(cargaSugerida)} kg'
                    : 'Manter ${formatarKg(cargaAtual)} kg',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
