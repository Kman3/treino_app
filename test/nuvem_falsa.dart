import 'dart:async';
import 'dart:convert';

import 'package:treino_app/core/backup/backup_nuvem.dart';

/// Nuvem em memória, no lugar do Supabase. As linhas passam por JSON, como na
/// rede, e cada conta só vê as próprias (o papel da RLS).
class NuvemFalsa implements BackupNuvem {
  // Parâmetro nomeado não pode ser privado (`this._conta`).
  // ignore: prefer_initializing_formals
  NuvemFalsa({ContaAtual? conta}) : _conta = conta;

  static const codigoCerto = '123456';

  /// tabela → "usuario_id|id" → linha.
  final dados = <String, Map<String, Map<String, Object?>>>{};
  final _mudancas = StreamController<ContaAtual?>.broadcast();
  ContaAtual? _conta;

  String? codigoEnviadoPara;
  bool semInternet = false;
  int envios = 0;

  @override
  ContaAtual? get conta => _conta;

  @override
  Stream<ContaAtual?> get mudancasDeConta async* {
    yield _conta;
    yield* _mudancas.stream;
  }

  @override
  Future<void> enviarCodigo(String email) async {
    _rede();
    codigoEnviadoPara = email;
  }

  @override
  Future<void> entrar({required String email, required String codigo}) async {
    _rede();
    if (codigo != codigoCerto) {
      throw const ErroBackup('Código inválido ou vencido. Peça outro.');
    }
    _conta = ContaAtual(id: 'conta-$email', email: email);
    _mudancas.add(_conta);
  }

  @override
  Future<void> sair() async {
    _conta = null;
    _mudancas.add(null);
  }

  @override
  Future<void> enviar(String tabela, List<Map<String, Object?>> linhas) async {
    _rede();
    envios++;
    final porId = dados.putIfAbsent(tabela, () => {});
    for (final linha in linhas) {
      final copia = jsonDecode(jsonEncode(linha)) as Map<String, Object?>;
      porId['${copia['usuario_id']}|${copia['id']}'] = copia;
    }
  }

  @override
  Future<List<Map<String, Object?>>> baixar(
    String tabela, {
    DateTime? desde,
  }) async {
    _rede();
    final dono = _conta?.id;
    final linhas = (dados[tabela]?.values ?? const <Map<String, Object?>>[])
        .where((l) => l['usuario_id'] == dono)
        .where(
          (l) =>
              desde == null ||
              DateTime.parse(l['atualizado_em']! as String).isAfter(desde),
        )
        .map((l) => jsonDecode(jsonEncode(l)) as Map<String, Object?>)
        .toList();
    linhas.sort(
      (a, b) =>
          DateTime.parse(a['atualizado_em']! as String)
              .compareTo(DateTime.parse(b['atualizado_em']! as String)),
    );
    return linhas;
  }

  /// Uma linha gravada por outro aparelho da mesma conta.
  void gravarDireto(String tabela, Map<String, Object?> linha) {
    dados.putIfAbsent(
      tabela,
      () => {},
    )['${linha['usuario_id']}|${linha['id']}'] = linha;
  }

  Map<String, Object?>? linha(String tabela, String id) =>
      dados[tabela]?['${_conta?.id}|$id'];

  int contar(String tabela) => dados[tabela]?.length ?? 0;

  void _rede() {
    if (semInternet) {
      throw const ErroBackup(
        'Sem internet. O backup tenta de novo quando o app abrir.',
      );
    }
  }
}
