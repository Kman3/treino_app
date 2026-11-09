import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/providers.dart';
import 'backup_nuvem.dart';
import 'sync_service.dart';

/// Nulo quando esta versão do app não tem a configuração do Supabase (testes e
/// builds sem `.env`). Substituído em `main.dart`.
final backupNuvemProvider = Provider<BackupNuvem?>((ref) => null);

/// A conta conectada ao backup, ou nulo.
final contaBackupProvider = StreamProvider<ContaAtual?>((ref) {
  final nuvem = ref.watch(backupNuvemProvider);
  return nuvem == null ? Stream.value(null) : nuvem.mudancasDeConta;
});

/// Alterações esperando para subir; atualiza a cada gravação no banco.
final pendentesBackupProvider = StreamProvider.autoDispose<int>((ref) {
  final db = ref.watch(databaseProvider);
  final nuvem = ref.watch(backupNuvemProvider);
  if (nuvem == null) return Stream.value(0);
  final servico = SyncService(db, nuvem);
  return db
      .quandoMudar('backup_pendentes', {
        db.planosTreino,
        db.sessoesPlano,
        db.itensPlano,
        db.treinos,
        db.series,
        db.substituicoes,
        db.ajustesExecucao,
        db.preferencias,
        db.estadosSync,
      })
      .asyncMap((_) => servico.pendentes());
});

class EstadoBackup {
  const EstadoBackup({this.sincronizando = false, this.ultimo, this.erro});

  final bool sincronizando;

  /// Quando o último backup terminou bem.
  final DateTime? ultimo;

  /// Frase do último erro, até a próxima tentativa.
  final String? erro;

  EstadoBackup copyWith({
    bool? sincronizando,
    DateTime? ultimo,
    String? erro,
    bool limparErro = false,
  }) => EstadoBackup(
    sincronizando: sincronizando ?? this.sincronizando,
    ultimo: ultimo ?? this.ultimo,
    erro: limparErro ? null : (erro ?? this.erro),
  );
}

/// Dispara o sync (ao abrir o app, ao voltar para ele, ao finalizar um treino
/// e pelo botão do Perfil) e guarda o estado para a tela.
class BackupController extends Notifier<EstadoBackup> {
  @override
  EstadoBackup build() {
    unawaited(_lerUltimo());
    return const EstadoBackup();
  }

  SyncService? _servico() {
    final nuvem = ref.read(backupNuvemProvider);
    return nuvem == null
        ? null
        : SyncService(ref.read(databaseProvider), nuvem);
  }

  Future<void> _lerUltimo() async {
    final ultimo = await _servico()?.ultimoBackup();
    if (ultimo != null) state = state.copyWith(ultimo: ultimo);
  }

  /// Sobe e desce o que mudou. Sem configuração ou sem conta, não faz nada.
  Future<void> sincronizar() async {
    final conta = ref.read(backupNuvemProvider)?.conta;
    final servico = _servico();
    if (servico == null || conta == null || state.sincronizando) return;
    state = state.copyWith(sincronizando: true, limparErro: true);
    try {
      final resultado = await servico.sincronizar(usuarioId: conta.id);
      state = state.copyWith(ultimo: resultado.quando);
    } on ErroBackup catch (e) {
      state = state.copyWith(erro: e.mensagem);
    } on Exception catch (e) {
      state = state.copyWith(erro: 'O backup falhou: $e');
    } finally {
      state = state.copyWith(sincronizando: false);
    }
  }

  /// Sai da conta. Os treinos ficam no aparelho; tudo volta a "nunca
  /// enviado" para a próxima conta.
  Future<void> sair() async {
    final nuvem = ref.read(backupNuvemProvider);
    if (nuvem == null) return;
    await nuvem.sair();
    await _servico()!.esquecerConta();
    state = const EstadoBackup();
  }
}

final backupControllerProvider =
    NotifierProvider<BackupController, EstadoBackup>(BackupController.new);
