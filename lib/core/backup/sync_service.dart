import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:drift/drift.dart';

import '../db/app_database.dart';
import 'backup_nuvem.dart';

/// Tabelas que vão para o backup, na ordem em que descem: pais antes dos
/// filhos, por causa das chaves estrangeiras do SQLite. O catálogo de
/// exercícios vem com o app e não sobe.
const tabelasDoBackup = [
  'planos_treino',
  'sessoes_plano',
  'itens_plano',
  'treinos',
  'series',
  'substituicoes',
  'ajustes_execucao',
  'preferencias',
];

/// Chaves de `estados_sync`.
abstract final class ChaveSync {
  static const ultimoBackup = 'ultimo_backup';
  static const restauracaoFeita = 'restauracao_feita';
  static String baixadoAte(String tabela) => 'baixado_ate:$tabela';
}

class ResultadoSync {
  const ResultadoSync({
    required this.enviadas,
    required this.recebidas,
    required this.quando,
    required this.restaurou,
  });

  final int enviadas;
  final int recebidas;
  final DateTime quando;

  /// O plano de exemplo deste aparelho deu lugar ao que estava na nuvem.
  final bool restaurou;
}

/// Sync do SQLite com a nuvem (seção 5 do PRD):
///
/// 1. Sobe as linhas com `atualizado_em` depois de `sincronizado_em` (ou
///    nunca enviadas) e marca `sincronizado_em = atualizado_em`.
/// 2. Desce as linhas mais novas que o último download de cada tabela. Em
///    conflito vence o `atualizado_em` mais recente.
/// 3. No primeiro login de um aparelho que só tem o plano de exemplo, intocado,
///    esse plano dá lugar ao da nuvem (trocar de celular).
class SyncService {
  SyncService(this._db, this._nuvem, {DateTime Function()? agora})
    : _agora = agora ?? clock.now;

  final AppDatabase _db;
  final BackupNuvem _nuvem;
  final DateTime Function() _agora;

  static const _lote = 500;
  static const _pendente =
      'sincronizado_em IS NULL OR '
      'julianday(atualizado_em) > julianday(sincronizado_em)';

  Future<ResultadoSync> sincronizar({required String usuarioId}) async {
    final restaurou = await _restaurarNoPrimeiroLogin();
    var enviadas = 0;
    for (final nome in tabelasDoBackup) {
      enviadas += await _enviar(_tabela(nome), usuarioId);
    }
    final recebidas = await _baixar();
    final quando = _agora();
    await _gravar(ChaveSync.ultimoBackup, quando.toUtc().toIso8601String());
    return ResultadoSync(
      enviadas: enviadas,
      recebidas: recebidas,
      quando: quando,
      restaurou: restaurou,
    );
  }

  /// Linhas esperando para subir.
  Future<int> pendentes() async {
    var total = 0;
    for (final nome in tabelasDoBackup) {
      final linha = await _db
          .customSelect('SELECT COUNT(*) AS n FROM $nome WHERE $_pendente')
          .getSingle();
      total += linha.read<int>('n');
    }
    return total;
  }

  Future<DateTime?> ultimoBackup() async {
    final valor = await _ler(ChaveSync.ultimoBackup);
    return valor == null ? null : DateTime.parse(valor).toLocal();
  }

  /// Ao sair da conta: tudo volta a "nunca enviado", para a próxima conta
  /// receber o histórico inteiro e refazer a restauração.
  Future<void> esquecerConta() async {
    await _db.transaction(() async {
      for (final nome in tabelasDoBackup) {
        await _db.customStatement('UPDATE $nome SET sincronizado_em = NULL');
      }
      await _db.delete(_db.estadosSync).go();
    });
  }

  TableInfo _tabela(String nome) =>
      _db.allTables.firstWhere((t) => t.actualTableName == nome);

  Future<int> _enviar(TableInfo tabela, String usuarioId) async {
    final nome = tabela.actualTableName;
    final linhas = await _db
        .customSelect('SELECT * FROM $nome WHERE $_pendente')
        .get();
    for (var i = 0; i < linhas.length; i += _lote) {
      final lote = linhas.sublist(i, math.min(i + _lote, linhas.length));
      await _nuvem.enviar(nome, [
        for (final l in lote) _paraNuvem(tabela, l.data, usuarioId),
      ]);
      // Só marca a versão que subiu: se a linha mudou enquanto isso, ela
      // continua pendente.
      await _db.batch((b) {
        for (final l in lote) {
          b.customStatement(
            'UPDATE $nome SET sincronizado_em = atualizado_em '
            'WHERE id = ? AND atualizado_em = ?',
            [l.data['id'], l.data['atualizado_em']],
          );
        }
      });
    }
    return linhas.length;
  }

  Map<String, Object?> _paraNuvem(
    TableInfo tabela,
    Map<String, Object?> dados,
    String usuarioId,
  ) {
    final linha = <String, Object?>{'usuario_id': usuarioId};
    for (final coluna in tabela.$columns) {
      final nome = coluna.name;
      if (nome == 'sincronizado_em' || nome == 'usuario_id') continue;
      final bruto = dados[nome];
      linha[nome] = bruto == null
          ? null
          : switch (coluna.type) {
              DriftSqlType.bool => bruto == 1 || bruto == true,
              DriftSqlType.dateTime => _lerData(
                bruto,
              ).toUtc().toIso8601String(),
              _ => bruto,
            };
    }
    return linha;
  }

  Future<int> _baixar() async {
    var recebidas = 0;
    final mudadas = <TableInfo>{};
    await _db.transaction(() async {
      // Pais e filhos chegam em tabelas diferentes: as chaves estrangeiras
      // são conferidas só no fim da transação.
      await _db.customStatement('PRAGMA defer_foreign_keys = ON');
      for (final nome in tabelasDoBackup) {
        final tabela = _tabela(nome);
        final marcador = await _ler(ChaveSync.baixadoAte(nome));
        final linhas = await _nuvem.baixar(
          nome,
          desde: marcador == null ? null : DateTime.parse(marcador),
        );
        DateTime? maisNova;
        for (final linha in linhas) {
          final naNuvem = DateTime.parse(linha['atualizado_em']! as String);
          if (maisNova == null || naNuvem.isAfter(maisNova)) maisNova = naNuvem;
          if (await _localMaisNova(nome, linha['id']! as String, naNuvem)) {
            continue;
          }
          await _gravarLocal(tabela, linha);
          mudadas.add(tabela);
          recebidas++;
        }
        if (maisNova != null) {
          await _gravar(
            ChaveSync.baixadoAte(nome),
            maisNova.toUtc().toIso8601String(),
          );
        }
      }
    });
    if (mudadas.isNotEmpty) _db.markTablesUpdated(mudadas);
    return recebidas;
  }

  /// A versão do aparelho é igual ou mais nova que a da nuvem?
  Future<bool> _localMaisNova(
    String tabela,
    String id,
    DateTime naNuvem,
  ) async {
    final linha = await _db
        .customSelect(
          'SELECT atualizado_em FROM $tabela WHERE id = ?',
          variables: [Variable.withString(id)],
        )
        .getSingleOrNull();
    if (linha == null) return false;
    return !_lerData(linha.data['atualizado_em']!).isBefore(naNuvem);
  }

  Future<void> _gravarLocal(
    TableInfo tabela,
    Map<String, Object?> linha,
  ) async {
    final nomes = <String>[];
    final valores = <Object?>[];
    for (final coluna in tabela.$columns) {
      final nome = coluna.name;
      if (nome == 'sincronizado_em' || !linha.containsKey(nome)) continue;
      nomes.add(nome);
      valores.add(_paraLocal(coluna.type, linha[nome]));
    }
    // Veio da nuvem: já está sincronizada.
    nomes.add('sincronizado_em');
    valores.add(_paraLocal(DriftSqlType.dateTime, linha['atualizado_em']));

    final marcadores = List.filled(nomes.length, '?').join(', ');
    final atualiza = [
      for (final n in nomes)
        if (n != 'id') '$n = excluded.$n',
    ].join(', ');
    await _db.customStatement(
      'INSERT INTO ${tabela.actualTableName} (${nomes.join(', ')}) '
      'VALUES ($marcadores) ON CONFLICT(id) DO UPDATE SET $atualiza',
      valores,
    );
  }

  /// [tipo] é o `type` da coluna (o drift não exporta a classe base).
  Object? _paraLocal(Object tipo, Object? valor) {
    if (valor == null) return null;
    final dart = switch (tipo) {
      // Datas em hora local, como o app grava: a ordem dos textos no SQLite
      // continua igual à do tempo.
      DriftSqlType.dateTime => DateTime.parse(valor as String).toLocal(),
      DriftSqlType.double => (valor as num).toDouble(),
      DriftSqlType.int => (valor as num).toInt(),
      _ => valor,
    };
    return _db.typeMapping.mapToSqlVariable(dart);
  }

  DateTime _lerData(Object bruto) =>
      _db.typeMapping.read(DriftSqlType.dateTime, bruto)!;

  /// Primeiro login neste aparelho: se ele ainda não tem treino nenhum e a
  /// nuvem já tem um plano, o plano de exemplo (nunca enviado) sai da frente.
  Future<bool> _restaurarNoPrimeiroLogin() async {
    if (await _ler(ChaveSync.restauracaoFeita) != null) return false;
    var trocou = false;
    final treinos = await _db
        .customSelect('SELECT COUNT(*) AS n FROM treinos')
        .getSingle();
    if (treinos.read<int>('n') == 0) {
      final planosNaNuvem = await _nuvem.baixar('planos_treino');
      if (planosNaNuvem.isNotEmpty) {
        await _db.transaction(() async {
          for (final nome in [
            'substituicoes',
            'itens_plano',
            'sessoes_plano',
            'planos_treino',
          ]) {
            await _db.customStatement(
              'DELETE FROM $nome WHERE sincronizado_em IS NULL',
            );
          }
        });
        trocou = true;
      }
    }
    await _gravar(
      ChaveSync.restauracaoFeita,
      _agora().toUtc().toIso8601String(),
    );
    return trocou;
  }

  Future<String?> _ler(String chave) async => (await (_db.select(
    _db.estadosSync,
  )..where((e) => e.chave.equals(chave))).getSingleOrNull())?.valor;

  Future<void> _gravar(String chave, String valor) => _db
      .into(_db.estadosSync)
      .insertOnConflictUpdate(
        EstadosSyncCompanion.insert(chave: chave, valor: valor),
      );
}
