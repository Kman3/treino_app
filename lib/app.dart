import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/barra_inferior.dart';
import 'core/widgets/tela_em_construcao.dart';
import 'features/hoje/tela_hoje.dart';

GoRouter criarRouter() {
  return GoRouter(
    initialLocation: '/treino',
    routes: [
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
                builder: (_, _) => const TelaEmConstrucao(
                  titulo: 'Evolução',
                  etapa: 'etapa 4',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/perfil',
                builder: (_, _) =>
                    const TelaEmConstrucao(titulo: 'Perfil', etapa: 'etapa 5'),
              ),
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
      title: 'Treino',
      debugShowCheckedModeBanner: false,
      theme: temaFerroGiz(),
      routerConfig: _router,
    );
  }
}
