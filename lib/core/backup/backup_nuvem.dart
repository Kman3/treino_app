/// Quem está conectado ao backup neste aparelho.
class ContaAtual {
  const ContaAtual({required this.id, required this.email});

  /// `auth.uid()` no Supabase: o dono das linhas no backup.
  final String id;
  final String email;
}

/// A nuvem do backup: conta (login por e-mail com código) e as tabelas.
///
/// No app é o Supabase ([BackupSupabase]); nos testes, uma nuvem em memória.
abstract interface class BackupNuvem {
  ContaAtual? get conta;

  /// Emite a conta atual ao ouvir e de novo a cada entrada ou saída.
  Stream<ContaAtual?> get mudancasDeConta;

  /// Envia um código de 6 dígitos para [email] (cria a conta na primeira vez).
  Future<void> enviarCodigo(String email);

  /// Confere o código e conecta a conta.
  Future<void> entrar({required String email, required String codigo});

  Future<void> sair();

  /// Grava as linhas (já com `usuario_id`), trocando as de mesmo id.
  Future<void> enviar(String tabela, List<Map<String, Object?>> linhas);

  /// Linhas da conta com `atualizado_em` depois de [desde] (todas sem ele),
  /// da mais antiga para a mais nova.
  Future<List<Map<String, Object?>>> baixar(String tabela, {DateTime? desde});
}

/// Erro com uma frase pronta para a tela.
class ErroBackup implements Exception {
  const ErroBackup(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}
