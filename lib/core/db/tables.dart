// O drift monta as restrições CHECK referenciando a própria coluna no getter.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

/// Tabelas da seção 5 do PRD do módulo Treino. Os nomes das tabelas e colunas
/// em SQL (snake_case) são os mesmos do Supabase.

abstract final class TipoCarga {
  static const externa = 'externa';
  static const corporal = 'corporal';
  static const tempo = 'tempo';
  static const todos = [externa, corporal, tempo];
}

abstract final class StatusTreino {
  static const andamento = 'andamento';
  static const concluido = 'concluido';
  static const parcial = 'parcial';
  static const todos = [andamento, concluido, parcial];
}

abstract final class ModoTreino {
  static const normal = 'normal';
  static const vinteMin = '20min';
  static const todos = [normal, vinteMin];
}

abstract final class EscopoSubstituicao {
  static const sessao = 'sessao';
  static const sempre = 'sempre';
  static const todos = [sessao, sempre];
}

/// Colunas de sync de todas as tabelas do usuário. O `id` é um UUID gerado no
/// aparelho.
mixin ColunasSync on Table {
  DateTimeColumn get atualizadoEm => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get excluidoEm => dateTime().nullable()();
  DateTimeColumn get sincronizadoEm => dateTime().nullable()();
}

/// Catálogo curado, embarcado no app. Não sincroniza: atualiza por versão.
@DataClassName('Exercicio')
class Exercicios extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();

  /// Músculos separados por vírgula, do principal para o secundário.
  TextColumn get musculosAlvo => text()();
  TextColumn get padraoMovimento => text()();
  TextColumn get equipamento => text()();
  TextColumn get tipoCarga => text().check(tipoCarga.isIn(TipoCarga.todos))();
  RealColumn get passoCargaKg => real().withDefault(const Constant(2.5))();
  TextColumn get videoUrl => text().nullable()();
  TextColumn get fonteId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PlanoTreino')
class PlanosTreino extends Table with ColunasSync {
  TextColumn get id => text()();

  /// Nulo até a pessoa entrar com a conta; o app funciona sem login.
  TextColumn get usuarioId => text().nullable()();
  TextColumn get divisao => text()();
  IntColumn get semanas => integer()();
  DateTimeColumn get inicioEm => dateTime()();
  IntColumn get versao => integer().withDefault(const Constant(1))();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Um registro por dia da divisão (A, B, C…).
@DataClassName('SessaoPlano')
class SessoesPlano extends Table with ColunasSync {
  TextColumn get id => text()();
  TextColumn get planoId => text().references(PlanosTreino, #id)();
  TextColumn get dia => text()();
  TextColumn get foco => text()();
  IntColumn get ordem => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ItemPlano')
class ItensPlano extends Table with ColunasSync {
  TextColumn get id => text()();
  TextColumn get sessaoPlanoId => text().references(SessoesPlano, #id)();
  TextColumn get exercicioId => text().references(Exercicios, #id)();
  IntColumn get ordem => integer()();
  IntColumn get series => integer()();

  /// Para exercícios por tempo, a faixa é em segundos.
  IntColumn get repsMin => integer()();
  IntColumn get repsMax => integer()();
  IntColumn get rirAlvo => integer().nullable()();
  IntColumn get descansoS => integer()();

  /// Recalculada pela progressão. Nula em exercícios sem carga externa.
  RealColumn get cargaPlanKg => real().nullable()();
  TextColumn get justificativa => text().nullable()();
  TextColumn get fonteId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Uma execução real de uma sessão do plano.
@DataClassName('Treino')
class Treinos extends Table with ColunasSync {
  TextColumn get id => text()();
  TextColumn get usuarioId => text().nullable()();
  TextColumn get sessaoPlanoId => text().references(SessoesPlano, #id)();
  DateTimeColumn get iniciadoEm => dateTime()();
  DateTimeColumn get finalizadoEm => dateTime().nullable()();
  TextColumn get status => text()
      .check(status.isIn(StatusTreino.todos))
      .withDefault(const Constant(StatusTreino.andamento))();
  TextColumn get modo => text()
      .check(modo.isIn(ModoTreino.todos))
      .withDefault(const Constant(ModoTreino.normal))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Plano e real lado a lado. `rir` nulo = a pessoa não respondeu.
@DataClassName('Serie')
class Series extends Table with ColunasSync {
  TextColumn get id => text()();
  TextColumn get treinoId => text().references(Treinos, #id)();
  TextColumn get itemPlanoId => text().nullable().references(ItensPlano, #id)();
  TextColumn get exercicioId => text().references(Exercicios, #id)();
  IntColumn get numero => integer()();
  RealColumn get cargaPlanKg => real().nullable()();
  IntColumn get repsPlan => integer().nullable()();
  RealColumn get cargaKg => real().nullable()();
  IntColumn get reps => integer().nullable()();
  IntColumn get rir => integer().nullable().check(rir.isBetweenValues(0, 4))();
  BoolColumn get confirmado => boolean().withDefault(const Constant(false))();
  BoolColumn get editado => boolean().withDefault(const Constant(false))();
  BoolColumn get dor => boolean().withDefault(const Constant(false))();
  DateTimeColumn get registradaEm => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Origem: botão "Ocupado".
@DataClassName('Substituicao')
class Substituicoes extends Table with ColunasSync {
  TextColumn get id => text()();
  TextColumn get usuarioId => text().nullable()();
  TextColumn get itemPlanoId => text().references(ItensPlano, #id)();
  @ReferenceName('substituicoesComoOriginal')
  TextColumn get exercicioOriginalId => text().references(Exercicios, #id)();
  @ReferenceName('substituicoesComoNovo')
  TextColumn get exercicioNovoId => text().references(Exercicios, #id)();
  TextColumn get escopo =>
      text().check(escopo.isIn(EscopoSubstituicao.todos))();

  @override
  Set<Column> get primaryKey => {id};
}
