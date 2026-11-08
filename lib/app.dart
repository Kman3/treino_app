import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/marca.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/barra_inferior.dart';
import 'features/evolucao/tela_evolucao.dart';
import 'features/execucao/tela_resumo.dart';
import 'features/execucao/tela_serie.dart';
import 'features/exercicio/tela_exercicio.dart';
import 'features/hoje/tela_hoje.dart';
import 'features/perfil/tela_perfil.dart';

GoRouter criarRouter() {
  return GoRouter(
    initialLocation: '/treino',
    routes: [
      // Fora do shell: durante o treino a barra inferior some.
      GoRoute(
        path: '/execucao/:treinoId',
        builder: (_, state) =>
            TelaSerie(treinoId: state.pathParameters['treinoId']!),
      ),
      GoRoute(
        path: '/resumo/:treinoId',
        builder: (_, state) =>
            TelaResumo(treinoId: state.pathParameters['treinoId']!),
      ),
      // Tela 03, por cima de qualquer aba; `?item=` quando vem do plano.
      GoRoute(
        path: '/exercicio/:exercicioId',
        builder: (_, state) => TelaExercicio(
          exercicioId: state.pathParameters['exercicioId']!,
          itemPlanoId: state.uri.queryParameters['item'],
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navegacao) => Scaffold(
          body: navegacao,
          bottomNavigationBar: BarraInferior(
            indiceAtual: navegacao.currentIndex,
            aoSelecionar: (indice) => navegacao.goBranch(
              indice,
              initialLocation: indice == navegacao.currentIndex,
            ),
          ),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/treino', builder: (_, _) => const TelaHoje()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/evolucao',
                builder: (_, _) => const TelaEvolucao(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/perfil', builder: (_, _) => const TelaPerfil()),
            ],
          ),
        ],
      ),
    ],
  );
}

class TreinoApp extends StatefulWidget {
  const TreinoApp({super.key});

  @override
  State<TreinoApp> createState() => _TreinoAppState();
}

class _TreinoAppState extends State<TreinoApp> {
  late final _router = criarRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Nome que o Android mostra na lista de apps abertos.
      title: Marca.nome,
      debugShowCheckedModeBanner: false,
      theme: temaFerroGiz(),
      routerConfig: _router,
    );
  }
}
