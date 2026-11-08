import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/db/app_database.dart';
import '../../core/db/repositorios/plano_repository.dart';
import '../../core/formatacao.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/botao_brasa.dart';
import '../../core/widgets/escala_rir.dart';
import '../../core/widgets/timer_ring.dart';
import '../progressao/progressao.dart';
import 'estado_execucao.dart';
import 'painel_ajustar.dart';
import 'sessao_treino_controller.dart';

typedef Avisar = void Function(
  String texto, {
  required Duration duracao,
  SnackBarAction? acao,
});

/// Tela 02B Descanso: timer, próxima série e o painel "Como foi?".
///
/// O timer conta pelo horário de término gravado no banco, então segue certo
/// depois de segundo plano ou de reabrir o app. Ao chegar a zero, vibra e
/// fecha o descanso sozinho, sem bloquear nada.
class VistaDescanso extends StatefulWidget {
  const VistaDescanso({
    super.key,
    required this.estado,
    required this.controller,
    required this.avisar,
  });

  final EstadoExecucao estado;
  final SessaoTreinoController controller;
  final Avisar avisar;

  @override
  State<VistaDescanso> createState() => _VistaDescansoState();
}

class _VistaDescansoState extends State<VistaDescanso> {
  late final TiqueDoDescanso _relogio;
  DateTime? _encerradoPara;

  /// Séries cujo painel a pessoa fechou com "Pular" ou arrastando.
  final _dispensadas = <String>{};

  @override
  void initState() {
    super.initState();
    _relogio = TiqueDoDescanso(
      fim: () => widget.estado.descansoTerminaEm,
      aoBater: _tique,
    );
  }

  @override
  void dispose() {
    _relogio.parar();
    super.dispose();
  }

  void _tique() {
    if (!mounted) return;
    final fim = widget.estado.descansoTerminaEm;
    if (fim != null && !clock.now().isBefore(fim) && _encerradoPara != fim) {
      _encerradoPara = fim;
      HapticFeedback.heavyImpact();
      // Fora da tela, a notificação de fim é o único sinal: fica até a pessoa
      // tocar nela ou dispensar.
      final ciclo = WidgetsBinding.instance.lifecycleState;
      final naTela = ciclo == null || ciclo == AppLifecycleState.resumed;
      widget.controller.encerrarDescanso(widget.estado, manterAviso: !naTela);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final estado = widget.estado;
    final serie = estado.serieDoDescanso!;
    final item = estado.itemDa(serie)!;
    final fim = estado.descansoTerminaEm!;
    final restante = fim.difference(clock.now());
    final total = Duration(
      seconds: serie.aquecimento
          ? descansoAquecimentoS.clamp(1, item.item.descansoS)
          : item.item.descansoS,
    );
    final novoPr = estado.novoPrDo(item);
    final mostrarPergunta =
        !serie.aquecimento &&
        !_dispensadas.contains(serie.id) &&
        !(serie.rir != null && serie.confirmado);

    // Com o cartão de novo PR e a pergunta abertos juntos, o anel grande
    // empurraria o cartão para trás do painel: o timer vira a pílula
    // compacta, ao lado do ±15 s, e o cartão sobe.
    final compacto = novoPr != null && mostrarPergunta;
    final timer = TimerRing(
      restante: restante,
      total: total > restante ? total : restante,
      compacto: compacto,
    );
    final menos15 = _BotaoTempo(
      rotulo: '−15s',
      aoTocar: () => widget.controller.ajustarDescanso(estado, -15),
    );
    final mais15 = _BotaoTempo(
      rotulo: '+15s',
      aoTocar: () => widget.controller.ajustarDescanso(estado, 15),
    );
    final proxima = Text(
      _proxima(estado),
      textAlign: TextAlign.center,
      style: Textos.rotulo,
    );
    final cartao = novoPr == null
        ? null
        : CartaoNovoPr(
            pr: novoPr,
            modo: estado.modoNovoZero,
            aoDecidir: (carga) => decidirNovoZero(
              widget.controller,
              estado,
              novoPr,
              carga,
              widget.avisar,
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(Espacos.l),
            children: [
              const Text(
                'DESCANSO',
                textAlign: TextAlign.center,
                style: Textos.rotulo,
              ),
              const SizedBox(height: Espacos.m),
              if (compacto) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    timer,
                    const SizedBox(width: Espacos.m),
                    menos15,
                    const SizedBox(width: Espacos.s),
                    mais15,
                  ],
                ),
                const SizedBox(height: Espacos.m),
                cartao!,
                const SizedBox(height: Espacos.l),
                proxima,
              ] else ...[
                const SizedBox(height: Espacos.s),
                Center(child: timer),
                const SizedBox(height: Espacos.l),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [menos15, const SizedBox(width: Espacos.m), mais15],
                ),
                const SizedBox(height: Espacos.l),
                proxima,
                if (cartao != null) ...[
                  const SizedBox(height: Espacos.l),
                  cartao,
                ],
              ],
            ],
          ),
        ),
        if (mostrarPergunta)
          _PainelPergunta(
            serie: serie,
            exercicio: item.exercicio,
            aoResponder: (rir) =>
                widget.controller.responderDificuldade(serie, rir),
            aoConfirmar: () => widget.controller.confirmar(serie),
            aoAjustar: () => _ajustar(item, serie, fim, total),
            aoPular: () => setState(() => _dispensadas.add(serie.id)),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Espacos.l,
            Espacos.s,
            Espacos.l,
            Espacos.l,
          ),
          child: BotaoBrasa(
            rotulo: 'Pular descanso',
            variante: mostrarPergunta
                ? VarianteBotao.secundario
                : VarianteBotao.primario,
            onPressed: () => widget.controller.encerrarDescanso(estado),
          ),
        ),
      ],
    );
  }

  String _proxima(EstadoExecucao estado) {
    final p = estado.atual;
    if (p == null) return 'TREINO COMPLETO';
    final nome = p.aquecimento ? 'AQUECIMENTO' : 'SÉRIE ${p.numero}';
    final carga = p.cargaPlanKg == null
        ? ''
        : '${formatarKg(p.cargaPlanKg!)} KG × ';
    return 'PRÓXIMA · ${p.item.exercicio.nome.toUpperCase()} · $nome · '
        '$carga${p.repsPlan}';
  }

  Future<void> _ajustar(
    ItemComExercicio item,
    Serie serie,
    DateTime fim,
    Duration total,
  ) async {
    final ajuste = await abrirPainelAjustar(
      context,
      item: item,
      serie: serie,
      descansoTerminaEm: fim,
      descansoTotal: total,
      sugestaoLigada: widget.estado.sugestaoLigada,
    );
    if (ajuste == null) return;
    await widget.controller.ajustar(
      serie,
      cargaKg: ajuste.cargaKg,
      reps: ajuste.reps,
      rir: ajuste.rir,
    );
    await widget.controller.manterCarga(serie, manter: ajuste.manterCarga);
    widget.avisar('Série ajustada', duracao: const Duration(seconds: 3));
  }
}

class _BotaoTempo extends StatelessWidget {
  const _BotaoTempo({required this.rotulo, required this.aoTocar});

  final String rotulo;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 48,
      child: OutlinedButton(
        onPressed: aoTocar,
        style: OutlinedButton.styleFrom(
          foregroundColor: Cores.giz,
          side: const BorderSide(color: Cores.ferro700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Raios.botao),
          ),
        ),
        child: Text(rotulo, style: Textos.botao),
      ),
    );
  }
}

/// Painel inferior da 02B. Responder a dificuldade e confirmar são
/// independentes; nada é obrigatório.
class _PainelPergunta extends StatelessWidget {
  const _PainelPergunta({
    required this.serie,
    required this.exercicio,
    required this.aoResponder,
    required this.aoConfirmar,
    required this.aoAjustar,
    required this.aoPular,
  });

  final Serie serie;
  final Exercicio exercicio;
  final ValueChanged<int> aoResponder;
  final VoidCallback aoConfirmar;
  final VoidCallback aoAjustar;
  final VoidCallback aoPular;

  String get _feito {
    final reps = serie.reps ?? 0;
    return switch (exercicio.tipoCarga) {
      TipoCarga.tempo => '$reps s',
      TipoCarga.corporal =>
        serie.cargaKg == null
            ? '$reps reps'
            : '+${formatarKg(serie.cargaKg!)} kg × $reps',
      _ => '${formatarKg(serie.cargaKg ?? 0)} kg × $reps',
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Arrastar o painel para baixo fecha a pergunta.
      onVerticalDragEnd: (detalhes) {
        if ((detalhes.primaryVelocity ?? 0) > 200) aoPular();
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          Espacos.l,
          Espacos.m,
          Espacos.l,
          Espacos.s,
        ),
        decoration: const BoxDecoration(
          color: Cores.ferro800,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Raios.painel),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Cores.ferro700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: Espacos.m),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'COMO FOI A SÉRIE ${serie.numero}?',
                    style: Textos.rotulo,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: TextButton(
                    onPressed: aoPular,
                    child: const Text('Pular'),
                  ),
                ),
              ],
            ),
            EscalaRir(
              niveis: escalaDificuldade,
              selecionado: serie.rir,
              aoEscolher: aoResponder,
            ),
            const SizedBox(height: Espacos.m),
            if (serie.confirmado)
              Text(
                '✓ Confirmado: $_feito',
                textAlign: TextAlign.center,
                style: Textos.secundario.copyWith(color: Cores.avanco),
              )
            else ...[
              Text(
                'Fez $_feito mesmo?',
                textAlign: TextAlign.center,
                style: Textos.corpo,
              ),
              const SizedBox(height: Espacos.s),
              Row(
                children: [
                  Expanded(
                    child: BotaoBrasa(
                      rotulo: 'Ajustar',
                      variante: VarianteBotao.secundario,
                      onPressed: aoAjustar,
                    ),
                  ),
                  const SizedBox(width: Espacos.s),
                  Expanded(
                    flex: 2,
                    child: BotaoBrasa(
                      rotulo: '✓ Sim, igual',
                      onPressed: aoConfirmar,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Aplica (ou recusa) o novo ponto de partida e oferece desfazer.
Future<void> decidirNovoZero(
  SessaoTreinoController controller,
  EstadoExecucao estado,
  NovoPr pr,
  double? novaCarga,
  Avisar avisar,
) async {
  final anterior = pr.cargaPlanoAtual;
  await controller.decidirNovoZero(estado, pr, novaCargaKg: novaCarga);
  if (novaCarga == null) return;
  avisar(
    'Plano de ${pr.item.exercicio.nome}: ${formatarKg(novaCarga)} kg',
    duracao: const Duration(seconds: 5),
    acao: SnackBarAction(
      label: 'Desfazer',
      textColor: Cores.brasa,
      onPressed: () =>
          controller.desfazerNovoZero(estado, pr, cargaAnteriorKg: anterior),
    ),
  );
}

/// "Novo PR!" com a pergunta se a carga vira o novo ponto de partida.
class CartaoNovoPr extends StatelessWidget {
  const CartaoNovoPr({
    super.key,
    required this.pr,
    required this.modo,
    required this.aoDecidir,
  });

  final NovoPr pr;
  final ModoNovoZero modo;

  /// Nova carga do plano, ou nulo para "Agora não".
  final ValueChanged<double?> aoDecidir;

  String get _historico {
    final datas = pr.datas.map(formatarData).toList();
    final vezes = datas.isEmpty ? 1 : datas.length;
    final quando = datas.isEmpty ? '' : ' (${datas.join(', ')})';
    return vezes == 1
        ? 'É a primeira vez com ${formatarKg(pr.cargaPr)} kg ou mais.'
        : 'Você já fez ${formatarKg(pr.cargaPr)} kg ou mais $vezes vezes$quando.';
  }

  @override
  Widget build(BuildContext context) {
    final reps = pr.serie.reps ?? 0;
    final repsPlano = pr.item.item.repsMax;
    final atual = formatarKg(pr.cargaPlanoAtual);
    final umRm = formatarKg(pr.novaBaseUmRm);
    final direto = formatarKg(pr.cargaPr);

    final String explicacao;
    final List<Widget> botoes;
    Widget usar(String rotulo, double carga, {bool primario = true}) =>
        Expanded(
          flex: primario ? 2 : 1,
          child: BotaoBrasa(
            rotulo: rotulo,
            variante: primario
                ? VarianteBotao.primario
                : VarianteBotao.secundario,
            onPressed: () => aoDecidir(carga),
          ),
        );
    final agoraNao = Expanded(
      child: BotaoBrasa(
        rotulo: 'Agora não',
        variante: VarianteBotao.secundario,
        onPressed: () => aoDecidir(null),
      ),
    );

    switch (modo) {
      case ModoNovoZero.umRm when !pr.umRmSobe:
        explicacao =
            'Pela conversão do 1RM, $direto kg × $reps equivale à carga de '
            'hoje ($atual kg × $repsPlano). O plano continua igual.';
        botoes = [
          Expanded(
            child: BotaoBrasa(rotulo: 'OK', onPressed: () => aoDecidir(null)),
          ),
        ];
      case ModoNovoZero.umRm:
        explicacao =
            'As séries normais passam de $atual para $umRm kg × $repsPlano '
            '(conversão pelo 1RM).';
        botoes = [
          agoraNao,
          const SizedBox(width: Espacos.s),
          usar('Usar $umRm kg', pr.novaBaseUmRm),
        ];
      case ModoNovoZero.direto:
        explicacao =
            'As séries normais passam de $atual para $direto kg × $repsPlano.';
        botoes = [
          agoraNao,
          const SizedBox(width: Espacos.s),
          usar('Usar $direto kg', pr.cargaPr),
        ];
      case ModoNovoZero.perguntar:
        explicacao =
            'Escolha a nova carga das séries normais (hoje $atual kg × '
            '$repsPlano): pela conversão do 1RM ou o peso do PR.';
        botoes = [
          if (pr.umRmSobe) ...[
            usar('$umRm kg (1RM)', pr.novaBaseUmRm, primario: false),
            const SizedBox(width: Espacos.s),
          ],
          usar('$direto kg (PR)', pr.cargaPr, primario: false),
        ];
    }

    return Container(
      padding: const EdgeInsets.all(Espacos.l),
      decoration: BoxDecoration(
        color: Cores.ferro800,
        borderRadius: BorderRadius.circular(Raios.cartao),
        border: Border.all(color: Cores.avanco),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'NOVO PR · ${pr.item.exercicio.nome.toUpperCase()}',
            style: Textos.rotulo.copyWith(color: Cores.avanco),
          ),
          const SizedBox(height: Espacos.xs),
          Text(
            '$direto kg × $reps',
            style: Textos.titulo.copyWith(fontSize: 32),
          ),
          Text(
            pr.prAnteriorKg == null
                ? 'Primeiro recorde registrado neste exercício.'
                : 'Recorde anterior: ${formatarKg(pr.prAnteriorKg!)} kg.',
            style: Textos.secundario,
          ),
          Text(_historico, style: Textos.secundario),
          const SizedBox(height: Espacos.m),
          const Text('Usar como novo ponto de partida?', style: Textos.nome),
          const SizedBox(height: Espacos.xs),
          Text(explicacao, style: Textos.corpo),
          const SizedBox(height: Espacos.m),
          Row(children: botoes),
          if (modo == ModoNovoZero.perguntar)
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 48,
                child: TextButton(
                  onPressed: () => aoDecidir(null),
                  child: const Text('Agora não'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
