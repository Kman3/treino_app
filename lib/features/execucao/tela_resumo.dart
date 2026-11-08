import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/formatacao.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/botao_brasa.dart';
import 'estado_execucao.dart';
import 'sessao_treino_controller.dart';

/// Resumo simples ao fim do treino: séries feitas, tempo total e volume.
class TelaResumo extends ConsumerWidget {
  const TelaResumo({super.key, required this.treinoId});

  final String treinoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(estadoExecucaoProvider(treinoId));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/treino');
      },
      child: Scaffold(
        body: SafeArea(
          child: estado.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (erro, _) => Center(child: Text('$erro')),
            data: (e) => e == null
                ? const Center(child: Text('Treino não encontrado.'))
                : _conteudo(context, e),
          ),
        ),
      ),
    );
  }

  Widget _conteudo(BuildContext context, EstadoExecucao estado) {
    final treino = estado.treino;
    final fim = treino.finalizadoEm ?? DateTime.now();
    final parcial = treino.status == StatusTreino.parcial;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(Espacos.l),
            children: [
              Text(
                '${parcial ? 'TREINO PARCIAL' : 'TREINO CONCLUÍDO'}'
                '${estado.vinteMinutos ? ' · VERSÃO DE 20 MIN' : ''}',
                style: Textos.rotulo.copyWith(
                  color: parcial ? Cores.atencao : Cores.avanco,
                ),
              ),
              const SizedBox(height: Espacos.s),
              Text('Treino ${estado.sessao.sessao.dia}', style: Textos.titulo),
              Text(estado.sessao.sessao.foco, style: Textos.corpo),
              const SizedBox(height: Espacos.xl),
              Row(
                children: [
                  _Numero(
                    valor: '${estado.seriesFeitas}/${estado.totalSeries}',
                    rotulo: 'SÉRIES',
                  ),
                  _Numero(
                    valor: formatarDuracao(fim.difference(treino.iniciadoEm)),
                    rotulo: 'TEMPO',
                  ),
                  _Numero(
                    // Só as séries do plano; o aquecimento fica de fora.
                    valor: '${formatarVolume(estado.volumeKg)} kg',
                    rotulo: 'VOLUME',
                  ),
                ],
              ),
              const SizedBox(height: Espacos.xl),
              for (final item in estado.sessao.itens)
                _ResumoExercicio(
                  nome: item.original == null
                      ? item.exercicio.nome
                      : '${item.exercicio.nome} '
                            '(no lugar de ${item.original!.nome})',
                  exercicio: item.exercicio,
                  series: estado.seriesDoItem(item.item.id),
                  aquecimento: estado.aquecimentoDoItem(item.item.id),
                  planejadas: item.item.series,
                  dor: estado.dorEm(item),
                ),
              for (final item in estado.removidos)
                _ResumoExercicio(
                  nome: item.exercicio.nome,
                  exercicio: item.exercicio,
                  series: const [],
                  aquecimento: null,
                  planejadas: item.item.series,
                  dor: true,
                  tirado: true,
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(Espacos.l),
          child: BotaoBrasa(
            rotulo: 'Voltar ao início',
            onPressed: () => context.go('/treino'),
          ),
        ),
      ],
    );
  }
}

class _Numero extends StatelessWidget {
  const _Numero({required this.valor, required this.rotulo});

  final String valor;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(valor, style: Textos.numeroLista),
          ),
          const SizedBox(height: Espacos.xs),
          Text(rotulo, style: Textos.rotulo),
        ],
      ),
    );
  }
}

class _ResumoExercicio extends StatelessWidget {
  const _ResumoExercicio({
    required this.nome,
    required this.exercicio,
    required this.series,
    required this.aquecimento,
    required this.planejadas,
    this.dor = false,
    this.tirado = false,
  });

  final String nome;
  final Exercicio exercicio;
  final List<Serie> series;
  final Serie? aquecimento;
  final int planejadas;

  /// Dor registrada neste exercício no treino.
  final bool dor;

  /// Saiu do treino por dor antes da primeira série.
  final bool tirado;

  String _serie(Serie s) {
    final reps = s.reps ?? 0;
    return switch (exercicio.tipoCarga) {
      TipoCarga.tempo => '${reps}s',
      TipoCarga.corporal =>
        s.cargaKg == null ? '$reps' : '+${formatarKg(s.cargaKg!)}×$reps',
      _ => '${formatarKg(s.cargaKg ?? 0)}×$reps',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacos.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome, style: Textos.corpo),
                if (dor)
                  Text(
                    'DOR REGISTRADA',
                    style: Textos.rotulo.copyWith(color: Cores.dor),
                  ),
                Text(
                  tirado
                      ? 'Tirado do treino'
                      : series.isEmpty
                      ? 'Não feito'
                      : [
                          if (aquecimento != null)
                            'aq. ${_serie(aquecimento!)}',
                          ...series.map(_serie),
                        ].join(' · '),
                  style: Textos.secundario,
                ),
              ],
            ),
          ),
          Text(
            '${series.length}/$planejadas',
            style: Textos.rotulo.copyWith(
              color: series.length >= planejadas
                  ? Cores.avanco
                  : Cores.ferro400,
            ),
          ),
        ],
      ),
    );
  }
}
