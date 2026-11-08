import 'dart:math' as math;

import 'package:drift/drift.dart';

import '../../../features/progressao/progressao.dart';
import '../app_database.dart';

/// O que cada ponto do gráfico mede, conforme o tipo de carga do exercício.
enum MetricaEvolucao {
  /// 1RM estimado pela fórmula de Epley, em kg.
  umRm,

  /// Mais reps numa série (peso do corpo).
  reps,

  /// Mais segundos numa série (exercícios por tempo).
  segundos;

  static MetricaEvolucao de(Exercicio exercicio) =>
      switch (exercicio.tipoCarga) {
        TipoCarga.externa => umRm,
        TipoCarga.tempo => segundos,
        _ => reps,
      };
}

/// A melhor série de um treino, medida pela [MetricaEvolucao] do exercício.
class PontoEvolucao {
  const PontoEvolucao({
    required this.treinoId,
    required this.data,
    required this.valor,
    required this.cargaKg,
    required this.reps,
    required this.recorde,
  });

  final String treinoId;
  final DateTime data;

  /// 1RM estimado (kg), reps ou segundos.
  final double valor;

  /// Carga e reps da série que deu o [valor].
  final double? cargaKg;
  final int reps;

  /// Passou o melhor valor de todos os treinos anteriores.
  final bool recorde;
}

/// Histórico de um exercício, do treino mais antigo ao mais recente.
class Evolucao {
  const Evolucao(this.exercicio, this.pontos);

  final Exercicio exercicio;
  final List<PontoEvolucao> pontos;

  MetricaEvolucao get metrica => MetricaEvolucao.de(exercicio);
  PontoEvolucao? get ultimo => pontos.lastOrNull;

  /// Os treinos das últimas [semanas] semanas até [agora].
  List<PontoEvolucao> ultimasSemanas(DateTime agora, {int semanas = 8}) {
    final desde = agora.subtract(Duration(days: 7 * semanas));
    return pontos.where((p) => !p.data.isBefore(desde)).toList();
  }
}

/// Calcula a evolução a partir das séries gravadas (etapa 4 do PRD).
class EvolucaoRepository {
  EvolucaoRepository(this._db);

  final AppDatabase _db;

  /// Evolução de cada exercício que já tem séries registradas.
  Future<Map<String, Evolucao>> todas() => _calcular(null);

  Future<Evolucao?> doExercicio(String exercicioId) async =>
      (await _calcular(exercicioId))[exercicioId];

  Stream<Map<String, Evolucao>> watchTodas() => _db
      .quandoMudar('evolucao_todas', {_db.series, _db.treinos, _db.exercicios})
      .asyncMap((_) => todas());

  Stream<Evolucao?> watchDoExercicio(String exercicioId) => _db
      .quandoMudar('evolucao:$exercicioId', {
        _db.series,
        _db.treinos,
        _db.exercicios,
      })
      .asyncMap((_) => doExercicio(exercicioId));

  Future<Map<String, Evolucao>> _calcular(String? exercicioId) async {
    final consulta =
        _db.select(_db.series).join([
            innerJoin(
              _db.treinos,
              _db.treinos.id.equalsExp(_db.series.treinoId),
            ),
            innerJoin(
              _db.exercicios,
              _db.exercicios.id.equalsExp(_db.series.exercicioId),
            ),
          ])
          ..where(
            _db.series.aquecimento.equals(false) &
                _db.series.excluidoEm.isNull() &
                _db.series.reps.isNotNull() &
                _db.treinos.excluidoEm.isNull() &
                (exercicioId == null
                    ? const Constant(true)
                    : _db.series.exercicioId.equals(exercicioId)),
          )
          ..orderBy([OrderingTerm.asc(_db.treinos.iniciadoEm)]);

    // Por exercício, a melhor série de cada treino, na ordem dos treinos.
    final exercicios = <String, Exercicio>{};
    final melhores = <String, Map<String, PontoEvolucao>>{};
    for (final linha in await consulta.get()) {
      final serie = linha.readTable(_db.series);
      final treino = linha.readTable(_db.treinos);
      final exercicio = linha.readTable(_db.exercicios);
      exercicios[exercicio.id] = exercicio;

      final reps = serie.reps!;
      final double valor;
      switch (MetricaEvolucao.de(exercicio)) {
        case MetricaEvolucao.umRm:
          final carga = serie.cargaKg;
          if (carga == null || carga <= 0 || reps <= 0) continue;
          valor = umRmEpley(carga, reps);
        case MetricaEvolucao.reps || MetricaEvolucao.segundos:
          if (reps <= 0) continue;
          valor = reps.toDouble();
      }

      final porTreino = melhores.putIfAbsent(exercicio.id, () => {});
      final atual = porTreino[treino.id];
      if (atual == null || valor > atual.valor) {
        porTreino[treino.id] = PontoEvolucao(
          treinoId: treino.id,
          data: treino.iniciadoEm,
          valor: valor,
          cargaKg: serie.cargaKg,
          reps: reps,
          recorde: false,
        );
      }
    }

    return {
      for (final MapEntry(key: id, value: porTreino) in melhores.entries)
        id: Evolucao(exercicios[id]!, _marcarRecordes(porTreino.values)),
    };
  }

  /// Recorde = passou o melhor de todos os treinos anteriores. O primeiro
  /// treino não conta: não havia o que passar.
  List<PontoEvolucao> _marcarRecordes(Iterable<PontoEvolucao> pontos) {
    final ordenados = pontos.toList()..sort((a, b) => a.data.compareTo(b.data));
    var melhor = double.negativeInfinity;
    return [
      for (final (i, p) in ordenados.indexed)
        () {
          final recorde = i > 0 && p.valor > melhor + 1e-9;
          melhor = math.max(melhor, p.valor);
          return PontoEvolucao(
            treinoId: p.treinoId,
            data: p.data,
            valor: p.valor,
            cargaKg: p.cargaKg,
            reps: p.reps,
            recorde: recorde,
          );
        }(),
    ];
  }
}
