import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/db/repositorios/plano_repository.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/botao_brasa.dart';
import '../../core/formatacao.dart';
import '../execucao/sessao_treino_controller.dart';
import '../execucao/versao_reduzida.dart';
import 'hoje_providers.dart';

/// Tela 01 Hoje: o treino do dia lido do banco local, a prévia das outras
/// sessões do ciclo e a retomada de um treino em andamento.
class TelaHoje extends ConsumerStatefulWidget {
  const TelaHoje({super.key});

  @override
  ConsumerState<TelaHoje> createState() => _TelaHojeState();
}

class _TelaHojeState extends ConsumerState<TelaHoje> {
  /// Sessão escolhida no cabeçalho; nula = a do dia.
  String? _sessaoPreviaId;
  bool _iniciando = false;

  /// Continua o treino em andamento ou inicia um novo da sessão do dia.
  Future<void> _abrirTreino(
    TreinoDoDia dia, {
    bool vinteMinutos = false,
  }) async {
    final emAndamento = dia.emAndamento;
    if (emAndamento != null) {
      context.go('/execucao/${emAndamento.id}');
      return;
    }
    if (_iniciando) return;
    setState(() => _iniciando = true);
    try {
      final treinoId = await ref
          .read(sessaoTreinoControllerProvider)
          .iniciar(dia.sessao.sessao.id, vinteMinutos: vinteMinutos);
      if (mounted) context.go('/execucao/$treinoId');
    } finally {
      if (mounted) setState(() => _iniciando = false);
    }
  }

  /// Prévia da versão de 20 minutos; "Começar" inicia o treino nela.
  Future<void> _vinteMinutos(TreinoDoDia dia) async {
    final reduzida = sessaoVinteMinutos(dia.sessao);
    final comecar = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Cores.ferro800,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Raios.painel)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Espacos.l),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('SÓ TENHO 20 MINUTOS', style: Textos.rotulo),
                const SizedBox(height: Espacos.xs),
                Text(
                  'Treino ${reduzida.sessao.dia} · ~${reduzida.duracaoEstimadaMin} min',
                  style: Textos.nome.copyWith(fontSize: 22),
                ),
                const SizedBox(height: Espacos.xs),
                const Text(
                  'Os exercícios principais, com 2 séries e até 60 s de '
                  'descanso, nas mesmas cargas. O plano não muda.',
                  style: Textos.secundario,
                ),
                const SizedBox(height: Espacos.l),
                for (final i in reduzida.itens)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Espacos.m),
                    // Nome em cima, prescrição embaixo: cabe com texto em 200%.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(i.exercicio.nome, style: Textos.corpo),
                        Text(
                          '${formatarPrescricao(i.item, i.exercicio)}'
                          '${i.item.cargaPlanKg == null ? '' : ' · ${formatarKg(i.item.cargaPlanKg!)} kg'}',
                          style: Textos.secundario,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: Espacos.l),
                BotaoBrasa(
                  rotulo: 'Começar versão de 20 min',
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (comecar == true && mounted) await _abrirTreino(dia, vinteMinutos: true);
  }

  @override
  Widget build(BuildContext context) {
    final treinoDoDia = ref.watch(treinoDoDiaProvider);

    return SafeArea(
      child: treinoDoDia.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (erro, _) =>
            _Mensagem('Não foi possível carregar o treino.\n$erro'),
        data: (dia) => dia == null
            ? const _Mensagem('Nenhum plano de treino ativo.')
            : _conteudo(dia),
      ),
    );
  }

  Widget _conteudo(TreinoDoDia dia) {
    final idDoDia = dia.sessao.sessao.id;
    final idMostrado = _sessaoPreviaId ?? idDoDia;
    final ehDoDia = idMostrado == idDoDia;
    final sessao = ehDoDia
        ? dia.sessao
        : ref.watch(sessaoProvider(idMostrado)).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(Espacos.l),
            children: [
              Text(
                'SEMANA ${dia.semana} DE ${dia.plano.semanas} · '
                'CICLO ${dia.plano.divisao}',
                style: Textos.rotulo,
              ),
              const SizedBox(height: Espacos.m),
              _SeletorDias(
                sessoes: dia.sessoes,
                idDoDia: idDoDia,
                idSelecionado: idMostrado,
                aoSelecionar: (id) =>
                    setState(() => _sessaoPreviaId = id == idDoDia ? null : id),
              ),
              const SizedBox(height: Espacos.xl),
              if (sessao == null)
                const Center(child: CircularProgressIndicator())
              else
                ..._detalhesSessao(sessao, ehDoDia: ehDoDia, dia: dia),
            ],
          ),
        ),
        if (ehDoDia)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Espacos.l,
              Espacos.s,
              Espacos.l,
              Espacos.l,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (dia.emAndamento == null)
                  SizedBox(
                    height: 48,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Cores.giz),
                      onPressed: _iniciando ? null : () => _vinteMinutos(dia),
                      icon: const Icon(
                        Icons.timer_outlined,
                        size: 20,
                        color: Cores.ferro400,
                      ),
                      label: const Text('Só tenho 20 minutos'),
                    ),
                  ),
                BotaoBrasa(
                  rotulo: dia.emAndamento == null
                      ? 'Começar treino'
                      : 'Continuar treino',
                  carregando: _iniciando,
                  onPressed: () => _abrirTreino(dia),
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> _detalhesSessao(
    SessaoComItens sessao, {
    required bool ehDoDia,
    required TreinoDoDia dia,
  }) {
    return [
      if (ehDoDia && dia.emAndamento != null) ...[
        Container(
          padding: const EdgeInsets.all(Espacos.m),
          decoration: BoxDecoration(
            color: Cores.ferro800,
            borderRadius: BorderRadius.circular(Raios.cartao),
            border: Border.all(color: Cores.brasa),
          ),
          child: Text(
            'Treino ${sessao.sessao.dia} em andamento — continuar?',
            style: Textos.corpo,
          ),
        ),
        const SizedBox(height: Espacos.l),
      ],
      if (!ehDoDia) ...[
        Text(
          'PRÉVIA · HOJE É O TREINO ${dia.sessao.sessao.dia}',
          style: Textos.rotulo.copyWith(color: Cores.atencao),
        ),
        const SizedBox(height: Espacos.s),
      ],
      Semantics(
        header: true,
        child: Text('Treino ${sessao.sessao.dia}', style: Textos.titulo),
      ),
      const SizedBox(height: Espacos.xs),
      Text(sessao.sessao.foco, style: Textos.corpo),
      const SizedBox(height: Espacos.xs),
      Text(
        '${sessao.itens.length} exercícios · ~${sessao.duracaoEstimadaMin} min',
        style: Textos.secundario,
      ),
      const SizedBox(height: Espacos.l),
      for (final item in sessao.itens) ...[
        _CartaoExercicio(item),
        const SizedBox(height: Espacos.s),
      ],
    ];
  }
}

class _SeletorDias extends StatelessWidget {
  const _SeletorDias({
    required this.sessoes,
    required this.idDoDia,
    required this.idSelecionado,
    required this.aoSelecionar,
  });

  final List<SessaoPlano> sessoes;
  final String idDoDia;
  final String idSelecionado;
  final ValueChanged<String> aoSelecionar;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Espacos.s,
      children: [
        for (final s in sessoes)
          Semantics(
            button: true,
            selected: s.id == idSelecionado,
            label: s.id == idDoDia
                ? 'Treino ${s.dia}, hoje'
                : 'Treino ${s.dia}',
            excludeSemantics: true,
            child: InkWell(
              onTap: () => aoSelecionar(s.id),
              borderRadius: BorderRadius.circular(Raios.botao),
              child: Ink(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: s.id == idSelecionado ? Cores.brasa : Cores.ferro700,
                  borderRadius: BorderRadius.circular(Raios.botao),
                  border: s.id == idDoDia && s.id != idSelecionado
                      ? Border.all(color: Cores.brasa, width: 1.5)
                      : null,
                ),
                child: Center(
                  child: Text(
                    s.dia,
                    style: Textos.numeroLista.copyWith(
                      fontSize: 24,
                      color: s.id == idSelecionado ? Cores.ferro900 : Cores.giz,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CartaoExercicio extends StatelessWidget {
  const _CartaoExercicio(this.itemComExercicio);

  final ItemComExercicio itemComExercicio;

  @override
  Widget build(BuildContext context) {
    final ItemComExercicio(:item, :exercicio) = itemComExercicio;
    final carga = item.cargaPlanKg;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/exercicio/${exercicio.id}?item=${item.id}'),
        child: Padding(
          padding: const EdgeInsets.all(Espacos.l),
          child: Row(
            children: [
              Text(
                (item.ordem + 1).toString().padLeft(2, '0'),
                style: Textos.rotulo,
              ),
              const SizedBox(width: Espacos.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exercicio.nome, style: Textos.nome),
                    const SizedBox(height: Espacos.xs),
                    Text(
                      formatarPrescricao(item, exercicio),
                      style: Textos.secundario,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Espacos.m),
              if (exercicio.tipoCarga == TipoCarga.corporal)
                const Text('CORPO', style: Textos.rotulo)
              else if (carga != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(formatarKg(carga), style: Textos.numeroLista),
                    const SizedBox(width: 2),
                    const Text('KG', style: Textos.rotulo),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Mensagem extends StatelessWidget {
  const _Mensagem(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Espacos.xl),
        child: Text(
          texto,
          style: Textos.secundario,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
