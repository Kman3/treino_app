import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'backup_nuvem.dart';

/// Frase para a tela a partir do erro do Supabase Auth. O código do erro vem
/// antes do status HTTP: os dois limites de envio respondem 429, mas pedem
/// esperas bem diferentes.
String mensagemDoErroDeLogin(AuthException e) {
  if (e is AuthRetryableFetchException) {
    return 'Sem internet. Confira a conexão e tente de novo.';
  }
  return switch (e.code) {
    'over_request_rate_limit' => 'Espere 1 minuto para pedir outro código.',
    'over_email_send_rate_limit' =>
      'O servidor já mandou o máximo de e-mails desta hora. '
          'Tente de novo mais tarde.',
    'otp_expired' => 'Código inválido ou vencido. Peça outro.',
    'email_address_invalid' ||
    'validation_failed' => 'Confira o e-mail digitado.',
    'otp_disabled' || 'signup_disabled' || 'email_provider_disabled' =>
      'O login por e-mail está desligado no servidor.',
    _ => switch (e.statusCode) {
      '400' || '401' || '403' => 'Código inválido ou vencido. Peça outro.',
      '429' => 'Muitas tentativas. Espere alguns minutos.',
      _ => 'Não foi possível entrar: ${e.message}',
    },
  };
}

/// O backup no Supabase: Auth com código por e-mail e as tabelas com RLS
/// (`usuario_id = auth.uid()`), criadas em `supabase/migrations/`.
class BackupSupabase implements BackupNuvem {
  BackupSupabase(this._cliente);

  final SupabaseClient _cliente;

  /// O PostgREST devolve no máximo 1000 linhas por pedido.
  static const _pagina = 1000;

  @override
  ContaAtual? get conta => _conta(_cliente.auth.currentUser);

  ContaAtual? _conta(User? usuario) => usuario == null
      ? null
      : ContaAtual(id: usuario.id, email: usuario.email ?? '');

  @override
  Stream<ContaAtual?> get mudancasDeConta async* {
    yield conta;
    yield* _cliente.auth.onAuthStateChange.map((e) => _conta(e.session?.user));
  }

  @override
  Future<void> enviarCodigo(String email) => _traduzir(
    () => _cliente.auth.signInWithOtp(email: email, shouldCreateUser: true),
  );

  @override
  Future<void> entrar({required String email, required String codigo}) =>
      _traduzir(
        () => _cliente.auth.verifyOTP(
          email: email,
          token: codigo,
          type: OtpType.email,
        ),
      );

  @override
  Future<void> sair() => _traduzir(() => _cliente.auth.signOut());

  @override
  Future<void> enviar(String tabela, List<Map<String, Object?>> linhas) =>
      _traduzir(
        () => _cliente.from(tabela).upsert(linhas, onConflict: 'usuario_id,id'),
      );

  @override
  Future<List<Map<String, Object?>>> baixar(String tabela, {DateTime? desde}) {
    return _traduzir(() async {
      final todas = <Map<String, Object?>>[];
      for (var inicio = 0; ; inicio += _pagina) {
        var consulta = _cliente.from(tabela).select();
        if (desde != null) {
          consulta = consulta.gt(
            'atualizado_em',
            desde.toUtc().toIso8601String(),
          );
        }
        final pagina = await consulta
            .order('atualizado_em')
            .order('id')
            .range(inicio, inicio + _pagina - 1);
        todas.addAll(pagina);
        if (pagina.length < _pagina) return todas;
      }
    });
  }

  /// Troca as exceções do Supabase e da rede por uma frase para a tela.
  Future<T> _traduzir<T>(Future<T> Function() acao) async {
    try {
      return await acao();
    } on AuthException catch (e) {
      throw ErroBackup(mensagemDoErroDeLogin(e));
    } on PostgrestException catch (e) {
      throw ErroBackup('O servidor recusou o backup (${e.code ?? e.message}).');
    } on Exception catch (e) {
      final texto = e.toString();
      if (texto.contains('SocketException') ||
          texto.contains('ClientException') ||
          texto.contains('Failed host lookup')) {
        throw const ErroBackup(
          'Sem internet. O backup tenta de novo quando o app abrir.',
        );
      }
      rethrow;
    }
  }
}
