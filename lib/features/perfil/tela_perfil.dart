import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import '../../core/marca.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/icone_caramelo.dart';
import '../progressao/progressao.dart';

final preferenciasProvider = StreamProvider.autoDispose<Preferencia>(
  (ref) => ref.watch(preferenciasRepositoryProvider).watch(),
);

/// Aba Perfil: por enquanto, as preferências de treino. O backup entra na
/// etapa 5.
class TelaPerfil extends ConsumerWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencias = ref.watch(preferenciasProvider);
    final repositorio = ref.read(preferenciasRepositoryProvider);

    return SafeArea(
      child: preferencias.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (erro, _) => Center(child: Text('$erro')),
        data: (p) {
          final modo = ModoNovoZero.de(p.modoNovoZero);
          return ListView(
            padding: const EdgeInsets.all(Espacos.l),
            children: [
              // O Caramelo como avatar; o título já diz "Perfil" ao leitor
              // de tela, então o ícone é decorativo.
              const Row(
                children: [
                  IconeCaramelo(tamanho: 48),
                  SizedBox(width: Espacos.m),
                  Text('Perfil', style: Textos.titulo),
                ],
              ),
              const SizedBox(height: Espacos.xl),
              const Text('PREFERÊNCIAS DE TREINO', style: Textos.rotulo),
              const SizedBox(height: Espacos.s),
              Card(
                child: SwitchListTile(
                  value: p.sugestaoCargaMenor,
                  onChanged: (v) => repositorio.salvar(sugestaoCargaMenor: v),
                  activeThumbColor: Cores.brasa,
                  title: const Text(
                    'Sugerir carga menor na próxima série',
                    style: Textos.nome,
                  ),
                  subtitle: const Text(
                    'Quando faltam 2 ou mais reps do mínimo da faixa, ou a '
                    'série foi "No limite". Dá para manter a carga na hora.',
                    style: Textos.secundario,
                  ),
                ),
              ),
              const SizedBox(height: Espacos.l),
              const Text(
                'NOVO PONTO DE PARTIDA DEPOIS DO PR',
                style: Textos.rotulo,
              ),
              const SizedBox(height: Espacos.s),
              Card(
                child: RadioGroup<ModoNovoZero>(
                  groupValue: modo,
                  onChanged: (m) {
                    if (m != null) repositorio.salvar(modoNovoZero: m.valor);
                  },
                  child: const Column(
                    children: [
                      _OpcaoModo(
                        modo: ModoNovoZero.umRm,
                        titulo: 'Converter pelo 1RM',
                        descricao:
                            'Calcula a carga para as reps do plano com a força '
                            'do PR. Ex.: 80 kg × 5 → 72,5 kg × 8.',
                      ),
                      _OpcaoModo(
                        modo: ModoNovoZero.direto,
                        titulo: 'Usar o peso do PR direto',
                        descricao:
                            'As séries normais passam a usar o peso do PR. '
                            'É um salto maior.',
                      ),
                      _OpcaoModo(
                        modo: ModoNovoZero.perguntar,
                        titulo: 'Perguntar a cada vez',
                        descricao:
                            'Mostra as duas opções quando o PR é batido.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Espacos.xl),
              const Text('BACKUP', style: Textos.rotulo),
              const SizedBox(height: Espacos.s),
              const Text(
                'Login e backup no Supabase chegam na etapa 5. Por enquanto '
                'tudo fica só neste aparelho.',
                style: Textos.secundario,
              ),
              const SizedBox(height: Espacos.xl),
              const _Sobre(),
            ],
          );
        },
      ),
    );
  }
}

/// Perfil → Sobre: o logo Caramelo Mutante, a versão e o conceito.
class _Sobre extends StatelessWidget {
  const _Sobre();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('SOBRE', style: Textos.rotulo),
        const SizedBox(height: Espacos.l),
        Center(
          child: Image.asset(
            Marca.logoVertical,
            width: 180,
            semanticLabel: Marca.nome,
          ),
        ),
        const SizedBox(height: Espacos.l),
        const Text(
          '${Marca.conceito}\nVERSÃO ${Marca.versao}',
          textAlign: TextAlign.center,
          style: Textos.rotulo,
        ),
        const SizedBox(height: Espacos.xl),
      ],
    );
  }
}

class _OpcaoModo extends StatelessWidget {
  const _OpcaoModo({
    required this.modo,
    required this.titulo,
    required this.descricao,
  });

  final ModoNovoZero modo;
  final String titulo;
  final String descricao;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ModoNovoZero>(
      value: modo,
      activeColor: Cores.brasa,
      title: Text(titulo, style: Textos.nome),
      subtitle: Text(descricao, style: Textos.secundario),
    );
  }
}
