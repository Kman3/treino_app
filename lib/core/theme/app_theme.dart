import 'package:flutter/material.dart';

import 'tokens.dart';

/// Tema escuro único do app, com a brasa como destaque da ação do momento.
ThemeData temaFerroGiz() {
  const esquema = ColorScheme.dark(
    primary: Cores.brasa,
    // Texto escuro sobre a brasa tem contraste AA; branco não teria.
    onPrimary: Cores.ferro900,
    secondary: Cores.avanco,
    onSecondary: Cores.ferro900,
    error: Cores.dor,
    onError: Cores.ferro900,
    surface: Cores.ferro900,
    onSurface: Cores.giz,
    surfaceContainer: Cores.ferro800,
    surfaceContainerHigh: Cores.ferro700,
    onSurfaceVariant: Cores.ferro400,
    outline: Cores.ferro700,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: Cores.ferro900,
    fontFamily: Fontes.instrumentSans,
    textTheme: const TextTheme(
      displayLarge: Textos.numeroSerie,
      displayMedium: Textos.numeroTimer,
      headlineLarge: Textos.titulo,
      titleMedium: Textos.nome,
      bodyMedium: Textos.corpo,
      bodySmall: Textos.secundario,
      labelLarge: Textos.botao,
      labelSmall: Textos.rotulo,
    ),
    cardTheme: const CardThemeData(
      color: Cores.ferro800,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Raios.cartao)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Cores.ferro700, thickness: 1),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Cores.ferro700,
      contentTextStyle: Textos.corpo,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Raios.botao)),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Cores.brasa,
    ),
  );
}
