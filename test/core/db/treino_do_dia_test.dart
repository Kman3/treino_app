import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/core/db/app_database.dart';
import 'package:treino_app/core/db/repositorios/plano_repository.dart';
import 'package:treino_app/core/db/repositorios/treino_repository.dart';

import '../../helpers.dart';

void main() {
  late AppDatabase db;
  late DateTime agora;
  late PlanoRepository planos;
  late TreinoRepository treinos;

  setUp(() async {
    db = abrirBancoDeTeste();
    agora = DateTime(2026, 10, 20, 7);
    planos = PlanoRepository(db, agora: () => agora);
    treinos = TreinoRepository(db, agora: () => agora);
    await popularSeedDeTeste(db, agora: agora);
  });
  tearDown(() => db.close());

  /// Faz o treino do dia inteiro e devolve o dia feito.
  Future<String> fazerTreinoDoDia() async {
    final dia = (await planos.treinoDoDia())!;
    final treino = await treinos.iniciar(dia.sessao.sessao.id);
    agora = agora.add(const Duration(hours: 1));
    await treinos.finalizar(treino.id);
    agora = agora.add(const Duration(days: 1));
    return dia.sessao.sessao.dia;
  }

  test('sem histórico, o treino do dia é o A da semana 1', () async {
    final dia = (await planos.treinoDoDia())!;

    expect(dia.sessao.sessao.dia, 'A');
    expect(dia.semana, 1);
    expect(dia.sessoes.map((s) => s.dia), ['A', 'B', 'C']);
    expect(dia.emAndamento, isNull);
  });

  test('lê os exercícios da sessão em ordem, com o catálogo', () async {
    final dia = (await planos.treinoDoDia())!;
    final itens = dia.sessao.itens;

    expect(itens.first.exercicio.nome, 'Supino reto com barra');
    expect(itens.first.item.cargaPlanKg, 60);
    expect(itens.map((i) => i.item.ordem), [0, 1, 2, 3, 4, 5]);
    expect(dia.sessao.duracaoEstimadaMin, greaterThan(0));
  });

  test('o ciclo avança A → B → C → A', () async {
    expect(await fazerTreinoDoDia(), 'A');
    expect(await fazerTreinoDoDia(), 'B');
    expect(await fazerTreinoDoDia(), 'C');
    expect((await planos.treinoDoDia())!.sessao.sessao.dia, 'A');
  });

  test('treino parcial também avança o ciclo', () async {
    final dia = (await planos.treinoDoDia())!;
    final treino = await treinos.iniciar(dia.sessao.sessao.id);
    await treinos.finalizar(treino.id, status: StatusTreino.parcial);

    expect((await planos.treinoDoDia())!.sessao.sessao.dia, 'B');
  });

  test('treino em andamento continua sendo o do dia', () async {
    await fazerTreinoDoDia();
    final b = (await planos.treinoDoDia())!;
    final treino = await treinos.iniciar(b.sessao.sessao.id);

    final dia = (await planos.treinoDoDia())!;
    expect(dia.sessao.sessao.dia, 'B');
    expect(dia.emAndamento?.id, treino.id);
  });

  test('a semana do ciclo conta a partir do início do plano', () async {
    agora = DateTime(2026, 10, 26, 23);
    expect((await planos.treinoDoDia())!.semana, 1);

    agora = DateTime(2026, 10, 27);
    expect((await planos.treinoDoDia())!.semana, 2);

    agora = DateTime(2027, 1, 1);
    expect((await planos.treinoDoDia())!.semana, 4);
  });

  test('watchTreinoDoDia emite de novo quando um treino termina', () async {
    final emissoes = planos
        .watchTreinoDoDia()
        .map((d) => d!.sessao.sessao.dia)
        .take(2)
        .toList();

    await Future<void>.delayed(Duration.zero);
    await fazerTreinoDoDia();

    expect(await emissoes, containsAllInOrder(['A', 'B']));
  });
}
