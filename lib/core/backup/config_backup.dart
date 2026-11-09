/// URL e chave pública do Supabase, passadas na compilação:
/// `flutter build apk --dart-define-from-file=.env`.
///
/// O `.env` fica fora do Git (veja `.env.example`). Sem ele, o app funciona
/// normalmente e o Perfil avisa que o backup não está disponível nesta versão.
abstract final class ConfigBackup {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const chavePublica = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static bool get configurado => url.isNotEmpty && chavePublica.isNotEmpty;
}
