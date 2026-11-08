/// Identidade Caramelo Mutante (template "Ferro Vivo", 08/11/2026).
abstract final class Marca {
  /// Nome completo: dentro do app e nas Configurações do Android.
  static const nome = 'Caramelo Mutante';

  /// Embaixo do ícone na tela inicial, onde o nome completo seria cortado.
  static const nomeCurto = 'Caramelo';

  /// A frase do conceito "Ferro Vivo".
  static const conceito =
      'Uma forma viva, construída com a disciplina do ferro.';

  /// Mantida igual à `version` do pubspec.yaml (um teste confere).
  static const versao = '0.4.0';

  /// O ícone do app (256 px), usado na aba Perfil e no avatar do Perfil.
  static const icone = 'assets/marca/icone-app.png';

  static const logoVertical = 'assets/marca/logo-vertical-fundo-escuro.png';
  static const logoHorizontal = 'assets/marca/logo-horizontal-fundo-escuro.png';
}
