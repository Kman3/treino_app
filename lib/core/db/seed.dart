import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:uuid/uuid.dart';

import 'app_database.dart';

const caminhoSeedExercicios = 'assets/seed/exercicios.json';
const caminhoSeedPlano = 'assets/seed/plano_exemplo.json';

/// Popula o catálogo e o plano de exemplo dos assets, só no primeiro uso.
Future<bool> popularSeedDosAssets(AppDatabase db) async {
  return popularSeed(
    db,
    exerciciosJson: await rootBundle.loadString(caminhoSeedExercicios),
    planoJson: await rootBundle.loadString(caminhoSeedPlano),
  );
}

/// Insere o catálogo de exercícios e um plano ativo a partir do JSON.
///
/// Não faz nada se o catálogo já tiver exercícios. Devolve `true` quando
/// inseriu. O plano começa em [agora] (por padrão, hoje).
Future<bool> popularSeed(
  AppDatabase db, {
  required String exerciciosJson,
  required String planoJson,
  DateTime? agora,
}) async {
  final jaTem = await (db.select(db.exercicios)..limit(1)).getSingleOrNull();
  if (jaTem != null) return false;

  const uuid = Uuid();
  final hoje = agora ?? DateTime.now();
  final exercicios = (jsonDecode(exerciciosJson) as List)
      .cast<Map<String, dynamic>>();
  final plano = jsonDecode(planoJson) as Map<String, dynamic>;

  await db.transaction(() async {
    await db.batch((b) {
      b.insertAll(db.exercicios, [
        for (final e in exercicios)
          ExerciciosCompanion.insert(
            id: e['id'] as String,
            nome: e['nome'] as String,
            musculosAlvo: e['musculos_alvo'] as String,
            padraoMovimento: e['padrao_movimento'] as String,
            equipamento: e['equipamento'] as String,
            tipoCarga: e['tipo_carga'] as String,
            passoCargaKg: Value((e['passo_carga_kg'] as num).toDouble()),
          ),
      ]);
    });

    final planoId = uuid.v4();
    await db
        .into(db.planosTreino)
        .insert(
          PlanosTreinoCompanion.insert(
            id: planoId,
            divisao: plano['divisao'] as String,
            semanas: plano['semanas'] as int,
            inicioEm: DateTime(hoje.year, hoje.month, hoje.day),
          ),
        );

    final sessoes = (plano['sessoes'] as List).cast<Map<String, dynamic>>();
    for (final (ordem, sessao) in sessoes.indexed) {
      final sessaoId = uuid.v4();
      await db
          .into(db.sessoesPlano)
          .insert(
            SessoesPlanoCompanion.insert(
              id: sessaoId,
              planoId: planoId,
              dia: sessao['dia'] as String,
              foco: sessao['foco'] as String,
              ordem: ordem,
            ),
          );

      final itens = (sessao['itens'] as List).cast<Map<String, dynamic>>();
      await db.batch((b) {
        b.insertAll(db.itensPlano, [
          for (final (ordemItem, item) in itens.indexed)
            ItensPlanoCompanion.insert(
              id: uuid.v4(),
              sessaoPlanoId: sessaoId,
              exercicioId: item['exercicio'] as String,
              ordem: ordemItem,
              series: item['series'] as int,
              repsMin: item['reps_min'] as int,
              repsMax: item['reps_max'] as int,
              rirAlvo: Value(item['rir_alvo'] as int?),
              descansoS: item['descanso_s'] as int,
              cargaPlanKg: Value((item['carga_plan_kg'] as num?)?.toDouble()),
              justificativa: Value(item['justificativa'] as String?),
            ),
        ]);
      });
    }
  });
  return true;
}
