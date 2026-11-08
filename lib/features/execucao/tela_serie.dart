import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/db/repositorios/plano_repository.dart';
import '../../core/formatacao.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/botao_brasa.dart';
import '../progressao/progressao.dart';
import 'estado_execucao.dart';
import 'painel_alterar.dart';
import 'sessao_treino_controller.dart';

/// Tela 02A Série: carga × reps planejadas em destaque e registro em 1 toque.
class TelaSerie extends ConsumerStatefulWidget {
  const TelaSerie({super.key, required this.treinoId});

  final String treinoId;

  @override
  ConsumerState<TelaSerie> createState() => _TelaSerieState();
}

class _TelaSerieState extends ConsumerState<TelaSerie> {
  /// Valores alterados pelo "✎ Alterar" antes de registrar, e a série a que
  /// eles pertencem (ficam sem efeito quando a série ou o plano dela muda).
  ValoresSerie? _alterados;
  String? _chaveAlterados;
  bool _registrando = false;

  SessaoTreinoController get _controller =>
      ref.read(sessaoTreinoControllerProvider);

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(estadoExecucaoProvider(widget.treinoId));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmarPausa();
      },
      child: Scaffold(
        body: SafeArea(
          child: estado.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (erro, _) => Center(
              child: Text(
                'Erro ao carregar o treino.\n$erro',
                style: Textos.secundario,
              ),
            ),
            data: (e) {
              if (e == null) {
                return const Center(
                  child: Text(
                    'Treino não encontrado.',
                    style: Textos.secundario,
                  ),
                );
              }
              final posicao = e.atual;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Cabecalho(
                    estado: e,
                    aoPausar: _confirmarPausa,
                    aoEncerrar: () => _confirmarEncerrar(e),
                  ),
                  Expanded(
                    child: posicao == null
                        ? _Completo(estado: e)
                        : _conteudoSerie(e, posicao),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Espacos.l,
                      Espacos.s,
                      Espacos.l,
                      Espacos.l,
                    ),
                    child: posicao == null
                        ? BotaoBrasa(
                            rotulo: 'Finalizar treino',
                            onPressed: () => _finalizar(e),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: BotaoBrasa(
                                  rotulo: '✎ Alterar',
                                  variante: VarianteBotao.secundario,
                                  onPressed: () => _alterar(posicao),
                                ),
                              ),
                              const SizedBox(width: Espacos.s),
                              Expanded(
                                flex: 2,
                                child: BotaoBrasa(
                                  rotulo: posicao.aquecimento
                                      ? 'Registrar aquecimento'
                                      : 'Registrar série',
                                  carregando: _registrando,
                                  onPressed: () => _registrar(e, posicao),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _chave(PosicaoSerie p) =>
      '${p.item.item.id}:${p.numero}:${p.cargaPlanKg}:${p.repsPlan}';

  ValoresSerie _valores(PosicaoSerie p) {
    if (_chaveAlterados == _chave(p) && _alterados != null) return _alterados!;
    return (cargaKg: p.cargaPlanKg, reps: p.repsPlan);
  }

  Widget _conteudoSerie(EstadoExecucao estado, PosicaoSerie posicao) {
    final item = posicao.item;
    final valores = _valores(posicao);
    final ultima = estado.ultimaVezDa(posicao);
    final feitas = estado.seriesDoItem(item.item.id);
    final aquecimento = estado.aquecimentoDoItem(item.item.id);
    final percentual = posicao.percentual;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: Espacos.l),
      children: [
        const SizedBox(height: Espacos.l),
        Text(item.exercicio.nome, style: Textos.nome.copyWith(fontSize: 24)),
        const SizedBox(height: Espacos.xs),
        Text(
          posicao.aquecimento
              ? 'AQUECIMENTO · ${formatarPercentual(percentual!)} DA CARGA'
              : 'SÉRIE ${posicao.numero} DE ${item.item.series}'
                    '${percentual == null ? '' : ' · ${formatarPercentual(percentual)}'}',
          style: Textos.rotulo.copyWith(
            color: posicao.aquecimento ? Cores.atencao : Cores.brasa,
          ),
        ),
        const SizedBox(height: Espacos.xl),
        _NumerosGrandes(posicao: posicao, valores: valores),
        const SizedBox(height: Espacos.s),
        Text(
          'Faixa do plano: ${formatarPrescricao(item.item, item.exercicio)}'
          '${item.item.rirAlvo == null ? '' : ' · RIR ${item.item.rirAlvo}'}',
          textAlign: TextAlign.center,
          style: Textos.secundario,
        ),
        const SizedBox(height: Espacos.xs),
        Text(
          posicao.aquecimento
              ? 'SÉRIE LEVE, LONGE DA FALHA'
              : ultima == null
              ? 'PRIMEIRA VEZ NESTE EXERCÍCIO'
              : 'ÚLTIMA VEZ · ${_descreverSerie(ultima, item.exercicio)}',
          textAlign: TextAlign.center,
          style: Textos.rotulo,
        ),
        const SizedBox(height: Espacos.l),
        ..._opcoes(estado, posicao),
        if (estado.prAtivo(item)) _EscadaPr(estado: estado, posicao: posicao),
        const SizedBox(height: Espacos.l),
        if (aquecimento != null || posicao.aquecimento)
          _LinhaSerie(
            rotulo: 'AQUECIMENTO',
            nomeAcessivel: 'Aquecimento',
            exercicio: item.exercicio,
            feita: aquecimento,
            atual: posicao.aquecimento,
            valoresAtuais: posicao.aquecimento ? valores : null,
            aoCorrigir: (serie) => _corrigir(item, serie),
          ),
        for (var numero = 1; numero <= item.item.series; numero++)
          _LinhaSerie(
            rotulo: 'SÉRIE $numero',
            nomeAcessivel: 'Série $numero',
            exercicio: item.exercicio,
            feita: feitas.where((s) => s.numero == numero).firstOrNull,
            atual: !posicao.aquecimento && numero == posicao.numero,
            valoresAtuais: numero == posicao.numero ? valores : null,
            planejado: _descreverPlano(estado.planoDa(item, numero), item),
            aoCorrigir: (serie) => _corrigir(item, serie),
          ),
        ..._exercicioAnterior(estado, posicao),
        const SizedBox(height: Espacos.l),
      ],
    );
  }

  /// Botões "Tentar bater o PR" e "Aquecimento" do exercício atual.
  List<Widget> _opcoes(EstadoExecucao estado, PosicaoSerie posicao) {
    final item = posicao.item;
    final prAtivo = estado.prAtivo(item);
    final mostrarPr = estado.aceitaPr(item);
    final mostrarAquecimento =
        posicao.aquecimento || estado.podeAquecer(posicao);
    final semSeries =
        estado.seriesDoItem(item.item.id).isEmpty &&
        estado.aquecimentoDoItem(item.item.id) == null;

    if (!mostrarPr && !mostrarAquecimento) return const [];

    String? rotuloAquecimento;
    if (mostrarAquecimento) {
      final base = item.item.cargaPlanKg!;
      final plano = planoAquecimento(
        cargaBase: base,
        repsMin: item.item.repsMin,
        equipamento: item.exercicio.equipamento,
        passo: item.exercicio.passoCargaKg,
      );
      rotuloAquecimento =
          'Aquecimento · ${formatarKg(plano.cargaKg!)} kg × ${plano.reps}';
    }

    return [
      Wrap(
        spacing: Espacos.s,
        runSpacing: Espacos.s,
        alignment: WrapAlignment.center,
        children: [
          if (mostrarPr)
            _Opcao(
              icone: Icons.trending_up,
              rotulo: 'Tentar bater o PR',
              selecionada: prAtivo,
              aoMudar: (ativo) => _definirPr(estado, item, ativo),
            ),
          if (rotuloAquecimento != null)
            _Opcao(
              icone: Icons.local_fire_department_outlined,
              rotulo: rotuloAquecimento,
              selecionada: posicao.aquecimento,
              aoMudar: (ativo) => _definirAquecimento(estado, item, ativo),
            ),
        ],
      ),
      if (prAtivo && semSeries) ...[
        const SizedBox(height: Espacos.s),
        const Text(
          'Com a carga subindo entre as séries, as primeiras já servem de '
          'aquecimento.',
          textAlign: TextAlign.center,
          style: Textos.secundario,
        ),
      ],
    ];
  }

  /// No começo de um exercício, as séries do anterior continuam à mão para
  /// corrigir um registro errado sem sair da tela.
  List<Widget> _exercicioAnterior(EstadoExecucao estado, PosicaoSerie posicao) {
    if (posicao.indiceItem == 0) return const [];
    final anterior = estado.sessao.itens[posicao.indiceItem - 1];
    final feitas = estado.seriesDoItem(anterior.item.id);
    if (feitas.isEmpty ||
        estado.seriesDoItem(posicao.item.item.id).isNotEmpty) {
      return const [];
    }
    return [
      const SizedBox(height: Espacos.l),
      Text(
        'EXERCÍCIO ANTERIOR · ${anterior.exercicio.nome.toUpperCase()}',
        style: Textos.rotulo,
      ),
      const SizedBox(height: Espacos.s),
      for (final serie in feitas)
        _LinhaSerie(
          rotulo: 'SÉRIE ${serie.numero}',
          nomeAcessivel: 'Série ${serie.numero}',
          exercicio: anterior.exercicio,
          feita: serie,
          atual: false,
          aoCorrigir: (serie) => _corrigir(anterior, serie),
        ),
    ];
  }

  Future<void> _definirPr(
    EstadoExecucao estado,
    ItemComExercicio item,
    bool ativo,
  ) async {
    await _controller.definirPr(estado, item, ativo: ativo);
    if (!mounted) return;
    _avisar(
      ativo ? 'Carga progressiva até o PR' : 'Carga do plano de volta',
      duracao: const Duration(seconds: 5),
      acao: SnackBarAction(
        label: 'Desfazer',
        textColor: Cores.brasa,
        onPressed: () => _controller.definirPr(estado, item, ativo: !ativo),
      ),
    );
  }

  Future<void> _definirAquecimento(
    EstadoExecucao estado,
    ItemComExercicio item,
    bool ativo,
  ) async {
    await _controller.definirAquecimento(estado, item, ativo: ativo);
    if (!mounted) return;
    _avisar(
      ativo ? 'Série de aquecimento adicionada' : 'Aquecimento removido',
      duracao: const Duration(seconds: 5),
      acao: SnackBarAction(
        label: 'Desfazer',
        textColor: Cores.brasa,
        onPressed: () =>
            _controller.definirAquecimento(estado, item, ativo: !ativo),
      ),
    );
  }

  Future<void> _corrigir(ItemComExercicio item, Serie serie) async {
    final resultado = await abrirPainelCorrigir(
      context,
      item: item,
      serie: serie,
    );
    if (resultado == null || !mounted) return;

    final nome = serie.aquecimento ? 'Aquecimento' : 'Série ${serie.numero}';
    final String aviso;
    switch (resultado) {
      case SalvarCorrecao(:final valores):
        await _controller.corrigir(
          serie,
          cargaKg: valores.cargaKg,
          reps: valores.reps,
        );
        aviso = '$nome corrigid${serie.aquecimento ? 'o' : 'a'}';
      case ExcluirSerie():
        await _controller.desfazer(serie.id);
        aviso = '$nome excluíd${serie.aquecimento ? 'o' : 'a'}';
    }
    if (mounted) _avisar(aviso, duracao: const Duration(seconds: 3));
  }

  /// Aviso flutuando acima dos botões de baixo, para não bloquear o
  /// "Registrar série" enquanto aparece.
  void _avisar(
    String texto, {
    required Duration duracao,
    SnackBarAction? acao,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(texto),
          duration: duracao,
          persist: false,
          action: acao,
          margin: const EdgeInsets.fromLTRB(
            Espacos.l,
            0,
            Espacos.l,
            _alturaBotoes + Espacos.s,
          ),
        ),
      );
  }

  /// Botão de 50 px com as margens da linha de botões.
  static const _alturaBotoes = 50 + Espacos.s + Espacos.l;

  Future<void> _alterar(PosicaoSerie posicao) async {
    final novos = await abrirPainelAlterar(
      context,
      posicao: posicao,
      atuais: _valores(posicao),
    );
    if (novos == null || !mounted) return;
    setState(() {
      _alterados = novos;
      _chaveAlterados = _chave(posicao);
    });
  }

  Future<void> _registrar(EstadoExecucao estado, PosicaoSerie posicao) async {
    if (_registrando) return;
    setState(() => _registrando = true);
    final valores = _valores(posicao);
    try {
      final serie = await _controller.registrar(
        estado,
        cargaKg: valores.cargaKg ?? posicao.cargaPlanKg,
        reps: valores.reps,
      );
      if (!mounted || serie == null) return;
      setState(() {
        _alterados = null;
        _chaveAlterados = null;
      });
      _avisar(
        posicao.aquecimento ? 'Aquecimento registrado' : 'Série registrada',
        duracao: const Duration(seconds: 5),
        acao: SnackBarAction(
          label: 'Desfazer',
          textColor: Cores.brasa,
          onPressed: () => _controller.desfazer(serie.id),
        ),
      );
    } finally {
      if (mounted) setState(() => _registrando = false);
    }
  }

  Future<void> _finalizar(EstadoExecucao estado) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    await _controller.finalizar(estado);
    if (mounted) context.go('/resumo/${estado.treino.id}');
  }

  Future<void> _confirmarPausa() async {
    final pausar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Cores.ferro800,
        title: const Text('Pausar o treino?', style: Textos.nome),
        content: const Text(
          'O que você registrou fica salvo. Ao voltar, o treino continua da '
          'série certa.',
          style: Textos.corpo,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuar treinando'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Pausar'),
          ),
        ],
      ),
    );
    if (pausar == true && mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      context.go('/treino');
    }
  }

  Future<void> _confirmarEncerrar(EstadoExecucao estado) async {
    final encerrar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Cores.ferro800,
        title: const Text('Encerrar o treino agora?', style: Textos.nome),
        content: Text(
          'Ele fica salvo como parcial, com ${estado.seriesFeitas} de '
          '${estado.totalSeries} séries registradas.',
          style: Textos.corpo,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Encerrar'),
          ),
        ],
      ),
    );
    if (encerrar == true && mounted) await _finalizar(estado);
  }
}

String _descreverSerie(Serie serie, Exercicio exercicio) =>
    _descrever(serie.cargaKg, serie.reps ?? 0, exercicio);

String _descreverPlano(PlanoDaSerie plano, ItemComExercicio item) =>
    _descrever(plano.cargaKg, plano.reps, item.exercicio);

String _descrever(double? cargaKg, int reps, Exercicio exercicio) {
  switch (exercicio.tipoCarga) {
    case TipoCarga.tempo:
      return '$reps S';
    case TipoCarga.corporal:
      return cargaKg == null
          ? '$reps REPS'
          : '+${formatarKg(cargaKg)} KG × $reps';
    default:
      return '${formatarKg(cargaKg ?? 0)} KG × $reps';
  }
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho({
    required this.estado,
    required this.aoPausar,
    required this.aoEncerrar,
  });

  final EstadoExecucao estado;
  final VoidCallback aoPausar;
  final VoidCallback aoEncerrar;

  @override
  Widget build(BuildContext context) {
    final atual = estado.atual;
    final total = estado.sessao.itens.length;
    final percentual = formatarPercentual(estado.progresso);
    final volume = formatarVolume(estado.volumeKg);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Espacos.xs),
          child: Row(
            children: [
              IconButton(
                onPressed: aoPausar,
                tooltip: 'Pausar treino',
                icon: const Icon(Icons.close, color: Cores.giz),
              ),
              Expanded(
                child: Text(
                  atual == null
                      ? 'TREINO ${estado.sessao.sessao.dia} · COMPLETO'
                      : 'TREINO ${estado.sessao.sessao.dia} · '
                            'EXERCÍCIO ${atual.indiceItem + 1} DE $total',
                  textAlign: TextAlign.center,
                  style: Textos.rotulo,
                ),
              ),
              PopupMenuButton<void>(
                tooltip: 'Mais opções',
                color: Cores.ferro800,
                icon: const Icon(Icons.more_horiz, color: Cores.giz),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    onTap: aoEncerrar,
                    child: const Text('Encerrar treino', style: Textos.corpo),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Progresso discreto do treino, com o volume já levantado.
        Semantics(
          label:
              '$percentual do treino feito, '
              '$volume quilos de volume',
          excludeSemantics: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Espacos.l),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: estado.progresso,
                      minHeight: 3,
                      backgroundColor: Cores.ferro700,
                    ),
                  ),
                ),
                const SizedBox(width: Espacos.s),
                Text(
                  '$percentual · $volume KG',
                  style: Textos.rotulo.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Opcao extends StatelessWidget {
  const _Opcao({
    required this.icone,
    required this.rotulo,
    required this.selecionada,
    required this.aoMudar,
  });

  final IconData icone;
  final String rotulo;
  final bool selecionada;
  final ValueChanged<bool> aoMudar;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: selecionada ? null : Icon(icone, size: 18, color: Cores.ferro400),
      label: Text(rotulo),
      selected: selecionada,
      onSelected: aoMudar,
      showCheckmark: true,
      checkmarkColor: Cores.brasa,
      labelStyle: Textos.secundario.copyWith(
        color: selecionada ? Cores.giz : Cores.ferro400,
      ),
      backgroundColor: Cores.ferro900,
      selectedColor: Cores.ferro800,
      side: BorderSide(color: selecionada ? Cores.brasa : Cores.ferro700),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Raios.botao),
      ),
    );
  }
}

/// A sequência de cargas do modo PR, com a série atual em destaque.
class _EscadaPr extends StatelessWidget {
  const _EscadaPr({required this.estado, required this.posicao});

  final EstadoExecucao estado;
  final PosicaoSerie posicao;

  @override
  Widget build(BuildContext context) {
    final item = posicao.item;
    final cargas = [
      for (var n = 1; n <= item.item.series; n++)
        (numero: n, plano: estado.planoDa(item, n)),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: Espacos.m),
      child: Text.rich(
        TextSpan(
          style: Textos.rotulo,
          children: [
            const TextSpan(text: 'RUMO AO PR  '),
            for (final (i, c) in cargas.indexed) ...[
              if (i > 0) const TextSpan(text: ' → '),
              TextSpan(
                text: formatarKg(c.plano.cargaKg!),
                style: TextStyle(
                  color: !posicao.aquecimento && c.numero == posicao.numero
                      ? Cores.brasa
                      : i == cargas.length - 1
                      ? Cores.giz
                      : Cores.ferro400,
                  fontWeight: c.numero == posicao.numero
                      ? FontWeight.w700
                      : null,
                ),
              ),
            ],
            const TextSpan(text: ' KG'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _NumerosGrandes extends StatelessWidget {
  const _NumerosGrandes({required this.posicao, required this.valores});

  final PosicaoSerie posicao;
  final ValoresSerie valores;

  @override
  Widget build(BuildContext context) {
    final tipo = posicao.item.exercicio.tipoCarga;
    final cargaEditada =
        tipo == TipoCarga.externa && valores.cargaKg != posicao.cargaPlanKg;
    final repsEditadas = valores.reps != posicao.repsPlan;
    TextStyle estilo(bool editado) =>
        Textos.numeroSerie.copyWith(color: editado ? Cores.atencao : Cores.giz);

    final reps = valores.reps.toString();
    final String descricao;
    final List<Widget> partes;
    switch (tipo) {
      case TipoCarga.tempo:
        descricao = '$reps segundos';
        partes = [
          Text(reps, style: estilo(repsEditadas)),
          const Text(' S', style: Textos.rotulo),
        ];
      case TipoCarga.corporal:
        final extra = valores.cargaKg;
        descricao = extra == null
            ? '$reps repetições, peso corporal'
            : '$reps repetições, mais ${formatarKg(extra)} quilos';
        partes = [
          Text(reps, style: estilo(repsEditadas)),
          Text(
            extra == null ? ' REPS' : ' REPS +${formatarKg(extra)} KG',
            style: Textos.rotulo,
          ),
        ];
      default:
        final carga = formatarKg(valores.cargaKg ?? 0);
        descricao = '$carga quilos, $reps repetições';
        partes = [
          Text(carga, style: estilo(cargaEditada)),
          const Text('KG', style: Textos.rotulo),
          Text(
            ' × ',
            style: Textos.numeroLista.copyWith(color: Cores.ferro400),
          ),
          Text(reps, style: estilo(repsEditadas)),
        ];
    }

    final serie = posicao.aquecimento
        ? 'Aquecimento'
        : 'Série ${posicao.numero} de ${posicao.item.item.series}';
    return Semantics(
      label: '$serie, $descricao',
      excludeSemantics: true,
      child: SizedBox(
        height: 110,
        child: FittedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: partes,
          ),
        ),
      ),
    );
  }
}

/// Uma série na lista da 02A. As já feitas são tocáveis para corrigir; as que
/// faltam mostram o planejado.
class _LinhaSerie extends StatelessWidget {
  const _LinhaSerie({
    required this.rotulo,
    required this.nomeAcessivel,
    required this.exercicio,
    required this.feita,
    required this.atual,
    required this.aoCorrigir,
    this.valoresAtuais,
    this.planejado,
  });

  final String rotulo;
  final String nomeAcessivel;
  final Exercicio exercicio;
  final Serie? feita;
  final bool atual;
  final ValueChanged<Serie> aoCorrigir;
  final ValoresSerie? valoresAtuais;
  final String? planejado;

  @override
  Widget build(BuildContext context) {
    final feita = this.feita;
    final String texto;
    if (feita != null) {
      texto = _descreverSerie(feita, exercicio);
    } else if (atual && valoresAtuais != null) {
      texto = 'AGORA';
    } else {
      texto = planejado ?? '—';
    }
    final forma = BorderRadius.circular(Raios.botao);

    return Padding(
      padding: const EdgeInsets.only(bottom: Espacos.s),
      child: Semantics(
        button: feita != null,
        label: feita == null
            ? null
            : '$nomeAcessivel, ${texto.toLowerCase()}. Toque para corrigir',
        excludeSemantics: feita != null,
        child: Material(
          color: atual ? Cores.ferro800 : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: forma,
            side: BorderSide(color: atual ? Cores.brasa : Cores.ferro700),
          ),
          child: InkWell(
            onTap: feita == null ? null : () => aoCorrigir(feita),
            borderRadius: forma,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Espacos.l),
                child: _conteudo(feita, texto),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _conteudo(Serie? feita, String texto) {
    return Row(
      children: [
        Text(
          rotulo,
          style: Textos.rotulo.copyWith(
            color: atual ? Cores.brasa : Cores.ferro400,
          ),
        ),
        const SizedBox(width: Espacos.s),
        // Encolhe em vez de estourar a linha com fonte grande.
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  if (feita?.editado ?? false) ...[
                    Text(
                      'EDITADO',
                      style: Textos.rotulo.copyWith(
                        color: Cores.atencao,
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(width: Espacos.s),
                  ],
                  Text(
                    texto,
                    style: Textos.rotulo.copyWith(
                      color: feita != null ? Cores.giz : Cores.ferro400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (feita != null) ...[
          const SizedBox(width: Espacos.s),
          const Icon(Icons.check, size: 16, color: Cores.avanco),
          const SizedBox(width: Espacos.s),
          const Icon(Icons.edit_outlined, size: 16, color: Cores.ferro400),
        ],
      ],
    );
  }
}

class _Completo extends StatelessWidget {
  const _Completo({required this.estado});

  final EstadoExecucao estado;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Espacos.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Cores.avanco,
            ),
            const SizedBox(height: Espacos.l),
            Text(
              'Treino ${estado.sessao.sessao.dia} completo',
              style: Textos.titulo.copyWith(fontSize: 36),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Espacos.s),
            Text(
              '${estado.seriesFeitas} séries registradas. Ainda dá para desfazer '
              'a última antes de finalizar.',
              style: Textos.secundario,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
