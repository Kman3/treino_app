import 'package:flutter/painting.dart';

/// Tokens do tema Ferro & Giz (seção 7 do PRD do módulo Treino).
abstract final class Cores {
  /// Fundo das telas.
  static const ferro900 = Color(0xFF0E0F11);

  /// Cartões e painel inferior.
  static const ferro800 = Color(0xFF191B1F);

  /// Botões −/+, chips, divisórias.
  static const ferro700 = Color(0xFF23262B);

  /// Rótulos e texto secundário. Clareado na etapa 4 (era #878C93) para
  /// passar em AA (4,5:1) também sobre o Ferro 700.
  static const ferro400 = Color(0xFF8B8F96);

  /// Texto principal e números.
  static const giz = Color(0xFFEDEAE3);

  /// Ação principal, série atual, progresso do timer.
  static const brasa = Color(0xFFFF5A1F);

  /// Recorde, "igual ao plano", carga acima da última vez.
  static const avanco = Color(0xFF46D39A);

  /// Valor editado, diferença vs. plano, sugestão de ajuste.
  static const atencao = Color(0xFFF2B33D);

  /// Registro de dor e excluir. Clareado na etapa 4 (era #E5484D) para passar
  /// em AA sobre o Ferro 800 e o Ferro 700.
  static const dor = Color(0xFFE96569);
}

abstract final class Raios {
  static const botao = 12.0;
  static const cartao = 14.0;
  static const painel = 26.0;
}

/// Grade de 8 pt.
abstract final class Espacos {
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 12.0;
  static const l = 16.0;
  static const xl = 24.0;
}

/// Famílias de fonte embarcadas. Enquanto uma família não estiver declarada em
/// `pubspec.yaml`, o Flutter usa a fonte padrão do sistema no lugar dela.
abstract final class Fontes {
  static const bigShoulders = 'BigShoulders';
  static const instrumentSans = 'InstrumentSans';
  static const geistMono = 'GeistMono';
}

abstract final class Textos {
  /// Carga e reps na tela 02A.
  static const numeroSerie = TextStyle(
    fontFamily: Fontes.bigShoulders,
    fontWeight: FontWeight.w700,
    fontSize: 96,
    height: 1,
    color: Cores.giz,
  );

  /// Tempo no timer de descanso.
  static const numeroTimer = TextStyle(
    fontFamily: Fontes.bigShoulders,
    fontWeight: FontWeight.w700,
    fontSize: 64,
    height: 1,
    color: Cores.giz,
  );

  /// Números menores, como a carga planejada na lista do dia.
  static const numeroLista = TextStyle(
    fontFamily: Fontes.bigShoulders,
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 1,
    color: Cores.giz,
  );

  static const titulo = TextStyle(
    fontFamily: Fontes.bigShoulders,
    fontWeight: FontWeight.w700,
    fontSize: 44,
    height: 1.05,
    color: Cores.giz,
  );

  static const nome = TextStyle(
    fontFamily: Fontes.instrumentSans,
    fontWeight: FontWeight.w600,
    fontSize: 17,
    color: Cores.giz,
  );

  static const corpo = TextStyle(
    fontFamily: Fontes.instrumentSans,
    fontSize: 15,
    height: 1.35,
    color: Cores.giz,
  );

  static const secundario = TextStyle(
    fontFamily: Fontes.instrumentSans,
    fontSize: 13,
    height: 1.35,
    color: Cores.ferro400,
  );

  static const botao = TextStyle(
    fontFamily: Fontes.instrumentSans,
    fontWeight: FontWeight.w600,
    fontSize: 17,
  );

  /// Rótulos em maiúsculas espaçadas. Escreva o texto já em maiúsculas.
  static const rotulo = TextStyle(
    fontFamily: Fontes.geistMono,
    fontWeight: FontWeight.w500,
    fontSize: 11,
    letterSpacing: 1.4,
    color: Cores.ferro400,
  );
}
