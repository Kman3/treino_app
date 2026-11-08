import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import '../../core/formatacao.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/botao_brasa.dart';
import '../../core/widgets/stepper_valor.dart';
import '../progressao/progressao.dart';

/// O que a pessoa escolheu no "⇄ Ocupado": o exercício novo, a carga para
/// começar e se a troca vale só hoje ou para sempre no plano.
typedef EscolhaTroca = ({Exercicio novo, double? cargaKg, bool sempre});

/// Carga sugerida para começar o substituto e de onde ela veio.
typedef SugestaoCarga = ({double? cargaKg, String origem});

/// A última vez do substituto, se houver; senão uma estimativa a partir da
/// carga do exercício trocado ([cargaInicialSubstituto] faz a conta).
SugestaoCarga sugerirCargaDoSubstituto({
  required Exercicio atual,
  required double? cargaAtual,
  required Exercicio novo,
  required Serie? ultimaDoNovo,
}) {
  if (novo.tipoCarga != TipoCarga.externa) {
    return (cargaKg: null, origem: '');
  }
  final ultima = ultimaDoNovo?.cargaKg;
  if (ultima != null) {
    return (
      cargaKg: ultima,
      origem:
          'Última vez: ${formatarKg(ultima)} kg × ${ultimaDoNovo!.reps ?? 0}.',
    );
  }
  if (cargaAtual == null || atual.tipoCarga != TipoCarga.externa) {
    return (
      cargaKg: arredondarCarga(
        20,
        equipamento: novo.equipamento,
        passo: novo.passoCargaKg,
      ),
      origem: 'Sem referência: escolha a carga.',
    );
  }
  return (
    cargaKg: cargaInicialSubstituto(
      cargaOriginal: cargaAtual,
      equipamentoOriginal: atual.equipamento,
      equipamentoNovo: novo.equipamento,
      passoNovo: novo.passoCargaKg,
    ),
    origem:
        'Estimativa a partir de ${formatarKg(cargaAtual)} kg em '
        '${atual.nome}. Confira antes de começar.',
  );
}

/// Painel "⇄ Ocupado": lista os substitutos do mesmo padrão de movimento e,
/// escolhido um, pede a carga inicial e se a troca vale só hoje ou sempre.
///
/// [doPlano] é o exercício do plano quando o atual já é uma troca de hoje:
/// ele aparece primeiro, para voltar. Com [preEscolhido], o painel abre
/// direto na carga. Sem [permitirSoHoje] (fora de um treino), só há "Usar
/// sempre no plano".
Future<EscolhaTroca?> abrirPainelOcupado(
  BuildContext context, {
  required Exercicio atual,
  required double? cargaAtual,
  String? treinoId,
  Exercicio? doPlano,
  Exercicio? preEscolhido,
  bool permitirSoHoje = true,
  String titulo = 'OCUPADO? TROQUE O EXERCÍCIO',
}) {
  return showModalBottomSheet<EscolhaTroca>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Cores.ferro800,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Raios.painel)),
    ),
    builder: (_) => _PainelOcupado(
      atual: atual,
      cargaAtual: cargaAtual,
      treinoId: treinoId,
      doPlano: doPlano,
      preEscolhido: preEscolhido,
      permitirSoHoje: permitirSoHoje,
      titulo: titulo,
    ),
  );
}

class _PainelOcupado extends ConsumerStatefulWidget {
  const _PainelOcupado({
    required this.atual,
    required this.cargaAtual,
    required this.treinoId,
    required this.doPlano,
    required this.preEscolhido,
    required this.permitirSoHoje,
    required this.titulo,
  });

  final Exercicio atual;
  final double? cargaAtual;
  final String? treinoId;
  final Exercicio? doPlano;
  final Exercicio? preEscolhido;
  final bool permitirSoHoje;
  final String titulo;

  @override
  ConsumerState<_PainelOcupado> createState() => _PainelOcupadoState();
}

class _PainelOcupadoState extends ConsumerState<_PainelOcupado> {
  late final Future<_Opcoes> _opcoes = _carregar();
  Exercicio? _escolhido;
  double? _carga;
  String _origem = '';

  Future<_Opcoes> _carregar() async {
    final substitutos = await ref
        .read(exercicioRepositoryProvider)
        .substitutos(widget.atual);
    final ultimas = await ref.read(treinoRepositoryProvider).ultimaVez([
      for (final s in substitutos) s.id,
    ], excetoTreinoId: widget.treinoId ?? '');
    final opcoes = (
      substitutos: [
        // O do plano primeiro, para voltar a ele.
        if (widget.doPlano case final plano?)
          ...substitutos.where((s) => s.id == plano.id),
        ...substitutos.where((s) => s.id != widget.doPlano?.id),
      ],
      ultimas: {
        for (final MapEntry(:key, :value) in ultimas.entries)
          if (value.isNotEmpty) key: value.first,
      },
    );
    if (widget.preEscolhido case final novo?) _escolher(novo, opcoes);
    return opcoes;
  }

  void _escolher(Exercicio novo, _Opcoes opcoes) {
    final sugestao = sugerirCargaDoSubstituto(
      atual: widget.atual,
      cargaAtual: widget.cargaAtual,
      novo: novo,
      ultimaDoNovo: opcoes.ultimas[novo.id],
    );
    setState(() {
      _escolhido = novo;
      _carga = sugestao.cargaKg;
      _origem = sugestao.origem;
    });
  }

  void _confirmar({required bool sempre}) {
    Navigator.pop<EscolhaTroca>(context, (
      novo: _escolhido!,
      cargaKg: _carga,
      sempre: sempre,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Espacos.l,
          Espacos.l,
          Espacos.l,
          Espacos.l + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: FutureBuilder(
          future: _opcoes,
          builder: (context, snapshot) {
            final opcoes = snapshot.data;
            if (opcoes == null) {
              return const SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final escolhido = _escolhido;
            return escolhido == null
                ? _lista(opcoes)
                : _carregaEscopo(escolhido);
          },
        ),
      ),
    );
  }

  Widget _lista(_Opcoes opcoes) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.titulo, style: Textos.rotulo),
        const SizedBox(height: Espacos.xs),
        Text(widget.atual.nome, style: Textos.nome),
        Text(
          'Mesmo movimento: ${nomePadrao(widget.atual.padraoMovimento).toLowerCase()}.',
          style: Textos.secundario,
        ),
        const SizedBox(height: Espacos.l),
        if (opcoes.substitutos.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: Espacos.l),
            child: Text(
              'Nenhum outro exercício do catálogo faz este movimento.',
              style: Textos.corpo,
            ),
          )
        else
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final s in opcoes.substitutos)
                  _OpcaoSubstituto(
                    exercicio: s,
                    doPlano: s.id == widget.doPlano?.id,
                    ultima: opcoes.ultimas[s.id],
                    aoEscolher: () => _escolher(s, opcoes),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _carregaEscopo(Exercicio escolhido) {
    final carga = _carga;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('TROCAR POR', style: Textos.rotulo),
          const SizedBox(height: Espacos.xs),
          Text(escolhido.nome, style: Textos.nome.copyWith(fontSize: 22)),
          Text(
            'No lugar de ${widget.atual.nome} · '
            '${nomeEquipamento(escolhido.equipamento)}',
            style: Textos.secundario,
          ),
          if (carga != null) ...[
            const SizedBox(height: Espacos.l),
            StepperValor(
              rotulo: 'Carga inicial',
              unidade: 'kg',
              valor: carga,
              passo: escolhido.passoCargaKg > 0 ? escolhido.passoCargaKg : 2.5,
              minimo: 0.5,
              aoMudar: (v) => setState(() => _carga = v),
            ),
            const SizedBox(height: Espacos.xs),
            Text(_origem, style: Textos.secundario),
          ],
          const SizedBox(height: Espacos.l),
          if (widget.permitirSoHoje) ...[
            BotaoBrasa(
              rotulo: 'Trocar só hoje',
              onPressed: () => _confirmar(sempre: false),
            ),
            const SizedBox(height: Espacos.s),
            BotaoBrasa(
              rotulo: 'Usar sempre no plano',
              variante: VarianteBotao.secundario,
              onPressed: () => _confirmar(sempre: true),
            ),
          ] else
            BotaoBrasa(
              rotulo: 'Usar sempre no plano',
              onPressed: () => _confirmar(sempre: true),
            ),
          if (widget.preEscolhido == null)
            SizedBox(
              height: 48,
              child: TextButton(
                onPressed: () => setState(() => _escolhido = null),
                child: const Text('Escolher outro'),
              ),
            ),
        ],
      ),
    );
  }
}

typedef _Opcoes = ({List<Exercicio> substitutos, Map<String, Serie> ultimas});

class _OpcaoSubstituto extends StatelessWidget {
  const _OpcaoSubstituto({
    required this.exercicio,
    required this.doPlano,
    required this.ultima,
    required this.aoEscolher,
  });

  final Exercicio exercicio;
  final bool doPlano;
  final Serie? ultima;
  final VoidCallback aoEscolher;

  @override
  Widget build(BuildContext context) {
    final ultimaCarga = ultima?.cargaKg;
    final detalhes = [
      nomeEquipamento(exercicio.equipamento),
      if (doPlano) 'o do plano',
      if (ultimaCarga != null)
        'última vez ${formatarKg(ultimaCarga)} kg × ${ultima!.reps ?? 0}',
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacos.s),
      child: Material(
        color: Cores.ferro700,
        borderRadius: BorderRadius.circular(Raios.cartao),
        child: InkWell(
          borderRadius: BorderRadius.circular(Raios.cartao),
          onTap: aoEscolher,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.all(Espacos.m),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercicio.nome, style: Textos.nome),
                        Text(
                          detalhes,
                          style: Textos.secundario.copyWith(color: Cores.giz),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Cores.ferro400),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
