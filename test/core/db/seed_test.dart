import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/core/db/app_database.dart';

import '../../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = abrirBancoDeTeste());
  tearDown(() => db.close());

  test('carrega o catálogo e um plano ABC de 4 semanas', () async {
    expect(await popularSeedDeTeste(db), isTrue);

    final exercicios = await db.select(db.exercicios).get();
    expect(exercicios.length, greaterThanOrEqualTo(30));

    final planos = await db.select(db.planosTreino).get();
    expect(planos, hasLength(1));
    expect(planos.single.divisao, 'ABC');
    expect(planos.single.semanas, 4);
    expect(planos.single.ativo, isTrue);

    final sessoes = await db.select(db.sessoesPlano).get();
    expect(sessoes.map((s) => s.dia), ['A', 'B', 'C']);

    final itens = await db.select(db.itensPlano).get();
    for (final s in sessoes) {
      expect(itens.where((i) => i.sessaoPlanoId == s.id), isNotEmpty);
    }
  });

  test('todo item do plano aponta para um exercício do catálogo', () async {
    await popularSeedDeTeste(db);
    final ids = (await db.select(db.exercicios).get()).map((e) => e.id).toSet();
    final itens = await db.select(db.itensPlano).get();
    expect(itens.map((i) => i.exercicioId), everyElement(isIn(ids)));
  });

  test('exercícios por tempo ou peso corporal não têm carga planejada '
      'obrigatória', () async {
    await popularSeedDeTeste(db);
    final prancha = await (db.select(
      db.exercicios,
    )..where((e) => e.id.equals('prancha'))).getSingle();
    expect(prancha.tipoCarga, TipoCarga.tempo);

    final item = await (db.select(
      db.itensPlano,
    )..where((i) => i.exercicioId.equals('prancha'))).getSingle();
    expect(item.cargaPlanKg, isNull);
  });

  test('rodar o seed de novo não duplica nada', () async {
    expect(await popularSeedDeTeste(db), isTrue);
    expect(await popularSeedDeTeste(db), isFalse);

    expect(await db.select(db.planosTreino).get(), hasLength(1));
    expect(await db.select(db.sessoesPlano).get(), hasLength(3));
  });
}
