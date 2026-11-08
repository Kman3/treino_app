import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import '../../core/db/repositorios/evolucao_repository.dart';
import '../../core/formatacao.dart';
import '../../core/theme/tokens.dart';
import '../execucao/painel_ocupado.dart';
import 'exercicio_providers.dart';
import 'grafico_evolucao.dart';
import 'justificativas.dart';

/// Tela 03 Exercício: músculos-alvo, evolução de 8 semanas, por que ele está
/// no plano e os substitutos. Aberta de um item do plano ([itemPlanoId]), dá
/// para trocar o exercício no plano.
class TelaExercicio extends ConsumerWidget {
  const TelaExercicio({super.key, required this.exercicioId, this.itemPlanoId});

  final String exercicioId;
  final String? itemPlanoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercicio = ref.watch(exercicioProvider(exercicioId));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cores.ferro900,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Cores.giz,
        title: const Text('EXERCÍCIO', style: Textos.rotulo),
        centerTitle: true,
      ),
      body: exercicio.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (erro, _) => Center(
          child: Text('Erro ao carregar.\n$erro', style: Textos.secundario),
        ),
        data: (e) => e == null
            ? const Center(
                child: Text(
                  'Exercício não encontrado.',
                  style: Textos.secundario,
                ),
              )
            : _Conteudo(exercicio: e, itemPlanoId: itemPlanoId),
      ),
    );
  }
}

class _Conteudo extends ConsumerWidget {
  const _Conteudo({required this.exercicio, required this.itemPlanoId});

  final Exercicio exercicio;
  final String? itemPlanoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musculos = exercicio.musculosAlvo
        .split(',')
        .map((m) => m.trim())
        .where((m) => m.isNotEmpty)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Espacos.l,
        Espacos.s,
        Espacos.l,
        Espacos.xl,
      ),
      children: [
        Semantics(
          header: true,
          child: Text(
            exercicio.nome,
            style: Textos.titulo.copyWith(fontSize: 34),
          ),
        ),
        const SizedBox(height: Espacos.xs),
        Text(
          '${nomeEquipamento(exercicio.equipamento)} · '
                  '${nomePadrao(exercicio.padraoMovimento)}'
              .toUpperCase(),
          style: Textos.rotulo,
        ),
        const SizedBox(height: Espacos.l),
        const Text('MÚSCULOS-ALVO', style: Textos.rotulo),
        const SizedBox(height: Espacos.s),
        Wrap(
          spacing: Espacos.s,
          runSpacing: Espacos.s,
          children: [
            for (final (i, m) in musculos.indexed)
              _Musculo(nome: m, principal: i == 0),
          ],
        ),
        const SizedBox(height: Espacos.xl),
        _CartaoEvolucao(exercicio: exercicio),
        const SizedBox(height: Espacos.xl),
        _CartaoPorQue(exercicio: exercicio, itemPlanoId: itemPlanoId),
        const SizedBox(height: Espacos.xl),
        _Substitutos(exercicio: exercicio, itemPlanoId: itemPlanoId),
      ],
    );
  }
}

class _Musculo extends StatelessWidget {
  const _Musculo({required this.nome, required this.principal});

  final String nome;
  final bool principal;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: principal ? '$nome, principal' : nome,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Espacos.m,
          vertical: Espacos.s,
        ),
        decoration: BoxDecoration(
          color: Cores.ferro800,
          borderRadius: BorderRadius.circular(Raios.botao),
          border: Border.all(color: principal ? Cores.giz : Cores.ferro700),
        ),
        child: Text(
          nome,
          style: Textos.corpo.copyWith(
            fontWeight: principal ? FontWeight.w600 : null,
          ),
        ),
      ),
    );
  }
}

class _Cartao extends StatelessWidget {
  const _Cartao({required this.titulo, required this.children});

  final String titulo;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Espacos.l),
      decoration: BoxDecoration(
        color: Cores.ferro800,
        borderRadius: BorderRadius.circular(Raios.cartao),
        border: Border.all(color: Cores.ferro700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(titulo, style: Textos.rotulo),
          const SizedBox(height: Espacos.s),
          ...children,
        ],
      ),
    );
  }
}

class _CartaoEvolucao extends ConsumerWidget {
  const _CartaoEvolucao({required this.exercicio});

  final Exercicio exercicio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evolucao = ref.watch(evolucaoDoExercicioProvider(exercicio.id));
    final metrica = MetricaEvolucao.de(exercicio);
    final titulo = switch (metrica) {
      MetricaEvolucao.umRm => '1RM ESTIMADO · 8 SEMANAS',
      MetricaEvolucao.reps => 'MAIS REPS NUMA SÉRIE · 8 SEMANAS',
      MetricaEvolucao.segundos => 'MAIS TEMPO NUMA SÉRIE · 8 SEMANAS',
    };

    return _Cartao(
      titulo: titulo,
      children: evolucao.when(
        loading: () => const [
          SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
        error: (erro, _) => [Text('$erro', style: Textos.secundario)],
        data: (e) {
          final agora = clock.now();
          final pontos = e?.ultimasSemanas(agora) ?? const [];
          final ultimo = e?.ultimo;
          if (ultimo == null) {
            return const [
              Text(
                'Ainda sem registros. Depois do primeiro treino com este '
                'exercício, a evolução aparece aqui.',
                style: Textos.corpo,
              ),
            ];
          }
          return [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    formatarValorEvolucao(ultimo.valor, metrica),
                    style: Textos.numeroLista.copyWith(fontSize: 36),
                  ),
                ),
                if (ultimo.recorde) const _SeloRecorde(),
              ],
            ),
            Text(
              'No último treino, ${formatarData(ultimo.data)}'
              '${metrica == MetricaEvolucao.umRm ? ' (${formatarKg(ultimo.cargaKg ?? 0)} kg × ${ultimo.reps})' : ''}',
              style: Textos.secundario,
            ),
            const SizedBox(height: Espacos.l),
            if (pontos.isEmpty)
              const Text(
                'Nenhum treino nas últimas 8 semanas.',
                style: Textos.secundario,
              )
            else
              GraficoEvolucao(pontos: pontos, metrica: metrica, agora: agora),
            if (metrica == MetricaEvolucao.umRm) ...[
              const SizedBox(height: Espacos.s),
              const Text(
                'Melhor série de cada treino pela fórmula de Epley: '
                'carga × (1 + reps ÷ 30). Pontos verdes são recordes.',
                style: Textos.secundario,
              ),
            ],
          ];
        },
      ),
    );
  }
}

class _SeloRecorde extends StatelessWidget {
  const _SeloRecorde();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Espacos.s,
        vertical: Espacos.xs,
      ),
      decoration: BoxDecoration(
        color: Cores.avanco,
        borderRadius: BorderRadius.circular(Raios.botao),
      ),
      child: Text(
        'RECORDE',
        style: Textos.rotulo.copyWith(color: Cores.ferro900),
      ),
    );
  }
}

class _CartaoPorQue extends ConsumerWidget {
  const _CartaoPorQue({required this.exercicio, required this.itemPlanoId});

  final Exercicio exercicio;
  final String? itemPlanoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todas = ref.watch(justificativasProvider).value;
    final justificativa = todas?[exercicio.padraoMovimento];
    final id = itemPlanoId;
    final noPlano = id == null
        ? null
        : ref.watch(itemPlanoProvider(id)).value?.justificativa;

    return _Cartao(
      titulo: 'POR QUE ESTE EXERCÍCIO',
      children: [
        if (noPlano != null) ...[
          Text(
            noPlano,
            style: Textos.corpo.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: Espacos.s),
        ],
        if (justificativa == null)
          const Text(
            'Sem justificativa para este movimento ainda.',
            style: Textos.secundario,
          )
        else ...[
          Text(justificativa.texto, style: Textos.corpo),
          const SizedBox(height: Espacos.m),
          Text('Fonte: ${justificativa.fonte}', style: Textos.secundario),
          const SizedBox(height: Espacos.xs),
          Text(
            'EVIDÊNCIA ${justificativa.nivel.rotulo.toUpperCase()} · '
            '${justificativa.nivel.explicacao.toUpperCase()}',
            style: Textos.rotulo,
          ),
          if (!justificativa.revisado) ...[
            const SizedBox(height: Espacos.xs),
            Text(
              'RASCUNHO · FONTE AINDA NÃO REVISADA',
              style: Textos.rotulo.copyWith(color: Cores.atencao),
            ),
          ],
        ],
      ],
    );
  }
}

class _Substitutos extends ConsumerWidget {
  const _Substitutos({required this.exercicio, required this.itemPlanoId});

  final Exercicio exercicio;
  final String? itemPlanoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final substitutos = ref.watch(substitutosProvider(exercicio.id)).value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('SUBSTITUTOS', style: Textos.rotulo),
        const SizedBox(height: Espacos.xs),
        Text(
          'Mesmo movimento, outro equipamento. Use quando o aparelho estiver '
          'ocupado ou se este doer.',
          style: Textos.secundario,
        ),
        const SizedBox(height: Espacos.s),
        if (substitutos == null)
          const SizedBox(
            height: 56,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (substitutos.isEmpty)
          const Text(
            'Nenhum outro exercício do catálogo faz este movimento.',
            style: Textos.corpo,
          )
        else
          for (final s in substitutos)
            _LinhaSubstituto(
              exercicio: s,
              aoAbrir: () => context.push('/exercicio/${s.id}'),
              aoTrocar: itemPlanoId == null
                  ? null
                  : () => _trocarNoPlano(context, ref, s),
            ),
      ],
    );
  }

  Future<void> _trocarNoPlano(
    BuildContext context,
    WidgetRef ref,
    Exercicio novo,
  ) async {
    final id = itemPlanoId!;
    final item = await ref.read(planoRepositoryProvider).item(id);
    if (item == null || !context.mounted) return;
    final escolha = await abrirPainelOcupado(
      context,
      atual: exercicio,
      cargaAtual: item.cargaPlanKg,
      preEscolhido: novo,
      permitirSoHoje: false,
      titulo: 'TROCAR NO PLANO',
    );
    if (escolha == null || !context.mounted) return;
    final repositorio = ref.read(exercicioRepositoryProvider);
    final troca = await repositorio.trocarSempre(
      itemPlanoId: id,
      exercicioNovoId: escolha.novo.id,
      cargaKg: escolha.cargaKg,
    );
    if (!context.mounted) return;
    final mensageiro = ScaffoldMessenger.of(context);
    context.pop();
    mensageiro
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'No plano: ${escolha.novo.nome} no lugar de ${exercicio.nome}',
          ),
          duration: const Duration(seconds: 5),
          persist: false,
          action: SnackBarAction(
            label: 'Desfazer',
            textColor: Cores.brasa,
            onPressed: () => repositorio.desfazerTroca(troca),
          ),
        ),
      );
  }
}

class _LinhaSubstituto extends StatelessWidget {
  const _LinhaSubstituto({
    required this.exercicio,
    required this.aoAbrir,
    required this.aoTrocar,
  });

  final Exercicio exercicio;
  final VoidCallback aoAbrir;
  final VoidCallback? aoTrocar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacos.s),
      child: Material(
        color: Cores.ferro800,
        borderRadius: BorderRadius.circular(Raios.cartao),
        child: InkWell(
          borderRadius: BorderRadius.circular(Raios.cartao),
          onTap: aoAbrir,
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
                        '${nomeEquipamento(exercicio.equipamento)} · '
                        '${exercicio.musculosAlvo}',
                        style: Textos.secundario,
                      ),
                    ],
                  ),
                ),
                if (aoTrocar != null)
                  TextButton(onPressed: aoTrocar, child: const Text('Trocar'))
                else
                  const Icon(Icons.chevron_right, color: Cores.ferro400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
