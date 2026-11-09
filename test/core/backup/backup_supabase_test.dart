import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:treino_app/core/backup/backup_supabase.dart';

/// As frases do login por código (etapa 5).
void main() {
  String frase(String? code, String? status) =>
      mensagemDoErroDeLogin(AuthException('x', code: code, statusCode: status));

  test('os dois limites de envio têm frases diferentes', () {
    expect(
      frase('over_request_rate_limit', '429'),
      'Espere 1 minuto para pedir outro código.',
    );
    expect(
      frase('over_email_send_rate_limit', '429'),
      contains('máximo de e-mails desta hora'),
    );
    expect(frase(null, '429'), 'Muitas tentativas. Espere alguns minutos.');
  });

  test('código errado ou vencido pede outro', () {
    expect(
      frase('otp_expired', '403'),
      'Código inválido ou vencido. Peça outro.',
    );
    expect(frase(null, '400'), 'Código inválido ou vencido. Peça outro.');
  });

  test('e-mail mal digitado não fala em código', () {
    expect(frase('email_address_invalid', '400'), 'Confira o e-mail digitado.');
  });

  test('falha de rede vira "sem internet"', () {
    expect(
      mensagemDoErroDeLogin(AuthRetryableFetchException(message: 'x')),
      startsWith('Sem internet'),
    );
  });
}
