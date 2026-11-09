import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/backup/backup_controller.dart';
import '../../core/backup/backup_nuvem.dart';
import '../../core/formatacao.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/botao_brasa.dart';

/// Perfil → Backup: entrar com o e-mail (código de 6 dígitos) e, depois, o
/// estado do backup com "Sincronizar agora". Sem login, o app segue normal.
class SecaoBackup extends ConsumerWidget {
  const SecaoBackup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(backupNuvemProvider) == null) {
      return const Text(
        'O backup não está configurado nesta versão do app. Tudo fica só '
        'neste aparelho.',
        style: Textos.secundario,
      );
    }
    final conta = ref.watch(contaBackupProvider).value;
    return conta == null ? const _Entrar() : _Conectado(conta: conta);
  }
}

class _Entrar extends ConsumerStatefulWidget {
  const _Entrar();

  @override
  ConsumerState<_Entrar> createState() => _EntrarState();
}

class _EntrarState extends ConsumerState<_Entrar> {
  final _email = TextEditingController();
  final _codigo = TextEditingController();
  String? _codigoEnviadoPara;
  bool _ocupado = false;
  String? _erro;

  @override
  void dispose() {
    _email.dispose();
    _codigo.dispose();
    super.dispose();
  }

  Future<void> _tentar(Future<void> Function(BackupNuvem nuvem) acao) async {
    final nuvem = ref.read(backupNuvemProvider)!;
    setState(() {
      _ocupado = true;
      _erro = null;
    });
    try {
      await acao(nuvem);
    } on ErroBackup catch (e) {
      if (mounted) setState(() => _erro = e.mensagem);
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _enviarCodigo() async {
    final email = _email.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      setState(() => _erro = 'Confira o e-mail.');
      return;
    }
    await _tentar((nuvem) async {
      await nuvem.enviarCodigo(email);
      if (mounted) setState(() => _codigoEnviadoPara = email);
    });
  }

  Future<void> _entrar() async {
    final codigo = _codigo.text.trim();
    if (codigo.length != 6) {
      setState(() => _erro = 'O código tem 6 dígitos.');
      return;
    }
    await _tentar((nuvem) async {
      await nuvem.entrar(email: _codigoEnviadoPara!, codigo: codigo);
      // Primeiro backup logo depois de entrar.
      await ref.read(backupControllerProvider.notifier).sincronizar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final enviado = _codigoEnviadoPara;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          enviado == null
              ? 'Entre com seu e-mail para guardar os treinos na nuvem e '
                    'recuperá-los em outro celular. Sem conta, tudo continua '
                    'funcionando neste aparelho.'
              : 'Enviamos um código de 6 dígitos para $enviado.',
          style: Textos.secundario,
        ),
        const SizedBox(height: Espacos.m),
        if (enviado == null)
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _enviarCodigo(),
            style: Textos.corpo,
            decoration: const InputDecoration(labelText: 'E-mail'),
          )
        else
          TextField(
            controller: _codigo,
            keyboardType: TextInputType.number,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _entrar(),
            style: Textos.numeroLista.copyWith(letterSpacing: 6),
            decoration: const InputDecoration(labelText: 'Código'),
          ),
        if (_erro case final erro?) ...[
          const SizedBox(height: Espacos.s),
          Text(erro, style: Textos.secundario.copyWith(color: Cores.dor)),
        ],
        const SizedBox(height: Espacos.m),
        BotaoBrasa(
          rotulo: enviado == null ? 'Enviar código' : 'Entrar',
          variante: VarianteBotao.secundario,
          carregando: _ocupado,
          onPressed: enviado == null ? _enviarCodigo : _entrar,
        ),
        if (enviado != null)
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: _ocupado
                  ? null
                  : () => setState(() {
                      _codigoEnviadoPara = null;
                      _codigo.clear();
                      _erro = null;
                    }),
              child: const Text('Usar outro e-mail'),
            ),
          ),
      ],
    );
  }
}

class _Conectado extends ConsumerWidget {
  const _Conectado({required this.conta});

  final ContaAtual conta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(backupControllerProvider);
    final pendentes = ref.watch(pendentesBackupProvider).value ?? 0;
    final ultimo = estado.ultimo;

    final (String situacao, Color cor) = switch (estado) {
      EstadoBackup(sincronizando: true) => ('Sincronizando…', Cores.giz),
      EstadoBackup(:final erro?) => (erro, Cores.dor),
      _ when ultimo == null => ('Ainda não fez backup.', Cores.ferro400),
      _ when pendentes == 0 => ('Tudo salvo na nuvem.', Cores.avanco),
      _ => (
        pendentes == 1
            ? '1 alteração esperando o próximo backup.'
            : '$pendentes alterações esperando o próximo backup.',
        Cores.atencao,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(Espacos.l),
      decoration: BoxDecoration(
        color: Cores.ferro800,
        borderRadius: BorderRadius.circular(Raios.cartao),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Conectado como ${conta.email}', style: Textos.nome),
          const SizedBox(height: Espacos.xs),
          Text(situacao, style: Textos.secundario.copyWith(color: cor)),
          if (ultimo != null)
            Text(
              'Último backup: ${formatarMomento(ultimo, clock.now())}',
              style: Textos.secundario,
            ),
          const SizedBox(height: Espacos.m),
          BotaoBrasa(
            rotulo: 'Sincronizar agora',
            variante: VarianteBotao.secundario,
            carregando: estado.sincronizando,
            onPressed: () =>
                ref.read(backupControllerProvider.notifier).sincronizar(),
          ),
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: estado.sincronizando
                  ? null
                  : () => _confirmarSaida(context, ref),
              child: const Text('Sair da conta'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarSaida(BuildContext context, WidgetRef ref) async {
    final sair = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Cores.ferro800,
        title: const Text('Sair da conta?', style: Textos.nome),
        content: const Text(
          'Os treinos continuam neste celular. O backup para até você entrar '
          'de novo.',
          style: Textos.corpo,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (sair == true) await ref.read(backupControllerProvider.notifier).sair();
  }
}
