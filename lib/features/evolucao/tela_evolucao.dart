import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/db/repositorios/evolucao_repository.dart';
import '../../core/db/repositorios/plano_repository.dart';
import '../../core/formatacao.dart';
import '../../core/theme/tokens.dart';
import '../exercicio/exercicio_providers.dart';
import '../exercicio/grafico_evolucao.dart';

/// Aba Evolução: os exercícios do plano, dia por dia, com o último resultado
/// e o selo de recorde. Tocar abre a tela 03.
class TelaEvolucao extends ConsumerWidget {
  const TelaEvolucao({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessoes = ref.watch(sessoesDoPlanoProvider);
    final evolucoes = ref.watch(evolucoesProvider);

    return SafeArea(
      child: switch ((sessoes, evolucoes)) {
        (AsyncData(value: final s), AsyncData(value: final e)) => _Lista(
          sessoes: s,
          evolucoes: e,
        ),
        (AsyncError(:final error), _) ||
        (_, AsyncError(:final error)) => Center(
          child: Text('Erro ao carregar.\n$error', style: Textos.secundario),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Lista extends StatelessWidget {
  const _Lista({required this.sessoes, required this.evolucoes});

  final List<SessaoComItens> sessoes;
  final Map<String, Evolucao> evolucoes;

  @override
  Widget build(BuildContext context) {
    final agora = clock.now();
    final noPlano = <String>{};
    final secoes = <Widget>[];
    for (final sessao in sessoes) {
      secoes.add(
        Padding(
          padding: const EdgeInsets.only(top: Espacos.xl, bottom: Espacos.s),
          child: Text(
            'TREINO ${sessao.sessao.dia} · ${sessao.sessao.foco.toUpperCase()}',
            style: Textos.rotulo,
          ),
        ),
      );
      for (final item in sessao.itens) {
        final exercicio = item.exercicio;
        noPlano.add(exercicio.id);
        secoes.add(
          _LinhaEvolucao(
            exercicio: exercicio,
            evolucao: evolucoes[exercicio.id],
            agora: agora,
          ),
        );
      }
    }
    final outros =
        evolucoes.values
            .where((e) => !noPlano.contains(e.exercicio.id))
            .toList()
          ..sort((a, b) => a.exercicio.nome.compareTo(b.exercicio.nome));
    if (outros.isNotEmpty) {
      secoes.add(
        const Padding(
          padding: EdgeInsets.only(top: Espacos.xl, bottom: Espacos.s),
          child: Text('FORA DO PLANO ATUAL', style: Textos.rotulo),
        ),
      );
      for (final e in outros) {
        secoes.add(
          _LinhaEvolucao(exercicio: e.exercicio, evolucao: e, agora: agora),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Espacos.l,
        Espacos.l,
        Espacos.l,
        Espacos.xl,
      ),
      children: [
        Semantics(
          header: true,
          child: const Text('Evolução', style: Textos.titulo),
        ),
        const SizedBox(height: Espacos.xs),
        const Text(
          'Último resultado de cada exercício. Nos exercícios com carga, é o '
          '1RM estimado da melhor série do treino.',
          style: Textos.secundario,
        ),
        ...secoes,
      ],
    );
  }
}

class _LinhaEvolucao extends StatelessWidget {
  const _LinhaEvolucao({
    required this.exercicio,
    required this.evolucao,
    required this.agora,
  });

  final Exercicio exercicio;
  final Evolucao? evolucao;
  final DateTime agora;

  @override
  Widget build(BuildContext context) {
    final e = evolucao;
    final ultimo = e?.ultimo;
    final metrica = MetricaEvolucao.de(exercicio);

    String detalhe;
    if (e == null || ultimo == null) {
      detalhe = 'Sem registros';
    } else {
      final janela = e.ultimasSemanas(agora);
      detalhe = 'Último treino ${formatarData(ultimo.data)}';
      if (janela.length >= 2) {
        final diferenca = janela.last.valor - janela.first.valor;
        if (diferenca.abs() >= 0.5) {
          final valor = metrica == MetricaEvolucao.umRm
              ? '${formatarUmRm(diferenca.abs())} kg'
              : '${diferenca.abs().round()}';
          detalhe += ' · ${diferenca > 0 ? '+' : '−'}$valor em 8 sem.';
        }
      }
    }

    final valor = ultimo == null
        ? null
        : formatarValorEvolucao(ultimo.valor, metrica);
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacos.s),
      child: Semantics(
        button: true,
        label:
            '${exercicio.nome}. ${valor ?? 'Sem registros'}'
            '${ultimo?.recorde ?? false ? ', recorde' : ''}. $detalhe',
        excludeSemantics: true,
        child: Material(
          color: Cores.ferro800,
          borderRadius: BorderRadius.circular(Raios.cartao),
          child: InkWell(
            borderRadius: BorderRadius.circular(Raios.cartao),
            onTap: () => context.push('/exercicio/${exercicio.id}'),
            child: Padding(
              padding: const EdgeInsets.all(Espacos.l),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercicio.nome, style: Textos.nome),
                        const SizedBox(height: Espacos.xs),
                        Text(detalhe, style: Textos.secundario),
                      ],
                    ),
                  ),
                  const SizedBox(width: Espacos.m),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (valor != null)
                        Text(
                          valor,
                          style: Textos.numeroLista.copyWith(fontSize: 22),
                        ),
                      if (ultimo?.recorde ?? false) ...[
                        const SizedBox(height: Espacos.xs),
                        Text(
                          'RECORDE',
                          style: Textos.rotulo.copyWith(color: Cores.avanco),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
