// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExerciciosTable extends Exercicios
    with TableInfo<$ExerciciosTable, Exercicio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciciosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _musculosAlvoMeta = const VerificationMeta(
    'musculosAlvo',
  );
  @override
  late final GeneratedColumn<String> musculosAlvo = GeneratedColumn<String>(
    'musculos_alvo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _padraoMovimentoMeta = const VerificationMeta(
    'padraoMovimento',
  );
  @override
  late final GeneratedColumn<String> padraoMovimento = GeneratedColumn<String>(
    'padrao_movimento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipamentoMeta = const VerificationMeta(
    'equipamento',
  );
  @override
  late final GeneratedColumn<String> equipamento = GeneratedColumn<String>(
    'equipamento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoCargaMeta = const VerificationMeta(
    'tipoCarga',
  );
  @override
  late final GeneratedColumn<String> tipoCarga = GeneratedColumn<String>(
    'tipo_carga',
    aliasedName,
    false,
    check: () => tipoCarga.isIn(TipoCarga.todos),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passoCargaKgMeta = const VerificationMeta(
    'passoCargaKg',
  );
  @override
  late final GeneratedColumn<double> passoCargaKg = GeneratedColumn<double>(
    'passo_carga_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _videoUrlMeta = const VerificationMeta(
    'videoUrl',
  );
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
    'video_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fonteIdMeta = const VerificationMeta(
    'fonteId',
  );
  @override
  late final GeneratedColumn<String> fonteId = GeneratedColumn<String>(
    'fonte_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    musculosAlvo,
    padraoMovimento,
    equipamento,
    tipoCarga,
    passoCargaKg,
    videoUrl,
    fonteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercicios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercicio> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('musculos_alvo')) {
      context.handle(
        _musculosAlvoMeta,
        musculosAlvo.isAcceptableOrUnknown(
          data['musculos_alvo']!,
          _musculosAlvoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_musculosAlvoMeta);
    }
    if (data.containsKey('padrao_movimento')) {
      context.handle(
        _padraoMovimentoMeta,
        padraoMovimento.isAcceptableOrUnknown(
          data['padrao_movimento']!,
          _padraoMovimentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_padraoMovimentoMeta);
    }
    if (data.containsKey('equipamento')) {
      context.handle(
        _equipamentoMeta,
        equipamento.isAcceptableOrUnknown(
          data['equipamento']!,
          _equipamentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipamentoMeta);
    }
    if (data.containsKey('tipo_carga')) {
      context.handle(
        _tipoCargaMeta,
        tipoCarga.isAcceptableOrUnknown(data['tipo_carga']!, _tipoCargaMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoCargaMeta);
    }
    if (data.containsKey('passo_carga_kg')) {
      context.handle(
        _passoCargaKgMeta,
        passoCargaKg.isAcceptableOrUnknown(
          data['passo_carga_kg']!,
          _passoCargaKgMeta,
        ),
      );
    }
    if (data.containsKey('video_url')) {
      context.handle(
        _videoUrlMeta,
        videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta),
      );
    }
    if (data.containsKey('fonte_id')) {
      context.handle(
        _fonteIdMeta,
        fonteId.isAcceptableOrUnknown(data['fonte_id']!, _fonteIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercicio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercicio(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      musculosAlvo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}musculos_alvo'],
      )!,
      padraoMovimento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}padrao_movimento'],
      )!,
      equipamento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipamento'],
      )!,
      tipoCarga: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_carga'],
      )!,
      passoCargaKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}passo_carga_kg'],
      )!,
      videoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_url'],
      ),
      fonteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fonte_id'],
      ),
    );
  }

  @override
  $ExerciciosTable createAlias(String alias) {
    return $ExerciciosTable(attachedDatabase, alias);
  }
}

class Exercicio extends DataClass implements Insertable<Exercicio> {
  final String id;
  final String nome;

  /// Músculos separados por vírgula, do principal para o secundário.
  final String musculosAlvo;
  final String padraoMovimento;
  final String equipamento;
  final String tipoCarga;
  final double passoCargaKg;
  final String? videoUrl;
  final String? fonteId;
  const Exercicio({
    required this.id,
    required this.nome,
    required this.musculosAlvo,
    required this.padraoMovimento,
    required this.equipamento,
    required this.tipoCarga,
    required this.passoCargaKg,
    this.videoUrl,
    this.fonteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['musculos_alvo'] = Variable<String>(musculosAlvo);
    map['padrao_movimento'] = Variable<String>(padraoMovimento);
    map['equipamento'] = Variable<String>(equipamento);
    map['tipo_carga'] = Variable<String>(tipoCarga);
    map['passo_carga_kg'] = Variable<double>(passoCargaKg);
    if (!nullToAbsent || videoUrl != null) {
      map['video_url'] = Variable<String>(videoUrl);
    }
    if (!nullToAbsent || fonteId != null) {
      map['fonte_id'] = Variable<String>(fonteId);
    }
    return map;
  }

  ExerciciosCompanion toCompanion(bool nullToAbsent) {
    return ExerciciosCompanion(
      id: Value(id),
      nome: Value(nome),
      musculosAlvo: Value(musculosAlvo),
      padraoMovimento: Value(padraoMovimento),
      equipamento: Value(equipamento),
      tipoCarga: Value(tipoCarga),
      passoCargaKg: Value(passoCargaKg),
      videoUrl: videoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(videoUrl),
      fonteId: fonteId == null && nullToAbsent
          ? const Value.absent()
          : Value(fonteId),
    );
  }

  factory Exercicio.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercicio(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      musculosAlvo: serializer.fromJson<String>(json['musculosAlvo']),
      padraoMovimento: serializer.fromJson<String>(json['padraoMovimento']),
      equipamento: serializer.fromJson<String>(json['equipamento']),
      tipoCarga: serializer.fromJson<String>(json['tipoCarga']),
      passoCargaKg: serializer.fromJson<double>(json['passoCargaKg']),
      videoUrl: serializer.fromJson<String?>(json['videoUrl']),
      fonteId: serializer.fromJson<String?>(json['fonteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'musculosAlvo': serializer.toJson<String>(musculosAlvo),
      'padraoMovimento': serializer.toJson<String>(padraoMovimento),
      'equipamento': serializer.toJson<String>(equipamento),
      'tipoCarga': serializer.toJson<String>(tipoCarga),
      'passoCargaKg': serializer.toJson<double>(passoCargaKg),
      'videoUrl': serializer.toJson<String?>(videoUrl),
      'fonteId': serializer.toJson<String?>(fonteId),
    };
  }

  Exercicio copyWith({
    String? id,
    String? nome,
    String? musculosAlvo,
    String? padraoMovimento,
    String? equipamento,
    String? tipoCarga,
    double? passoCargaKg,
    Value<String?> videoUrl = const Value.absent(),
    Value<String?> fonteId = const Value.absent(),
  }) => Exercicio(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    musculosAlvo: musculosAlvo ?? this.musculosAlvo,
    padraoMovimento: padraoMovimento ?? this.padraoMovimento,
    equipamento: equipamento ?? this.equipamento,
    tipoCarga: tipoCarga ?? this.tipoCarga,
    passoCargaKg: passoCargaKg ?? this.passoCargaKg,
    videoUrl: videoUrl.present ? videoUrl.value : this.videoUrl,
    fonteId: fonteId.present ? fonteId.value : this.fonteId,
  );
  Exercicio copyWithCompanion(ExerciciosCompanion data) {
    return Exercicio(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      musculosAlvo: data.musculosAlvo.present
          ? data.musculosAlvo.value
          : this.musculosAlvo,
      padraoMovimento: data.padraoMovimento.present
          ? data.padraoMovimento.value
          : this.padraoMovimento,
      equipamento: data.equipamento.present
          ? data.equipamento.value
          : this.equipamento,
      tipoCarga: data.tipoCarga.present ? data.tipoCarga.value : this.tipoCarga,
      passoCargaKg: data.passoCargaKg.present
          ? data.passoCargaKg.value
          : this.passoCargaKg,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
      fonteId: data.fonteId.present ? data.fonteId.value : this.fonteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercicio(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('musculosAlvo: $musculosAlvo, ')
          ..write('padraoMovimento: $padraoMovimento, ')
          ..write('equipamento: $equipamento, ')
          ..write('tipoCarga: $tipoCarga, ')
          ..write('passoCargaKg: $passoCargaKg, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('fonteId: $fonteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    musculosAlvo,
    padraoMovimento,
    equipamento,
    tipoCarga,
    passoCargaKg,
    videoUrl,
    fonteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercicio &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.musculosAlvo == this.musculosAlvo &&
          other.padraoMovimento == this.padraoMovimento &&
          other.equipamento == this.equipamento &&
          other.tipoCarga == this.tipoCarga &&
          other.passoCargaKg == this.passoCargaKg &&
          other.videoUrl == this.videoUrl &&
          other.fonteId == this.fonteId);
}

class ExerciciosCompanion extends UpdateCompanion<Exercicio> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String> musculosAlvo;
  final Value<String> padraoMovimento;
  final Value<String> equipamento;
  final Value<String> tipoCarga;
  final Value<double> passoCargaKg;
  final Value<String?> videoUrl;
  final Value<String?> fonteId;
  final Value<int> rowid;
  const ExerciciosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.musculosAlvo = const Value.absent(),
    this.padraoMovimento = const Value.absent(),
    this.equipamento = const Value.absent(),
    this.tipoCarga = const Value.absent(),
    this.passoCargaKg = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.fonteId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciciosCompanion.insert({
    required String id,
    required String nome,
    required String musculosAlvo,
    required String padraoMovimento,
    required String equipamento,
    required String tipoCarga,
    this.passoCargaKg = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.fonteId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nome = Value(nome),
       musculosAlvo = Value(musculosAlvo),
       padraoMovimento = Value(padraoMovimento),
       equipamento = Value(equipamento),
       tipoCarga = Value(tipoCarga);
  static Insertable<Exercicio> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? musculosAlvo,
    Expression<String>? padraoMovimento,
    Expression<String>? equipamento,
    Expression<String>? tipoCarga,
    Expression<double>? passoCargaKg,
    Expression<String>? videoUrl,
    Expression<String>? fonteId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (musculosAlvo != null) 'musculos_alvo': musculosAlvo,
      if (padraoMovimento != null) 'padrao_movimento': padraoMovimento,
      if (equipamento != null) 'equipamento': equipamento,
      if (tipoCarga != null) 'tipo_carga': tipoCarga,
      if (passoCargaKg != null) 'passo_carga_kg': passoCargaKg,
      if (videoUrl != null) 'video_url': videoUrl,
      if (fonteId != null) 'fonte_id': fonteId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciciosCompanion copyWith({
    Value<String>? id,
    Value<String>? nome,
    Value<String>? musculosAlvo,
    Value<String>? padraoMovimento,
    Value<String>? equipamento,
    Value<String>? tipoCarga,
    Value<double>? passoCargaKg,
    Value<String?>? videoUrl,
    Value<String?>? fonteId,
    Value<int>? rowid,
  }) {
    return ExerciciosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      musculosAlvo: musculosAlvo ?? this.musculosAlvo,
      padraoMovimento: padraoMovimento ?? this.padraoMovimento,
      equipamento: equipamento ?? this.equipamento,
      tipoCarga: tipoCarga ?? this.tipoCarga,
      passoCargaKg: passoCargaKg ?? this.passoCargaKg,
      videoUrl: videoUrl ?? this.videoUrl,
      fonteId: fonteId ?? this.fonteId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (musculosAlvo.present) {
      map['musculos_alvo'] = Variable<String>(musculosAlvo.value);
    }
    if (padraoMovimento.present) {
      map['padrao_movimento'] = Variable<String>(padraoMovimento.value);
    }
    if (equipamento.present) {
      map['equipamento'] = Variable<String>(equipamento.value);
    }
    if (tipoCarga.present) {
      map['tipo_carga'] = Variable<String>(tipoCarga.value);
    }
    if (passoCargaKg.present) {
      map['passo_carga_kg'] = Variable<double>(passoCargaKg.value);
    }
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
    }
    if (fonteId.present) {
      map['fonte_id'] = Variable<String>(fonteId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciciosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('musculosAlvo: $musculosAlvo, ')
          ..write('padraoMovimento: $padraoMovimento, ')
          ..write('equipamento: $equipamento, ')
          ..write('tipoCarga: $tipoCarga, ')
          ..write('passoCargaKg: $passoCargaKg, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('fonteId: $fonteId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanosTreinoTable extends PlanosTreino
    with TableInfo<$PlanosTreinoTable, PlanoTreino> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanosTreinoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _excluidoEmMeta = const VerificationMeta(
    'excluidoEm',
  );
  @override
  late final GeneratedColumn<DateTime> excluidoEm = GeneratedColumn<DateTime>(
    'excluido_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sincronizadoEmMeta = const VerificationMeta(
    'sincronizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> sincronizadoEm =
      GeneratedColumn<DateTime>(
        'sincronizado_em',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _divisaoMeta = const VerificationMeta(
    'divisao',
  );
  @override
  late final GeneratedColumn<String> divisao = GeneratedColumn<String>(
    'divisao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _semanasMeta = const VerificationMeta(
    'semanas',
  );
  @override
  late final GeneratedColumn<int> semanas = GeneratedColumn<int>(
    'semanas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inicioEmMeta = const VerificationMeta(
    'inicioEm',
  );
  @override
  late final GeneratedColumn<DateTime> inicioEm = GeneratedColumn<DateTime>(
    'inicio_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versaoMeta = const VerificationMeta('versao');
  @override
  late final GeneratedColumn<int> versao = GeneratedColumn<int>(
    'versao',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    usuarioId,
    divisao,
    semanas,
    inicioEm,
    versao,
    ativo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planos_treino';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanoTreino> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('excluido_em')) {
      context.handle(
        _excluidoEmMeta,
        excluidoEm.isAcceptableOrUnknown(data['excluido_em']!, _excluidoEmMeta),
      );
    }
    if (data.containsKey('sincronizado_em')) {
      context.handle(
        _sincronizadoEmMeta,
        sincronizadoEm.isAcceptableOrUnknown(
          data['sincronizado_em']!,
          _sincronizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    }
    if (data.containsKey('divisao')) {
      context.handle(
        _divisaoMeta,
        divisao.isAcceptableOrUnknown(data['divisao']!, _divisaoMeta),
      );
    } else if (isInserting) {
      context.missing(_divisaoMeta);
    }
    if (data.containsKey('semanas')) {
      context.handle(
        _semanasMeta,
        semanas.isAcceptableOrUnknown(data['semanas']!, _semanasMeta),
      );
    } else if (isInserting) {
      context.missing(_semanasMeta);
    }
    if (data.containsKey('inicio_em')) {
      context.handle(
        _inicioEmMeta,
        inicioEm.isAcceptableOrUnknown(data['inicio_em']!, _inicioEmMeta),
      );
    } else if (isInserting) {
      context.missing(_inicioEmMeta);
    }
    if (data.containsKey('versao')) {
      context.handle(
        _versaoMeta,
        versao.isAcceptableOrUnknown(data['versao']!, _versaoMeta),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanoTreino map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanoTreino(
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
      excluidoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}excluido_em'],
      ),
      sincronizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sincronizado_em'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      ),
      divisao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}divisao'],
      )!,
      semanas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}semanas'],
      )!,
      inicioEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}inicio_em'],
      )!,
      versao: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}versao'],
      )!,
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
    );
  }

  @override
  $PlanosTreinoTable createAlias(String alias) {
    return $PlanosTreinoTable(attachedDatabase, alias);
  }
}

class PlanoTreino extends DataClass implements Insertable<PlanoTreino> {
  final DateTime atualizadoEm;
  final DateTime? excluidoEm;
  final DateTime? sincronizadoEm;
  final String id;

  /// Nulo até a pessoa entrar com a conta; o app funciona sem login.
  final String? usuarioId;
  final String divisao;
  final int semanas;
  final DateTime inicioEm;
  final int versao;
  final bool ativo;
  const PlanoTreino({
    required this.atualizadoEm,
    this.excluidoEm,
    this.sincronizadoEm,
    required this.id,
    this.usuarioId,
    required this.divisao,
    required this.semanas,
    required this.inicioEm,
    required this.versao,
    required this.ativo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    if (!nullToAbsent || excluidoEm != null) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm);
    }
    if (!nullToAbsent || sincronizadoEm != null) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || usuarioId != null) {
      map['usuario_id'] = Variable<String>(usuarioId);
    }
    map['divisao'] = Variable<String>(divisao);
    map['semanas'] = Variable<int>(semanas);
    map['inicio_em'] = Variable<DateTime>(inicioEm);
    map['versao'] = Variable<int>(versao);
    map['ativo'] = Variable<bool>(ativo);
    return map;
  }

  PlanosTreinoCompanion toCompanion(bool nullToAbsent) {
    return PlanosTreinoCompanion(
      atualizadoEm: Value(atualizadoEm),
      excluidoEm: excluidoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(excluidoEm),
      sincronizadoEm: sincronizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(sincronizadoEm),
      id: Value(id),
      usuarioId: usuarioId == null && nullToAbsent
          ? const Value.absent()
          : Value(usuarioId),
      divisao: Value(divisao),
      semanas: Value(semanas),
      inicioEm: Value(inicioEm),
      versao: Value(versao),
      ativo: Value(ativo),
    );
  }

  factory PlanoTreino.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanoTreino(
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
      excluidoEm: serializer.fromJson<DateTime?>(json['excluidoEm']),
      sincronizadoEm: serializer.fromJson<DateTime?>(json['sincronizadoEm']),
      id: serializer.fromJson<String>(json['id']),
      usuarioId: serializer.fromJson<String?>(json['usuarioId']),
      divisao: serializer.fromJson<String>(json['divisao']),
      semanas: serializer.fromJson<int>(json['semanas']),
      inicioEm: serializer.fromJson<DateTime>(json['inicioEm']),
      versao: serializer.fromJson<int>(json['versao']),
      ativo: serializer.fromJson<bool>(json['ativo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
      'excluidoEm': serializer.toJson<DateTime?>(excluidoEm),
      'sincronizadoEm': serializer.toJson<DateTime?>(sincronizadoEm),
      'id': serializer.toJson<String>(id),
      'usuarioId': serializer.toJson<String?>(usuarioId),
      'divisao': serializer.toJson<String>(divisao),
      'semanas': serializer.toJson<int>(semanas),
      'inicioEm': serializer.toJson<DateTime>(inicioEm),
      'versao': serializer.toJson<int>(versao),
      'ativo': serializer.toJson<bool>(ativo),
    };
  }

  PlanoTreino copyWith({
    DateTime? atualizadoEm,
    Value<DateTime?> excluidoEm = const Value.absent(),
    Value<DateTime?> sincronizadoEm = const Value.absent(),
    String? id,
    Value<String?> usuarioId = const Value.absent(),
    String? divisao,
    int? semanas,
    DateTime? inicioEm,
    int? versao,
    bool? ativo,
  }) => PlanoTreino(
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    excluidoEm: excluidoEm.present ? excluidoEm.value : this.excluidoEm,
    sincronizadoEm: sincronizadoEm.present
        ? sincronizadoEm.value
        : this.sincronizadoEm,
    id: id ?? this.id,
    usuarioId: usuarioId.present ? usuarioId.value : this.usuarioId,
    divisao: divisao ?? this.divisao,
    semanas: semanas ?? this.semanas,
    inicioEm: inicioEm ?? this.inicioEm,
    versao: versao ?? this.versao,
    ativo: ativo ?? this.ativo,
  );
  PlanoTreino copyWithCompanion(PlanosTreinoCompanion data) {
    return PlanoTreino(
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
      excluidoEm: data.excluidoEm.present
          ? data.excluidoEm.value
          : this.excluidoEm,
      sincronizadoEm: data.sincronizadoEm.present
          ? data.sincronizadoEm.value
          : this.sincronizadoEm,
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      divisao: data.divisao.present ? data.divisao.value : this.divisao,
      semanas: data.semanas.present ? data.semanas.value : this.semanas,
      inicioEm: data.inicioEm.present ? data.inicioEm.value : this.inicioEm,
      versao: data.versao.present ? data.versao.value : this.versao,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanoTreino(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('divisao: $divisao, ')
          ..write('semanas: $semanas, ')
          ..write('inicioEm: $inicioEm, ')
          ..write('versao: $versao, ')
          ..write('ativo: $ativo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    usuarioId,
    divisao,
    semanas,
    inicioEm,
    versao,
    ativo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanoTreino &&
          other.atualizadoEm == this.atualizadoEm &&
          other.excluidoEm == this.excluidoEm &&
          other.sincronizadoEm == this.sincronizadoEm &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.divisao == this.divisao &&
          other.semanas == this.semanas &&
          other.inicioEm == this.inicioEm &&
          other.versao == this.versao &&
          other.ativo == this.ativo);
}

class PlanosTreinoCompanion extends UpdateCompanion<PlanoTreino> {
  final Value<DateTime> atualizadoEm;
  final Value<DateTime?> excluidoEm;
  final Value<DateTime?> sincronizadoEm;
  final Value<String> id;
  final Value<String?> usuarioId;
  final Value<String> divisao;
  final Value<int> semanas;
  final Value<DateTime> inicioEm;
  final Value<int> versao;
  final Value<bool> ativo;
  final Value<int> rowid;
  const PlanosTreinoCompanion({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.divisao = const Value.absent(),
    this.semanas = const Value.absent(),
    this.inicioEm = const Value.absent(),
    this.versao = const Value.absent(),
    this.ativo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanosTreinoCompanion.insert({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    required String id,
    this.usuarioId = const Value.absent(),
    required String divisao,
    required int semanas,
    required DateTime inicioEm,
    this.versao = const Value.absent(),
    this.ativo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       divisao = Value(divisao),
       semanas = Value(semanas),
       inicioEm = Value(inicioEm);
  static Insertable<PlanoTreino> custom({
    Expression<DateTime>? atualizadoEm,
    Expression<DateTime>? excluidoEm,
    Expression<DateTime>? sincronizadoEm,
    Expression<String>? id,
    Expression<String>? usuarioId,
    Expression<String>? divisao,
    Expression<int>? semanas,
    Expression<DateTime>? inicioEm,
    Expression<int>? versao,
    Expression<bool>? ativo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (excluidoEm != null) 'excluido_em': excluidoEm,
      if (sincronizadoEm != null) 'sincronizado_em': sincronizadoEm,
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (divisao != null) 'divisao': divisao,
      if (semanas != null) 'semanas': semanas,
      if (inicioEm != null) 'inicio_em': inicioEm,
      if (versao != null) 'versao': versao,
      if (ativo != null) 'ativo': ativo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanosTreinoCompanion copyWith({
    Value<DateTime>? atualizadoEm,
    Value<DateTime?>? excluidoEm,
    Value<DateTime?>? sincronizadoEm,
    Value<String>? id,
    Value<String?>? usuarioId,
    Value<String>? divisao,
    Value<int>? semanas,
    Value<DateTime>? inicioEm,
    Value<int>? versao,
    Value<bool>? ativo,
    Value<int>? rowid,
  }) {
    return PlanosTreinoCompanion(
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      excluidoEm: excluidoEm ?? this.excluidoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      divisao: divisao ?? this.divisao,
      semanas: semanas ?? this.semanas,
      inicioEm: inicioEm ?? this.inicioEm,
      versao: versao ?? this.versao,
      ativo: ativo ?? this.ativo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (excluidoEm.present) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm.value);
    }
    if (sincronizadoEm.present) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (divisao.present) {
      map['divisao'] = Variable<String>(divisao.value);
    }
    if (semanas.present) {
      map['semanas'] = Variable<int>(semanas.value);
    }
    if (inicioEm.present) {
      map['inicio_em'] = Variable<DateTime>(inicioEm.value);
    }
    if (versao.present) {
      map['versao'] = Variable<int>(versao.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanosTreinoCompanion(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('divisao: $divisao, ')
          ..write('semanas: $semanas, ')
          ..write('inicioEm: $inicioEm, ')
          ..write('versao: $versao, ')
          ..write('ativo: $ativo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessoesPlanoTable extends SessoesPlano
    with TableInfo<$SessoesPlanoTable, SessaoPlano> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessoesPlanoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _excluidoEmMeta = const VerificationMeta(
    'excluidoEm',
  );
  @override
  late final GeneratedColumn<DateTime> excluidoEm = GeneratedColumn<DateTime>(
    'excluido_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sincronizadoEmMeta = const VerificationMeta(
    'sincronizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> sincronizadoEm =
      GeneratedColumn<DateTime>(
        'sincronizado_em',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planoIdMeta = const VerificationMeta(
    'planoId',
  );
  @override
  late final GeneratedColumn<String> planoId = GeneratedColumn<String>(
    'plano_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES planos_treino (id)',
    ),
  );
  static const VerificationMeta _diaMeta = const VerificationMeta('dia');
  @override
  late final GeneratedColumn<String> dia = GeneratedColumn<String>(
    'dia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focoMeta = const VerificationMeta('foco');
  @override
  late final GeneratedColumn<String> foco = GeneratedColumn<String>(
    'foco',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    planoId,
    dia,
    foco,
    ordem,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessoes_plano';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessaoPlano> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('excluido_em')) {
      context.handle(
        _excluidoEmMeta,
        excluidoEm.isAcceptableOrUnknown(data['excluido_em']!, _excluidoEmMeta),
      );
    }
    if (data.containsKey('sincronizado_em')) {
      context.handle(
        _sincronizadoEmMeta,
        sincronizadoEm.isAcceptableOrUnknown(
          data['sincronizado_em']!,
          _sincronizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plano_id')) {
      context.handle(
        _planoIdMeta,
        planoId.isAcceptableOrUnknown(data['plano_id']!, _planoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planoIdMeta);
    }
    if (data.containsKey('dia')) {
      context.handle(
        _diaMeta,
        dia.isAcceptableOrUnknown(data['dia']!, _diaMeta),
      );
    } else if (isInserting) {
      context.missing(_diaMeta);
    }
    if (data.containsKey('foco')) {
      context.handle(
        _focoMeta,
        foco.isAcceptableOrUnknown(data['foco']!, _focoMeta),
      );
    } else if (isInserting) {
      context.missing(_focoMeta);
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    } else if (isInserting) {
      context.missing(_ordemMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessaoPlano map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessaoPlano(
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
      excluidoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}excluido_em'],
      ),
      sincronizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sincronizado_em'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plano_id'],
      )!,
      dia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dia'],
      )!,
      foco: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foco'],
      )!,
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
    );
  }

  @override
  $SessoesPlanoTable createAlias(String alias) {
    return $SessoesPlanoTable(attachedDatabase, alias);
  }
}

class SessaoPlano extends DataClass implements Insertable<SessaoPlano> {
  final DateTime atualizadoEm;
  final DateTime? excluidoEm;
  final DateTime? sincronizadoEm;
  final String id;
  final String planoId;
  final String dia;
  final String foco;
  final int ordem;
  const SessaoPlano({
    required this.atualizadoEm,
    this.excluidoEm,
    this.sincronizadoEm,
    required this.id,
    required this.planoId,
    required this.dia,
    required this.foco,
    required this.ordem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    if (!nullToAbsent || excluidoEm != null) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm);
    }
    if (!nullToAbsent || sincronizadoEm != null) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm);
    }
    map['id'] = Variable<String>(id);
    map['plano_id'] = Variable<String>(planoId);
    map['dia'] = Variable<String>(dia);
    map['foco'] = Variable<String>(foco);
    map['ordem'] = Variable<int>(ordem);
    return map;
  }

  SessoesPlanoCompanion toCompanion(bool nullToAbsent) {
    return SessoesPlanoCompanion(
      atualizadoEm: Value(atualizadoEm),
      excluidoEm: excluidoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(excluidoEm),
      sincronizadoEm: sincronizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(sincronizadoEm),
      id: Value(id),
      planoId: Value(planoId),
      dia: Value(dia),
      foco: Value(foco),
      ordem: Value(ordem),
    );
  }

  factory SessaoPlano.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessaoPlano(
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
      excluidoEm: serializer.fromJson<DateTime?>(json['excluidoEm']),
      sincronizadoEm: serializer.fromJson<DateTime?>(json['sincronizadoEm']),
      id: serializer.fromJson<String>(json['id']),
      planoId: serializer.fromJson<String>(json['planoId']),
      dia: serializer.fromJson<String>(json['dia']),
      foco: serializer.fromJson<String>(json['foco']),
      ordem: serializer.fromJson<int>(json['ordem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
      'excluidoEm': serializer.toJson<DateTime?>(excluidoEm),
      'sincronizadoEm': serializer.toJson<DateTime?>(sincronizadoEm),
      'id': serializer.toJson<String>(id),
      'planoId': serializer.toJson<String>(planoId),
      'dia': serializer.toJson<String>(dia),
      'foco': serializer.toJson<String>(foco),
      'ordem': serializer.toJson<int>(ordem),
    };
  }

  SessaoPlano copyWith({
    DateTime? atualizadoEm,
    Value<DateTime?> excluidoEm = const Value.absent(),
    Value<DateTime?> sincronizadoEm = const Value.absent(),
    String? id,
    String? planoId,
    String? dia,
    String? foco,
    int? ordem,
  }) => SessaoPlano(
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    excluidoEm: excluidoEm.present ? excluidoEm.value : this.excluidoEm,
    sincronizadoEm: sincronizadoEm.present
        ? sincronizadoEm.value
        : this.sincronizadoEm,
    id: id ?? this.id,
    planoId: planoId ?? this.planoId,
    dia: dia ?? this.dia,
    foco: foco ?? this.foco,
    ordem: ordem ?? this.ordem,
  );
  SessaoPlano copyWithCompanion(SessoesPlanoCompanion data) {
    return SessaoPlano(
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
      excluidoEm: data.excluidoEm.present
          ? data.excluidoEm.value
          : this.excluidoEm,
      sincronizadoEm: data.sincronizadoEm.present
          ? data.sincronizadoEm.value
          : this.sincronizadoEm,
      id: data.id.present ? data.id.value : this.id,
      planoId: data.planoId.present ? data.planoId.value : this.planoId,
      dia: data.dia.present ? data.dia.value : this.dia,
      foco: data.foco.present ? data.foco.value : this.foco,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessaoPlano(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('planoId: $planoId, ')
          ..write('dia: $dia, ')
          ..write('foco: $foco, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    planoId,
    dia,
    foco,
    ordem,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessaoPlano &&
          other.atualizadoEm == this.atualizadoEm &&
          other.excluidoEm == this.excluidoEm &&
          other.sincronizadoEm == this.sincronizadoEm &&
          other.id == this.id &&
          other.planoId == this.planoId &&
          other.dia == this.dia &&
          other.foco == this.foco &&
          other.ordem == this.ordem);
}

class SessoesPlanoCompanion extends UpdateCompanion<SessaoPlano> {
  final Value<DateTime> atualizadoEm;
  final Value<DateTime?> excluidoEm;
  final Value<DateTime?> sincronizadoEm;
  final Value<String> id;
  final Value<String> planoId;
  final Value<String> dia;
  final Value<String> foco;
  final Value<int> ordem;
  final Value<int> rowid;
  const SessoesPlanoCompanion({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    this.id = const Value.absent(),
    this.planoId = const Value.absent(),
    this.dia = const Value.absent(),
    this.foco = const Value.absent(),
    this.ordem = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessoesPlanoCompanion.insert({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    required String id,
    required String planoId,
    required String dia,
    required String foco,
    required int ordem,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       planoId = Value(planoId),
       dia = Value(dia),
       foco = Value(foco),
       ordem = Value(ordem);
  static Insertable<SessaoPlano> custom({
    Expression<DateTime>? atualizadoEm,
    Expression<DateTime>? excluidoEm,
    Expression<DateTime>? sincronizadoEm,
    Expression<String>? id,
    Expression<String>? planoId,
    Expression<String>? dia,
    Expression<String>? foco,
    Expression<int>? ordem,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (excluidoEm != null) 'excluido_em': excluidoEm,
      if (sincronizadoEm != null) 'sincronizado_em': sincronizadoEm,
      if (id != null) 'id': id,
      if (planoId != null) 'plano_id': planoId,
      if (dia != null) 'dia': dia,
      if (foco != null) 'foco': foco,
      if (ordem != null) 'ordem': ordem,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessoesPlanoCompanion copyWith({
    Value<DateTime>? atualizadoEm,
    Value<DateTime?>? excluidoEm,
    Value<DateTime?>? sincronizadoEm,
    Value<String>? id,
    Value<String>? planoId,
    Value<String>? dia,
    Value<String>? foco,
    Value<int>? ordem,
    Value<int>? rowid,
  }) {
    return SessoesPlanoCompanion(
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      excluidoEm: excluidoEm ?? this.excluidoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
      id: id ?? this.id,
      planoId: planoId ?? this.planoId,
      dia: dia ?? this.dia,
      foco: foco ?? this.foco,
      ordem: ordem ?? this.ordem,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (excluidoEm.present) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm.value);
    }
    if (sincronizadoEm.present) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planoId.present) {
      map['plano_id'] = Variable<String>(planoId.value);
    }
    if (dia.present) {
      map['dia'] = Variable<String>(dia.value);
    }
    if (foco.present) {
      map['foco'] = Variable<String>(foco.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessoesPlanoCompanion(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('planoId: $planoId, ')
          ..write('dia: $dia, ')
          ..write('foco: $foco, ')
          ..write('ordem: $ordem, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItensPlanoTable extends ItensPlano
    with TableInfo<$ItensPlanoTable, ItemPlano> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItensPlanoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _excluidoEmMeta = const VerificationMeta(
    'excluidoEm',
  );
  @override
  late final GeneratedColumn<DateTime> excluidoEm = GeneratedColumn<DateTime>(
    'excluido_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sincronizadoEmMeta = const VerificationMeta(
    'sincronizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> sincronizadoEm =
      GeneratedColumn<DateTime>(
        'sincronizado_em',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessaoPlanoIdMeta = const VerificationMeta(
    'sessaoPlanoId',
  );
  @override
  late final GeneratedColumn<String> sessaoPlanoId = GeneratedColumn<String>(
    'sessao_plano_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessoes_plano (id)',
    ),
  );
  static const VerificationMeta _exercicioIdMeta = const VerificationMeta(
    'exercicioId',
  );
  @override
  late final GeneratedColumn<String> exercicioId = GeneratedColumn<String>(
    'exercicio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercicios (id)',
    ),
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seriesMeta = const VerificationMeta('series');
  @override
  late final GeneratedColumn<int> series = GeneratedColumn<int>(
    'series',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMinMeta = const VerificationMeta(
    'repsMin',
  );
  @override
  late final GeneratedColumn<int> repsMin = GeneratedColumn<int>(
    'reps_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMaxMeta = const VerificationMeta(
    'repsMax',
  );
  @override
  late final GeneratedColumn<int> repsMax = GeneratedColumn<int>(
    'reps_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rirAlvoMeta = const VerificationMeta(
    'rirAlvo',
  );
  @override
  late final GeneratedColumn<int> rirAlvo = GeneratedColumn<int>(
    'rir_alvo',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descansoSMeta = const VerificationMeta(
    'descansoS',
  );
  @override
  late final GeneratedColumn<int> descansoS = GeneratedColumn<int>(
    'descanso_s',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cargaPlanKgMeta = const VerificationMeta(
    'cargaPlanKg',
  );
  @override
  late final GeneratedColumn<double> cargaPlanKg = GeneratedColumn<double>(
    'carga_plan_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _justificativaMeta = const VerificationMeta(
    'justificativa',
  );
  @override
  late final GeneratedColumn<String> justificativa = GeneratedColumn<String>(
    'justificativa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fonteIdMeta = const VerificationMeta(
    'fonteId',
  );
  @override
  late final GeneratedColumn<String> fonteId = GeneratedColumn<String>(
    'fonte_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    sessaoPlanoId,
    exercicioId,
    ordem,
    series,
    repsMin,
    repsMax,
    rirAlvo,
    descansoS,
    cargaPlanKg,
    justificativa,
    fonteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'itens_plano';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemPlano> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('excluido_em')) {
      context.handle(
        _excluidoEmMeta,
        excluidoEm.isAcceptableOrUnknown(data['excluido_em']!, _excluidoEmMeta),
      );
    }
    if (data.containsKey('sincronizado_em')) {
      context.handle(
        _sincronizadoEmMeta,
        sincronizadoEm.isAcceptableOrUnknown(
          data['sincronizado_em']!,
          _sincronizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sessao_plano_id')) {
      context.handle(
        _sessaoPlanoIdMeta,
        sessaoPlanoId.isAcceptableOrUnknown(
          data['sessao_plano_id']!,
          _sessaoPlanoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessaoPlanoIdMeta);
    }
    if (data.containsKey('exercicio_id')) {
      context.handle(
        _exercicioIdMeta,
        exercicioId.isAcceptableOrUnknown(
          data['exercicio_id']!,
          _exercicioIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exercicioIdMeta);
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    } else if (isInserting) {
      context.missing(_ordemMeta);
    }
    if (data.containsKey('series')) {
      context.handle(
        _seriesMeta,
        series.isAcceptableOrUnknown(data['series']!, _seriesMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesMeta);
    }
    if (data.containsKey('reps_min')) {
      context.handle(
        _repsMinMeta,
        repsMin.isAcceptableOrUnknown(data['reps_min']!, _repsMinMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMinMeta);
    }
    if (data.containsKey('reps_max')) {
      context.handle(
        _repsMaxMeta,
        repsMax.isAcceptableOrUnknown(data['reps_max']!, _repsMaxMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMaxMeta);
    }
    if (data.containsKey('rir_alvo')) {
      context.handle(
        _rirAlvoMeta,
        rirAlvo.isAcceptableOrUnknown(data['rir_alvo']!, _rirAlvoMeta),
      );
    }
    if (data.containsKey('descanso_s')) {
      context.handle(
        _descansoSMeta,
        descansoS.isAcceptableOrUnknown(data['descanso_s']!, _descansoSMeta),
      );
    } else if (isInserting) {
      context.missing(_descansoSMeta);
    }
    if (data.containsKey('carga_plan_kg')) {
      context.handle(
        _cargaPlanKgMeta,
        cargaPlanKg.isAcceptableOrUnknown(
          data['carga_plan_kg']!,
          _cargaPlanKgMeta,
        ),
      );
    }
    if (data.containsKey('justificativa')) {
      context.handle(
        _justificativaMeta,
        justificativa.isAcceptableOrUnknown(
          data['justificativa']!,
          _justificativaMeta,
        ),
      );
    }
    if (data.containsKey('fonte_id')) {
      context.handle(
        _fonteIdMeta,
        fonteId.isAcceptableOrUnknown(data['fonte_id']!, _fonteIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemPlano map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemPlano(
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
      excluidoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}excluido_em'],
      ),
      sincronizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sincronizado_em'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessaoPlanoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sessao_plano_id'],
      )!,
      exercicioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercicio_id'],
      )!,
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
      series: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}series'],
      )!,
      repsMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps_min'],
      )!,
      repsMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps_max'],
      )!,
      rirAlvo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rir_alvo'],
      ),
      descansoS: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}descanso_s'],
      )!,
      cargaPlanKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carga_plan_kg'],
      ),
      justificativa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}justificativa'],
      ),
      fonteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fonte_id'],
      ),
    );
  }

  @override
  $ItensPlanoTable createAlias(String alias) {
    return $ItensPlanoTable(attachedDatabase, alias);
  }
}

class ItemPlano extends DataClass implements Insertable<ItemPlano> {
  final DateTime atualizadoEm;
  final DateTime? excluidoEm;
  final DateTime? sincronizadoEm;
  final String id;
  final String sessaoPlanoId;
  final String exercicioId;
  final int ordem;
  final int series;

  /// Para exercícios por tempo, a faixa é em segundos.
  final int repsMin;
  final int repsMax;
  final int? rirAlvo;
  final int descansoS;

  /// Recalculada pela progressão. Nula em exercícios sem carga externa.
  final double? cargaPlanKg;
  final String? justificativa;
  final String? fonteId;
  const ItemPlano({
    required this.atualizadoEm,
    this.excluidoEm,
    this.sincronizadoEm,
    required this.id,
    required this.sessaoPlanoId,
    required this.exercicioId,
    required this.ordem,
    required this.series,
    required this.repsMin,
    required this.repsMax,
    this.rirAlvo,
    required this.descansoS,
    this.cargaPlanKg,
    this.justificativa,
    this.fonteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    if (!nullToAbsent || excluidoEm != null) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm);
    }
    if (!nullToAbsent || sincronizadoEm != null) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm);
    }
    map['id'] = Variable<String>(id);
    map['sessao_plano_id'] = Variable<String>(sessaoPlanoId);
    map['exercicio_id'] = Variable<String>(exercicioId);
    map['ordem'] = Variable<int>(ordem);
    map['series'] = Variable<int>(series);
    map['reps_min'] = Variable<int>(repsMin);
    map['reps_max'] = Variable<int>(repsMax);
    if (!nullToAbsent || rirAlvo != null) {
      map['rir_alvo'] = Variable<int>(rirAlvo);
    }
    map['descanso_s'] = Variable<int>(descansoS);
    if (!nullToAbsent || cargaPlanKg != null) {
      map['carga_plan_kg'] = Variable<double>(cargaPlanKg);
    }
    if (!nullToAbsent || justificativa != null) {
      map['justificativa'] = Variable<String>(justificativa);
    }
    if (!nullToAbsent || fonteId != null) {
      map['fonte_id'] = Variable<String>(fonteId);
    }
    return map;
  }

  ItensPlanoCompanion toCompanion(bool nullToAbsent) {
    return ItensPlanoCompanion(
      atualizadoEm: Value(atualizadoEm),
      excluidoEm: excluidoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(excluidoEm),
      sincronizadoEm: sincronizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(sincronizadoEm),
      id: Value(id),
      sessaoPlanoId: Value(sessaoPlanoId),
      exercicioId: Value(exercicioId),
      ordem: Value(ordem),
      series: Value(series),
      repsMin: Value(repsMin),
      repsMax: Value(repsMax),
      rirAlvo: rirAlvo == null && nullToAbsent
          ? const Value.absent()
          : Value(rirAlvo),
      descansoS: Value(descansoS),
      cargaPlanKg: cargaPlanKg == null && nullToAbsent
          ? const Value.absent()
          : Value(cargaPlanKg),
      justificativa: justificativa == null && nullToAbsent
          ? const Value.absent()
          : Value(justificativa),
      fonteId: fonteId == null && nullToAbsent
          ? const Value.absent()
          : Value(fonteId),
    );
  }

  factory ItemPlano.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemPlano(
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
      excluidoEm: serializer.fromJson<DateTime?>(json['excluidoEm']),
      sincronizadoEm: serializer.fromJson<DateTime?>(json['sincronizadoEm']),
      id: serializer.fromJson<String>(json['id']),
      sessaoPlanoId: serializer.fromJson<String>(json['sessaoPlanoId']),
      exercicioId: serializer.fromJson<String>(json['exercicioId']),
      ordem: serializer.fromJson<int>(json['ordem']),
      series: serializer.fromJson<int>(json['series']),
      repsMin: serializer.fromJson<int>(json['repsMin']),
      repsMax: serializer.fromJson<int>(json['repsMax']),
      rirAlvo: serializer.fromJson<int?>(json['rirAlvo']),
      descansoS: serializer.fromJson<int>(json['descansoS']),
      cargaPlanKg: serializer.fromJson<double?>(json['cargaPlanKg']),
      justificativa: serializer.fromJson<String?>(json['justificativa']),
      fonteId: serializer.fromJson<String?>(json['fonteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
      'excluidoEm': serializer.toJson<DateTime?>(excluidoEm),
      'sincronizadoEm': serializer.toJson<DateTime?>(sincronizadoEm),
      'id': serializer.toJson<String>(id),
      'sessaoPlanoId': serializer.toJson<String>(sessaoPlanoId),
      'exercicioId': serializer.toJson<String>(exercicioId),
      'ordem': serializer.toJson<int>(ordem),
      'series': serializer.toJson<int>(series),
      'repsMin': serializer.toJson<int>(repsMin),
      'repsMax': serializer.toJson<int>(repsMax),
      'rirAlvo': serializer.toJson<int?>(rirAlvo),
      'descansoS': serializer.toJson<int>(descansoS),
      'cargaPlanKg': serializer.toJson<double?>(cargaPlanKg),
      'justificativa': serializer.toJson<String?>(justificativa),
      'fonteId': serializer.toJson<String?>(fonteId),
    };
  }

  ItemPlano copyWith({
    DateTime? atualizadoEm,
    Value<DateTime?> excluidoEm = const Value.absent(),
    Value<DateTime?> sincronizadoEm = const Value.absent(),
    String? id,
    String? sessaoPlanoId,
    String? exercicioId,
    int? ordem,
    int? series,
    int? repsMin,
    int? repsMax,
    Value<int?> rirAlvo = const Value.absent(),
    int? descansoS,
    Value<double?> cargaPlanKg = const Value.absent(),
    Value<String?> justificativa = const Value.absent(),
    Value<String?> fonteId = const Value.absent(),
  }) => ItemPlano(
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    excluidoEm: excluidoEm.present ? excluidoEm.value : this.excluidoEm,
    sincronizadoEm: sincronizadoEm.present
        ? sincronizadoEm.value
        : this.sincronizadoEm,
    id: id ?? this.id,
    sessaoPlanoId: sessaoPlanoId ?? this.sessaoPlanoId,
    exercicioId: exercicioId ?? this.exercicioId,
    ordem: ordem ?? this.ordem,
    series: series ?? this.series,
    repsMin: repsMin ?? this.repsMin,
    repsMax: repsMax ?? this.repsMax,
    rirAlvo: rirAlvo.present ? rirAlvo.value : this.rirAlvo,
    descansoS: descansoS ?? this.descansoS,
    cargaPlanKg: cargaPlanKg.present ? cargaPlanKg.value : this.cargaPlanKg,
    justificativa: justificativa.present
        ? justificativa.value
        : this.justificativa,
    fonteId: fonteId.present ? fonteId.value : this.fonteId,
  );
  ItemPlano copyWithCompanion(ItensPlanoCompanion data) {
    return ItemPlano(
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
      excluidoEm: data.excluidoEm.present
          ? data.excluidoEm.value
          : this.excluidoEm,
      sincronizadoEm: data.sincronizadoEm.present
          ? data.sincronizadoEm.value
          : this.sincronizadoEm,
      id: data.id.present ? data.id.value : this.id,
      sessaoPlanoId: data.sessaoPlanoId.present
          ? data.sessaoPlanoId.value
          : this.sessaoPlanoId,
      exercicioId: data.exercicioId.present
          ? data.exercicioId.value
          : this.exercicioId,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
      series: data.series.present ? data.series.value : this.series,
      repsMin: data.repsMin.present ? data.repsMin.value : this.repsMin,
      repsMax: data.repsMax.present ? data.repsMax.value : this.repsMax,
      rirAlvo: data.rirAlvo.present ? data.rirAlvo.value : this.rirAlvo,
      descansoS: data.descansoS.present ? data.descansoS.value : this.descansoS,
      cargaPlanKg: data.cargaPlanKg.present
          ? data.cargaPlanKg.value
          : this.cargaPlanKg,
      justificativa: data.justificativa.present
          ? data.justificativa.value
          : this.justificativa,
      fonteId: data.fonteId.present ? data.fonteId.value : this.fonteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemPlano(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('sessaoPlanoId: $sessaoPlanoId, ')
          ..write('exercicioId: $exercicioId, ')
          ..write('ordem: $ordem, ')
          ..write('series: $series, ')
          ..write('repsMin: $repsMin, ')
          ..write('repsMax: $repsMax, ')
          ..write('rirAlvo: $rirAlvo, ')
          ..write('descansoS: $descansoS, ')
          ..write('cargaPlanKg: $cargaPlanKg, ')
          ..write('justificativa: $justificativa, ')
          ..write('fonteId: $fonteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    sessaoPlanoId,
    exercicioId,
    ordem,
    series,
    repsMin,
    repsMax,
    rirAlvo,
    descansoS,
    cargaPlanKg,
    justificativa,
    fonteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemPlano &&
          other.atualizadoEm == this.atualizadoEm &&
          other.excluidoEm == this.excluidoEm &&
          other.sincronizadoEm == this.sincronizadoEm &&
          other.id == this.id &&
          other.sessaoPlanoId == this.sessaoPlanoId &&
          other.exercicioId == this.exercicioId &&
          other.ordem == this.ordem &&
          other.series == this.series &&
          other.repsMin == this.repsMin &&
          other.repsMax == this.repsMax &&
          other.rirAlvo == this.rirAlvo &&
          other.descansoS == this.descansoS &&
          other.cargaPlanKg == this.cargaPlanKg &&
          other.justificativa == this.justificativa &&
          other.fonteId == this.fonteId);
}

class ItensPlanoCompanion extends UpdateCompanion<ItemPlano> {
  final Value<DateTime> atualizadoEm;
  final Value<DateTime?> excluidoEm;
  final Value<DateTime?> sincronizadoEm;
  final Value<String> id;
  final Value<String> sessaoPlanoId;
  final Value<String> exercicioId;
  final Value<int> ordem;
  final Value<int> series;
  final Value<int> repsMin;
  final Value<int> repsMax;
  final Value<int?> rirAlvo;
  final Value<int> descansoS;
  final Value<double?> cargaPlanKg;
  final Value<String?> justificativa;
  final Value<String?> fonteId;
  final Value<int> rowid;
  const ItensPlanoCompanion({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    this.id = const Value.absent(),
    this.sessaoPlanoId = const Value.absent(),
    this.exercicioId = const Value.absent(),
    this.ordem = const Value.absent(),
    this.series = const Value.absent(),
    this.repsMin = const Value.absent(),
    this.repsMax = const Value.absent(),
    this.rirAlvo = const Value.absent(),
    this.descansoS = const Value.absent(),
    this.cargaPlanKg = const Value.absent(),
    this.justificativa = const Value.absent(),
    this.fonteId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItensPlanoCompanion.insert({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    required String id,
    required String sessaoPlanoId,
    required String exercicioId,
    required int ordem,
    required int series,
    required int repsMin,
    required int repsMax,
    this.rirAlvo = const Value.absent(),
    required int descansoS,
    this.cargaPlanKg = const Value.absent(),
    this.justificativa = const Value.absent(),
    this.fonteId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessaoPlanoId = Value(sessaoPlanoId),
       exercicioId = Value(exercicioId),
       ordem = Value(ordem),
       series = Value(series),
       repsMin = Value(repsMin),
       repsMax = Value(repsMax),
       descansoS = Value(descansoS);
  static Insertable<ItemPlano> custom({
    Expression<DateTime>? atualizadoEm,
    Expression<DateTime>? excluidoEm,
    Expression<DateTime>? sincronizadoEm,
    Expression<String>? id,
    Expression<String>? sessaoPlanoId,
    Expression<String>? exercicioId,
    Expression<int>? ordem,
    Expression<int>? series,
    Expression<int>? repsMin,
    Expression<int>? repsMax,
    Expression<int>? rirAlvo,
    Expression<int>? descansoS,
    Expression<double>? cargaPlanKg,
    Expression<String>? justificativa,
    Expression<String>? fonteId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (excluidoEm != null) 'excluido_em': excluidoEm,
      if (sincronizadoEm != null) 'sincronizado_em': sincronizadoEm,
      if (id != null) 'id': id,
      if (sessaoPlanoId != null) 'sessao_plano_id': sessaoPlanoId,
      if (exercicioId != null) 'exercicio_id': exercicioId,
      if (ordem != null) 'ordem': ordem,
      if (series != null) 'series': series,
      if (repsMin != null) 'reps_min': repsMin,
      if (repsMax != null) 'reps_max': repsMax,
      if (rirAlvo != null) 'rir_alvo': rirAlvo,
      if (descansoS != null) 'descanso_s': descansoS,
      if (cargaPlanKg != null) 'carga_plan_kg': cargaPlanKg,
      if (justificativa != null) 'justificativa': justificativa,
      if (fonteId != null) 'fonte_id': fonteId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItensPlanoCompanion copyWith({
    Value<DateTime>? atualizadoEm,
    Value<DateTime?>? excluidoEm,
    Value<DateTime?>? sincronizadoEm,
    Value<String>? id,
    Value<String>? sessaoPlanoId,
    Value<String>? exercicioId,
    Value<int>? ordem,
    Value<int>? series,
    Value<int>? repsMin,
    Value<int>? repsMax,
    Value<int?>? rirAlvo,
    Value<int>? descansoS,
    Value<double?>? cargaPlanKg,
    Value<String?>? justificativa,
    Value<String?>? fonteId,
    Value<int>? rowid,
  }) {
    return ItensPlanoCompanion(
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      excluidoEm: excluidoEm ?? this.excluidoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
      id: id ?? this.id,
      sessaoPlanoId: sessaoPlanoId ?? this.sessaoPlanoId,
      exercicioId: exercicioId ?? this.exercicioId,
      ordem: ordem ?? this.ordem,
      series: series ?? this.series,
      repsMin: repsMin ?? this.repsMin,
      repsMax: repsMax ?? this.repsMax,
      rirAlvo: rirAlvo ?? this.rirAlvo,
      descansoS: descansoS ?? this.descansoS,
      cargaPlanKg: cargaPlanKg ?? this.cargaPlanKg,
      justificativa: justificativa ?? this.justificativa,
      fonteId: fonteId ?? this.fonteId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (excluidoEm.present) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm.value);
    }
    if (sincronizadoEm.present) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessaoPlanoId.present) {
      map['sessao_plano_id'] = Variable<String>(sessaoPlanoId.value);
    }
    if (exercicioId.present) {
      map['exercicio_id'] = Variable<String>(exercicioId.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (series.present) {
      map['series'] = Variable<int>(series.value);
    }
    if (repsMin.present) {
      map['reps_min'] = Variable<int>(repsMin.value);
    }
    if (repsMax.present) {
      map['reps_max'] = Variable<int>(repsMax.value);
    }
    if (rirAlvo.present) {
      map['rir_alvo'] = Variable<int>(rirAlvo.value);
    }
    if (descansoS.present) {
      map['descanso_s'] = Variable<int>(descansoS.value);
    }
    if (cargaPlanKg.present) {
      map['carga_plan_kg'] = Variable<double>(cargaPlanKg.value);
    }
    if (justificativa.present) {
      map['justificativa'] = Variable<String>(justificativa.value);
    }
    if (fonteId.present) {
      map['fonte_id'] = Variable<String>(fonteId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItensPlanoCompanion(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('sessaoPlanoId: $sessaoPlanoId, ')
          ..write('exercicioId: $exercicioId, ')
          ..write('ordem: $ordem, ')
          ..write('series: $series, ')
          ..write('repsMin: $repsMin, ')
          ..write('repsMax: $repsMax, ')
          ..write('rirAlvo: $rirAlvo, ')
          ..write('descansoS: $descansoS, ')
          ..write('cargaPlanKg: $cargaPlanKg, ')
          ..write('justificativa: $justificativa, ')
          ..write('fonteId: $fonteId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TreinosTable extends Treinos with TableInfo<$TreinosTable, Treino> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreinosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _excluidoEmMeta = const VerificationMeta(
    'excluidoEm',
  );
  @override
  late final GeneratedColumn<DateTime> excluidoEm = GeneratedColumn<DateTime>(
    'excluido_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sincronizadoEmMeta = const VerificationMeta(
    'sincronizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> sincronizadoEm =
      GeneratedColumn<DateTime>(
        'sincronizado_em',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessaoPlanoIdMeta = const VerificationMeta(
    'sessaoPlanoId',
  );
  @override
  late final GeneratedColumn<String> sessaoPlanoId = GeneratedColumn<String>(
    'sessao_plano_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessoes_plano (id)',
    ),
  );
  static const VerificationMeta _iniciadoEmMeta = const VerificationMeta(
    'iniciadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> iniciadoEm = GeneratedColumn<DateTime>(
    'iniciado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finalizadoEmMeta = const VerificationMeta(
    'finalizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> finalizadoEm = GeneratedColumn<DateTime>(
    'finalizado_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    check: () => status.isIn(StatusTreino.todos),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(StatusTreino.andamento),
  );
  static const VerificationMeta _modoMeta = const VerificationMeta('modo');
  @override
  late final GeneratedColumn<String> modo = GeneratedColumn<String>(
    'modo',
    aliasedName,
    false,
    check: () => modo.isIn(ModoTreino.todos),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(ModoTreino.normal),
  );
  @override
  List<GeneratedColumn> get $columns => [
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    usuarioId,
    sessaoPlanoId,
    iniciadoEm,
    finalizadoEm,
    status,
    modo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'treinos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Treino> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('excluido_em')) {
      context.handle(
        _excluidoEmMeta,
        excluidoEm.isAcceptableOrUnknown(data['excluido_em']!, _excluidoEmMeta),
      );
    }
    if (data.containsKey('sincronizado_em')) {
      context.handle(
        _sincronizadoEmMeta,
        sincronizadoEm.isAcceptableOrUnknown(
          data['sincronizado_em']!,
          _sincronizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    }
    if (data.containsKey('sessao_plano_id')) {
      context.handle(
        _sessaoPlanoIdMeta,
        sessaoPlanoId.isAcceptableOrUnknown(
          data['sessao_plano_id']!,
          _sessaoPlanoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessaoPlanoIdMeta);
    }
    if (data.containsKey('iniciado_em')) {
      context.handle(
        _iniciadoEmMeta,
        iniciadoEm.isAcceptableOrUnknown(data['iniciado_em']!, _iniciadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_iniciadoEmMeta);
    }
    if (data.containsKey('finalizado_em')) {
      context.handle(
        _finalizadoEmMeta,
        finalizadoEm.isAcceptableOrUnknown(
          data['finalizado_em']!,
          _finalizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('modo')) {
      context.handle(
        _modoMeta,
        modo.isAcceptableOrUnknown(data['modo']!, _modoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Treino map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Treino(
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
      excluidoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}excluido_em'],
      ),
      sincronizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sincronizado_em'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      ),
      sessaoPlanoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sessao_plano_id'],
      )!,
      iniciadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}iniciado_em'],
      )!,
      finalizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finalizado_em'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      modo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modo'],
      )!,
    );
  }

  @override
  $TreinosTable createAlias(String alias) {
    return $TreinosTable(attachedDatabase, alias);
  }
}

class Treino extends DataClass implements Insertable<Treino> {
  final DateTime atualizadoEm;
  final DateTime? excluidoEm;
  final DateTime? sincronizadoEm;
  final String id;
  final String? usuarioId;
  final String sessaoPlanoId;
  final DateTime iniciadoEm;
  final DateTime? finalizadoEm;
  final String status;
  final String modo;
  const Treino({
    required this.atualizadoEm,
    this.excluidoEm,
    this.sincronizadoEm,
    required this.id,
    this.usuarioId,
    required this.sessaoPlanoId,
    required this.iniciadoEm,
    this.finalizadoEm,
    required this.status,
    required this.modo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    if (!nullToAbsent || excluidoEm != null) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm);
    }
    if (!nullToAbsent || sincronizadoEm != null) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || usuarioId != null) {
      map['usuario_id'] = Variable<String>(usuarioId);
    }
    map['sessao_plano_id'] = Variable<String>(sessaoPlanoId);
    map['iniciado_em'] = Variable<DateTime>(iniciadoEm);
    if (!nullToAbsent || finalizadoEm != null) {
      map['finalizado_em'] = Variable<DateTime>(finalizadoEm);
    }
    map['status'] = Variable<String>(status);
    map['modo'] = Variable<String>(modo);
    return map;
  }

  TreinosCompanion toCompanion(bool nullToAbsent) {
    return TreinosCompanion(
      atualizadoEm: Value(atualizadoEm),
      excluidoEm: excluidoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(excluidoEm),
      sincronizadoEm: sincronizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(sincronizadoEm),
      id: Value(id),
      usuarioId: usuarioId == null && nullToAbsent
          ? const Value.absent()
          : Value(usuarioId),
      sessaoPlanoId: Value(sessaoPlanoId),
      iniciadoEm: Value(iniciadoEm),
      finalizadoEm: finalizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(finalizadoEm),
      status: Value(status),
      modo: Value(modo),
    );
  }

  factory Treino.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Treino(
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
      excluidoEm: serializer.fromJson<DateTime?>(json['excluidoEm']),
      sincronizadoEm: serializer.fromJson<DateTime?>(json['sincronizadoEm']),
      id: serializer.fromJson<String>(json['id']),
      usuarioId: serializer.fromJson<String?>(json['usuarioId']),
      sessaoPlanoId: serializer.fromJson<String>(json['sessaoPlanoId']),
      iniciadoEm: serializer.fromJson<DateTime>(json['iniciadoEm']),
      finalizadoEm: serializer.fromJson<DateTime?>(json['finalizadoEm']),
      status: serializer.fromJson<String>(json['status']),
      modo: serializer.fromJson<String>(json['modo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
      'excluidoEm': serializer.toJson<DateTime?>(excluidoEm),
      'sincronizadoEm': serializer.toJson<DateTime?>(sincronizadoEm),
      'id': serializer.toJson<String>(id),
      'usuarioId': serializer.toJson<String?>(usuarioId),
      'sessaoPlanoId': serializer.toJson<String>(sessaoPlanoId),
      'iniciadoEm': serializer.toJson<DateTime>(iniciadoEm),
      'finalizadoEm': serializer.toJson<DateTime?>(finalizadoEm),
      'status': serializer.toJson<String>(status),
      'modo': serializer.toJson<String>(modo),
    };
  }

  Treino copyWith({
    DateTime? atualizadoEm,
    Value<DateTime?> excluidoEm = const Value.absent(),
    Value<DateTime?> sincronizadoEm = const Value.absent(),
    String? id,
    Value<String?> usuarioId = const Value.absent(),
    String? sessaoPlanoId,
    DateTime? iniciadoEm,
    Value<DateTime?> finalizadoEm = const Value.absent(),
    String? status,
    String? modo,
  }) => Treino(
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    excluidoEm: excluidoEm.present ? excluidoEm.value : this.excluidoEm,
    sincronizadoEm: sincronizadoEm.present
        ? sincronizadoEm.value
        : this.sincronizadoEm,
    id: id ?? this.id,
    usuarioId: usuarioId.present ? usuarioId.value : this.usuarioId,
    sessaoPlanoId: sessaoPlanoId ?? this.sessaoPlanoId,
    iniciadoEm: iniciadoEm ?? this.iniciadoEm,
    finalizadoEm: finalizadoEm.present ? finalizadoEm.value : this.finalizadoEm,
    status: status ?? this.status,
    modo: modo ?? this.modo,
  );
  Treino copyWithCompanion(TreinosCompanion data) {
    return Treino(
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
      excluidoEm: data.excluidoEm.present
          ? data.excluidoEm.value
          : this.excluidoEm,
      sincronizadoEm: data.sincronizadoEm.present
          ? data.sincronizadoEm.value
          : this.sincronizadoEm,
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      sessaoPlanoId: data.sessaoPlanoId.present
          ? data.sessaoPlanoId.value
          : this.sessaoPlanoId,
      iniciadoEm: data.iniciadoEm.present
          ? data.iniciadoEm.value
          : this.iniciadoEm,
      finalizadoEm: data.finalizadoEm.present
          ? data.finalizadoEm.value
          : this.finalizadoEm,
      status: data.status.present ? data.status.value : this.status,
      modo: data.modo.present ? data.modo.value : this.modo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Treino(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('sessaoPlanoId: $sessaoPlanoId, ')
          ..write('iniciadoEm: $iniciadoEm, ')
          ..write('finalizadoEm: $finalizadoEm, ')
          ..write('status: $status, ')
          ..write('modo: $modo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    usuarioId,
    sessaoPlanoId,
    iniciadoEm,
    finalizadoEm,
    status,
    modo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Treino &&
          other.atualizadoEm == this.atualizadoEm &&
          other.excluidoEm == this.excluidoEm &&
          other.sincronizadoEm == this.sincronizadoEm &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.sessaoPlanoId == this.sessaoPlanoId &&
          other.iniciadoEm == this.iniciadoEm &&
          other.finalizadoEm == this.finalizadoEm &&
          other.status == this.status &&
          other.modo == this.modo);
}

class TreinosCompanion extends UpdateCompanion<Treino> {
  final Value<DateTime> atualizadoEm;
  final Value<DateTime?> excluidoEm;
  final Value<DateTime?> sincronizadoEm;
  final Value<String> id;
  final Value<String?> usuarioId;
  final Value<String> sessaoPlanoId;
  final Value<DateTime> iniciadoEm;
  final Value<DateTime?> finalizadoEm;
  final Value<String> status;
  final Value<String> modo;
  final Value<int> rowid;
  const TreinosCompanion({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.sessaoPlanoId = const Value.absent(),
    this.iniciadoEm = const Value.absent(),
    this.finalizadoEm = const Value.absent(),
    this.status = const Value.absent(),
    this.modo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TreinosCompanion.insert({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    required String id,
    this.usuarioId = const Value.absent(),
    required String sessaoPlanoId,
    required DateTime iniciadoEm,
    this.finalizadoEm = const Value.absent(),
    this.status = const Value.absent(),
    this.modo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessaoPlanoId = Value(sessaoPlanoId),
       iniciadoEm = Value(iniciadoEm);
  static Insertable<Treino> custom({
    Expression<DateTime>? atualizadoEm,
    Expression<DateTime>? excluidoEm,
    Expression<DateTime>? sincronizadoEm,
    Expression<String>? id,
    Expression<String>? usuarioId,
    Expression<String>? sessaoPlanoId,
    Expression<DateTime>? iniciadoEm,
    Expression<DateTime>? finalizadoEm,
    Expression<String>? status,
    Expression<String>? modo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (excluidoEm != null) 'excluido_em': excluidoEm,
      if (sincronizadoEm != null) 'sincronizado_em': sincronizadoEm,
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (sessaoPlanoId != null) 'sessao_plano_id': sessaoPlanoId,
      if (iniciadoEm != null) 'iniciado_em': iniciadoEm,
      if (finalizadoEm != null) 'finalizado_em': finalizadoEm,
      if (status != null) 'status': status,
      if (modo != null) 'modo': modo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TreinosCompanion copyWith({
    Value<DateTime>? atualizadoEm,
    Value<DateTime?>? excluidoEm,
    Value<DateTime?>? sincronizadoEm,
    Value<String>? id,
    Value<String?>? usuarioId,
    Value<String>? sessaoPlanoId,
    Value<DateTime>? iniciadoEm,
    Value<DateTime?>? finalizadoEm,
    Value<String>? status,
    Value<String>? modo,
    Value<int>? rowid,
  }) {
    return TreinosCompanion(
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      excluidoEm: excluidoEm ?? this.excluidoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      sessaoPlanoId: sessaoPlanoId ?? this.sessaoPlanoId,
      iniciadoEm: iniciadoEm ?? this.iniciadoEm,
      finalizadoEm: finalizadoEm ?? this.finalizadoEm,
      status: status ?? this.status,
      modo: modo ?? this.modo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (excluidoEm.present) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm.value);
    }
    if (sincronizadoEm.present) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (sessaoPlanoId.present) {
      map['sessao_plano_id'] = Variable<String>(sessaoPlanoId.value);
    }
    if (iniciadoEm.present) {
      map['iniciado_em'] = Variable<DateTime>(iniciadoEm.value);
    }
    if (finalizadoEm.present) {
      map['finalizado_em'] = Variable<DateTime>(finalizadoEm.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (modo.present) {
      map['modo'] = Variable<String>(modo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreinosCompanion(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('sessaoPlanoId: $sessaoPlanoId, ')
          ..write('iniciadoEm: $iniciadoEm, ')
          ..write('finalizadoEm: $finalizadoEm, ')
          ..write('status: $status, ')
          ..write('modo: $modo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SeriesTable extends Series with TableInfo<$SeriesTable, Serie> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _excluidoEmMeta = const VerificationMeta(
    'excluidoEm',
  );
  @override
  late final GeneratedColumn<DateTime> excluidoEm = GeneratedColumn<DateTime>(
    'excluido_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sincronizadoEmMeta = const VerificationMeta(
    'sincronizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> sincronizadoEm =
      GeneratedColumn<DateTime>(
        'sincronizado_em',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _treinoIdMeta = const VerificationMeta(
    'treinoId',
  );
  @override
  late final GeneratedColumn<String> treinoId = GeneratedColumn<String>(
    'treino_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES treinos (id)',
    ),
  );
  static const VerificationMeta _itemPlanoIdMeta = const VerificationMeta(
    'itemPlanoId',
  );
  @override
  late final GeneratedColumn<String> itemPlanoId = GeneratedColumn<String>(
    'item_plano_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES itens_plano (id)',
    ),
  );
  static const VerificationMeta _exercicioIdMeta = const VerificationMeta(
    'exercicioId',
  );
  @override
  late final GeneratedColumn<String> exercicioId = GeneratedColumn<String>(
    'exercicio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercicios (id)',
    ),
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
    'numero',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cargaPlanKgMeta = const VerificationMeta(
    'cargaPlanKg',
  );
  @override
  late final GeneratedColumn<double> cargaPlanKg = GeneratedColumn<double>(
    'carga_plan_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsPlanMeta = const VerificationMeta(
    'repsPlan',
  );
  @override
  late final GeneratedColumn<int> repsPlan = GeneratedColumn<int>(
    'reps_plan',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cargaKgMeta = const VerificationMeta(
    'cargaKg',
  );
  @override
  late final GeneratedColumn<double> cargaKg = GeneratedColumn<double>(
    'carga_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rirMeta = const VerificationMeta('rir');
  @override
  late final GeneratedColumn<int> rir = GeneratedColumn<int>(
    'rir',
    aliasedName,
    true,
    check: () => ComparableExpr(rir).isBetweenValues(0, 4),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confirmadoMeta = const VerificationMeta(
    'confirmado',
  );
  @override
  late final GeneratedColumn<bool> confirmado = GeneratedColumn<bool>(
    'confirmado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("confirmado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _editadoMeta = const VerificationMeta(
    'editado',
  );
  @override
  late final GeneratedColumn<bool> editado = GeneratedColumn<bool>(
    'editado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("editado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dorMeta = const VerificationMeta('dor');
  @override
  late final GeneratedColumn<bool> dor = GeneratedColumn<bool>(
    'dor',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dor" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _registradaEmMeta = const VerificationMeta(
    'registradaEm',
  );
  @override
  late final GeneratedColumn<DateTime> registradaEm = GeneratedColumn<DateTime>(
    'registrada_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    treinoId,
    itemPlanoId,
    exercicioId,
    numero,
    cargaPlanKg,
    repsPlan,
    cargaKg,
    reps,
    rir,
    confirmado,
    editado,
    dor,
    registradaEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'series';
  @override
  VerificationContext validateIntegrity(
    Insertable<Serie> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('excluido_em')) {
      context.handle(
        _excluidoEmMeta,
        excluidoEm.isAcceptableOrUnknown(data['excluido_em']!, _excluidoEmMeta),
      );
    }
    if (data.containsKey('sincronizado_em')) {
      context.handle(
        _sincronizadoEmMeta,
        sincronizadoEm.isAcceptableOrUnknown(
          data['sincronizado_em']!,
          _sincronizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('treino_id')) {
      context.handle(
        _treinoIdMeta,
        treinoId.isAcceptableOrUnknown(data['treino_id']!, _treinoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_treinoIdMeta);
    }
    if (data.containsKey('item_plano_id')) {
      context.handle(
        _itemPlanoIdMeta,
        itemPlanoId.isAcceptableOrUnknown(
          data['item_plano_id']!,
          _itemPlanoIdMeta,
        ),
      );
    }
    if (data.containsKey('exercicio_id')) {
      context.handle(
        _exercicioIdMeta,
        exercicioId.isAcceptableOrUnknown(
          data['exercicio_id']!,
          _exercicioIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exercicioIdMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('carga_plan_kg')) {
      context.handle(
        _cargaPlanKgMeta,
        cargaPlanKg.isAcceptableOrUnknown(
          data['carga_plan_kg']!,
          _cargaPlanKgMeta,
        ),
      );
    }
    if (data.containsKey('reps_plan')) {
      context.handle(
        _repsPlanMeta,
        repsPlan.isAcceptableOrUnknown(data['reps_plan']!, _repsPlanMeta),
      );
    }
    if (data.containsKey('carga_kg')) {
      context.handle(
        _cargaKgMeta,
        cargaKg.isAcceptableOrUnknown(data['carga_kg']!, _cargaKgMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('rir')) {
      context.handle(
        _rirMeta,
        rir.isAcceptableOrUnknown(data['rir']!, _rirMeta),
      );
    }
    if (data.containsKey('confirmado')) {
      context.handle(
        _confirmadoMeta,
        confirmado.isAcceptableOrUnknown(data['confirmado']!, _confirmadoMeta),
      );
    }
    if (data.containsKey('editado')) {
      context.handle(
        _editadoMeta,
        editado.isAcceptableOrUnknown(data['editado']!, _editadoMeta),
      );
    }
    if (data.containsKey('dor')) {
      context.handle(
        _dorMeta,
        dor.isAcceptableOrUnknown(data['dor']!, _dorMeta),
      );
    }
    if (data.containsKey('registrada_em')) {
      context.handle(
        _registradaEmMeta,
        registradaEm.isAcceptableOrUnknown(
          data['registrada_em']!,
          _registradaEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registradaEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Serie map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Serie(
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
      excluidoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}excluido_em'],
      ),
      sincronizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sincronizado_em'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      treinoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}treino_id'],
      )!,
      itemPlanoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_plano_id'],
      ),
      exercicioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercicio_id'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero'],
      )!,
      cargaPlanKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carga_plan_kg'],
      ),
      repsPlan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps_plan'],
      ),
      cargaKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carga_kg'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      rir: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rir'],
      ),
      confirmado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}confirmado'],
      )!,
      editado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}editado'],
      )!,
      dor: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dor'],
      )!,
      registradaEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registrada_em'],
      )!,
    );
  }

  @override
  $SeriesTable createAlias(String alias) {
    return $SeriesTable(attachedDatabase, alias);
  }
}

class Serie extends DataClass implements Insertable<Serie> {
  final DateTime atualizadoEm;
  final DateTime? excluidoEm;
  final DateTime? sincronizadoEm;
  final String id;
  final String treinoId;
  final String? itemPlanoId;
  final String exercicioId;
  final int numero;
  final double? cargaPlanKg;
  final int? repsPlan;
  final double? cargaKg;
  final int? reps;
  final int? rir;
  final bool confirmado;
  final bool editado;
  final bool dor;
  final DateTime registradaEm;
  const Serie({
    required this.atualizadoEm,
    this.excluidoEm,
    this.sincronizadoEm,
    required this.id,
    required this.treinoId,
    this.itemPlanoId,
    required this.exercicioId,
    required this.numero,
    this.cargaPlanKg,
    this.repsPlan,
    this.cargaKg,
    this.reps,
    this.rir,
    required this.confirmado,
    required this.editado,
    required this.dor,
    required this.registradaEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    if (!nullToAbsent || excluidoEm != null) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm);
    }
    if (!nullToAbsent || sincronizadoEm != null) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm);
    }
    map['id'] = Variable<String>(id);
    map['treino_id'] = Variable<String>(treinoId);
    if (!nullToAbsent || itemPlanoId != null) {
      map['item_plano_id'] = Variable<String>(itemPlanoId);
    }
    map['exercicio_id'] = Variable<String>(exercicioId);
    map['numero'] = Variable<int>(numero);
    if (!nullToAbsent || cargaPlanKg != null) {
      map['carga_plan_kg'] = Variable<double>(cargaPlanKg);
    }
    if (!nullToAbsent || repsPlan != null) {
      map['reps_plan'] = Variable<int>(repsPlan);
    }
    if (!nullToAbsent || cargaKg != null) {
      map['carga_kg'] = Variable<double>(cargaKg);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || rir != null) {
      map['rir'] = Variable<int>(rir);
    }
    map['confirmado'] = Variable<bool>(confirmado);
    map['editado'] = Variable<bool>(editado);
    map['dor'] = Variable<bool>(dor);
    map['registrada_em'] = Variable<DateTime>(registradaEm);
    return map;
  }

  SeriesCompanion toCompanion(bool nullToAbsent) {
    return SeriesCompanion(
      atualizadoEm: Value(atualizadoEm),
      excluidoEm: excluidoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(excluidoEm),
      sincronizadoEm: sincronizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(sincronizadoEm),
      id: Value(id),
      treinoId: Value(treinoId),
      itemPlanoId: itemPlanoId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemPlanoId),
      exercicioId: Value(exercicioId),
      numero: Value(numero),
      cargaPlanKg: cargaPlanKg == null && nullToAbsent
          ? const Value.absent()
          : Value(cargaPlanKg),
      repsPlan: repsPlan == null && nullToAbsent
          ? const Value.absent()
          : Value(repsPlan),
      cargaKg: cargaKg == null && nullToAbsent
          ? const Value.absent()
          : Value(cargaKg),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      rir: rir == null && nullToAbsent ? const Value.absent() : Value(rir),
      confirmado: Value(confirmado),
      editado: Value(editado),
      dor: Value(dor),
      registradaEm: Value(registradaEm),
    );
  }

  factory Serie.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Serie(
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
      excluidoEm: serializer.fromJson<DateTime?>(json['excluidoEm']),
      sincronizadoEm: serializer.fromJson<DateTime?>(json['sincronizadoEm']),
      id: serializer.fromJson<String>(json['id']),
      treinoId: serializer.fromJson<String>(json['treinoId']),
      itemPlanoId: serializer.fromJson<String?>(json['itemPlanoId']),
      exercicioId: serializer.fromJson<String>(json['exercicioId']),
      numero: serializer.fromJson<int>(json['numero']),
      cargaPlanKg: serializer.fromJson<double?>(json['cargaPlanKg']),
      repsPlan: serializer.fromJson<int?>(json['repsPlan']),
      cargaKg: serializer.fromJson<double?>(json['cargaKg']),
      reps: serializer.fromJson<int?>(json['reps']),
      rir: serializer.fromJson<int?>(json['rir']),
      confirmado: serializer.fromJson<bool>(json['confirmado']),
      editado: serializer.fromJson<bool>(json['editado']),
      dor: serializer.fromJson<bool>(json['dor']),
      registradaEm: serializer.fromJson<DateTime>(json['registradaEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
      'excluidoEm': serializer.toJson<DateTime?>(excluidoEm),
      'sincronizadoEm': serializer.toJson<DateTime?>(sincronizadoEm),
      'id': serializer.toJson<String>(id),
      'treinoId': serializer.toJson<String>(treinoId),
      'itemPlanoId': serializer.toJson<String?>(itemPlanoId),
      'exercicioId': serializer.toJson<String>(exercicioId),
      'numero': serializer.toJson<int>(numero),
      'cargaPlanKg': serializer.toJson<double?>(cargaPlanKg),
      'repsPlan': serializer.toJson<int?>(repsPlan),
      'cargaKg': serializer.toJson<double?>(cargaKg),
      'reps': serializer.toJson<int?>(reps),
      'rir': serializer.toJson<int?>(rir),
      'confirmado': serializer.toJson<bool>(confirmado),
      'editado': serializer.toJson<bool>(editado),
      'dor': serializer.toJson<bool>(dor),
      'registradaEm': serializer.toJson<DateTime>(registradaEm),
    };
  }

  Serie copyWith({
    DateTime? atualizadoEm,
    Value<DateTime?> excluidoEm = const Value.absent(),
    Value<DateTime?> sincronizadoEm = const Value.absent(),
    String? id,
    String? treinoId,
    Value<String?> itemPlanoId = const Value.absent(),
    String? exercicioId,
    int? numero,
    Value<double?> cargaPlanKg = const Value.absent(),
    Value<int?> repsPlan = const Value.absent(),
    Value<double?> cargaKg = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    Value<int?> rir = const Value.absent(),
    bool? confirmado,
    bool? editado,
    bool? dor,
    DateTime? registradaEm,
  }) => Serie(
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    excluidoEm: excluidoEm.present ? excluidoEm.value : this.excluidoEm,
    sincronizadoEm: sincronizadoEm.present
        ? sincronizadoEm.value
        : this.sincronizadoEm,
    id: id ?? this.id,
    treinoId: treinoId ?? this.treinoId,
    itemPlanoId: itemPlanoId.present ? itemPlanoId.value : this.itemPlanoId,
    exercicioId: exercicioId ?? this.exercicioId,
    numero: numero ?? this.numero,
    cargaPlanKg: cargaPlanKg.present ? cargaPlanKg.value : this.cargaPlanKg,
    repsPlan: repsPlan.present ? repsPlan.value : this.repsPlan,
    cargaKg: cargaKg.present ? cargaKg.value : this.cargaKg,
    reps: reps.present ? reps.value : this.reps,
    rir: rir.present ? rir.value : this.rir,
    confirmado: confirmado ?? this.confirmado,
    editado: editado ?? this.editado,
    dor: dor ?? this.dor,
    registradaEm: registradaEm ?? this.registradaEm,
  );
  Serie copyWithCompanion(SeriesCompanion data) {
    return Serie(
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
      excluidoEm: data.excluidoEm.present
          ? data.excluidoEm.value
          : this.excluidoEm,
      sincronizadoEm: data.sincronizadoEm.present
          ? data.sincronizadoEm.value
          : this.sincronizadoEm,
      id: data.id.present ? data.id.value : this.id,
      treinoId: data.treinoId.present ? data.treinoId.value : this.treinoId,
      itemPlanoId: data.itemPlanoId.present
          ? data.itemPlanoId.value
          : this.itemPlanoId,
      exercicioId: data.exercicioId.present
          ? data.exercicioId.value
          : this.exercicioId,
      numero: data.numero.present ? data.numero.value : this.numero,
      cargaPlanKg: data.cargaPlanKg.present
          ? data.cargaPlanKg.value
          : this.cargaPlanKg,
      repsPlan: data.repsPlan.present ? data.repsPlan.value : this.repsPlan,
      cargaKg: data.cargaKg.present ? data.cargaKg.value : this.cargaKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      rir: data.rir.present ? data.rir.value : this.rir,
      confirmado: data.confirmado.present
          ? data.confirmado.value
          : this.confirmado,
      editado: data.editado.present ? data.editado.value : this.editado,
      dor: data.dor.present ? data.dor.value : this.dor,
      registradaEm: data.registradaEm.present
          ? data.registradaEm.value
          : this.registradaEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Serie(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('treinoId: $treinoId, ')
          ..write('itemPlanoId: $itemPlanoId, ')
          ..write('exercicioId: $exercicioId, ')
          ..write('numero: $numero, ')
          ..write('cargaPlanKg: $cargaPlanKg, ')
          ..write('repsPlan: $repsPlan, ')
          ..write('cargaKg: $cargaKg, ')
          ..write('reps: $reps, ')
          ..write('rir: $rir, ')
          ..write('confirmado: $confirmado, ')
          ..write('editado: $editado, ')
          ..write('dor: $dor, ')
          ..write('registradaEm: $registradaEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    treinoId,
    itemPlanoId,
    exercicioId,
    numero,
    cargaPlanKg,
    repsPlan,
    cargaKg,
    reps,
    rir,
    confirmado,
    editado,
    dor,
    registradaEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Serie &&
          other.atualizadoEm == this.atualizadoEm &&
          other.excluidoEm == this.excluidoEm &&
          other.sincronizadoEm == this.sincronizadoEm &&
          other.id == this.id &&
          other.treinoId == this.treinoId &&
          other.itemPlanoId == this.itemPlanoId &&
          other.exercicioId == this.exercicioId &&
          other.numero == this.numero &&
          other.cargaPlanKg == this.cargaPlanKg &&
          other.repsPlan == this.repsPlan &&
          other.cargaKg == this.cargaKg &&
          other.reps == this.reps &&
          other.rir == this.rir &&
          other.confirmado == this.confirmado &&
          other.editado == this.editado &&
          other.dor == this.dor &&
          other.registradaEm == this.registradaEm);
}

class SeriesCompanion extends UpdateCompanion<Serie> {
  final Value<DateTime> atualizadoEm;
  final Value<DateTime?> excluidoEm;
  final Value<DateTime?> sincronizadoEm;
  final Value<String> id;
  final Value<String> treinoId;
  final Value<String?> itemPlanoId;
  final Value<String> exercicioId;
  final Value<int> numero;
  final Value<double?> cargaPlanKg;
  final Value<int?> repsPlan;
  final Value<double?> cargaKg;
  final Value<int?> reps;
  final Value<int?> rir;
  final Value<bool> confirmado;
  final Value<bool> editado;
  final Value<bool> dor;
  final Value<DateTime> registradaEm;
  final Value<int> rowid;
  const SeriesCompanion({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    this.id = const Value.absent(),
    this.treinoId = const Value.absent(),
    this.itemPlanoId = const Value.absent(),
    this.exercicioId = const Value.absent(),
    this.numero = const Value.absent(),
    this.cargaPlanKg = const Value.absent(),
    this.repsPlan = const Value.absent(),
    this.cargaKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.rir = const Value.absent(),
    this.confirmado = const Value.absent(),
    this.editado = const Value.absent(),
    this.dor = const Value.absent(),
    this.registradaEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SeriesCompanion.insert({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    required String id,
    required String treinoId,
    this.itemPlanoId = const Value.absent(),
    required String exercicioId,
    required int numero,
    this.cargaPlanKg = const Value.absent(),
    this.repsPlan = const Value.absent(),
    this.cargaKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.rir = const Value.absent(),
    this.confirmado = const Value.absent(),
    this.editado = const Value.absent(),
    this.dor = const Value.absent(),
    required DateTime registradaEm,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       treinoId = Value(treinoId),
       exercicioId = Value(exercicioId),
       numero = Value(numero),
       registradaEm = Value(registradaEm);
  static Insertable<Serie> custom({
    Expression<DateTime>? atualizadoEm,
    Expression<DateTime>? excluidoEm,
    Expression<DateTime>? sincronizadoEm,
    Expression<String>? id,
    Expression<String>? treinoId,
    Expression<String>? itemPlanoId,
    Expression<String>? exercicioId,
    Expression<int>? numero,
    Expression<double>? cargaPlanKg,
    Expression<int>? repsPlan,
    Expression<double>? cargaKg,
    Expression<int>? reps,
    Expression<int>? rir,
    Expression<bool>? confirmado,
    Expression<bool>? editado,
    Expression<bool>? dor,
    Expression<DateTime>? registradaEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (excluidoEm != null) 'excluido_em': excluidoEm,
      if (sincronizadoEm != null) 'sincronizado_em': sincronizadoEm,
      if (id != null) 'id': id,
      if (treinoId != null) 'treino_id': treinoId,
      if (itemPlanoId != null) 'item_plano_id': itemPlanoId,
      if (exercicioId != null) 'exercicio_id': exercicioId,
      if (numero != null) 'numero': numero,
      if (cargaPlanKg != null) 'carga_plan_kg': cargaPlanKg,
      if (repsPlan != null) 'reps_plan': repsPlan,
      if (cargaKg != null) 'carga_kg': cargaKg,
      if (reps != null) 'reps': reps,
      if (rir != null) 'rir': rir,
      if (confirmado != null) 'confirmado': confirmado,
      if (editado != null) 'editado': editado,
      if (dor != null) 'dor': dor,
      if (registradaEm != null) 'registrada_em': registradaEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SeriesCompanion copyWith({
    Value<DateTime>? atualizadoEm,
    Value<DateTime?>? excluidoEm,
    Value<DateTime?>? sincronizadoEm,
    Value<String>? id,
    Value<String>? treinoId,
    Value<String?>? itemPlanoId,
    Value<String>? exercicioId,
    Value<int>? numero,
    Value<double?>? cargaPlanKg,
    Value<int?>? repsPlan,
    Value<double?>? cargaKg,
    Value<int?>? reps,
    Value<int?>? rir,
    Value<bool>? confirmado,
    Value<bool>? editado,
    Value<bool>? dor,
    Value<DateTime>? registradaEm,
    Value<int>? rowid,
  }) {
    return SeriesCompanion(
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      excluidoEm: excluidoEm ?? this.excluidoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
      id: id ?? this.id,
      treinoId: treinoId ?? this.treinoId,
      itemPlanoId: itemPlanoId ?? this.itemPlanoId,
      exercicioId: exercicioId ?? this.exercicioId,
      numero: numero ?? this.numero,
      cargaPlanKg: cargaPlanKg ?? this.cargaPlanKg,
      repsPlan: repsPlan ?? this.repsPlan,
      cargaKg: cargaKg ?? this.cargaKg,
      reps: reps ?? this.reps,
      rir: rir ?? this.rir,
      confirmado: confirmado ?? this.confirmado,
      editado: editado ?? this.editado,
      dor: dor ?? this.dor,
      registradaEm: registradaEm ?? this.registradaEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (excluidoEm.present) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm.value);
    }
    if (sincronizadoEm.present) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (treinoId.present) {
      map['treino_id'] = Variable<String>(treinoId.value);
    }
    if (itemPlanoId.present) {
      map['item_plano_id'] = Variable<String>(itemPlanoId.value);
    }
    if (exercicioId.present) {
      map['exercicio_id'] = Variable<String>(exercicioId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (cargaPlanKg.present) {
      map['carga_plan_kg'] = Variable<double>(cargaPlanKg.value);
    }
    if (repsPlan.present) {
      map['reps_plan'] = Variable<int>(repsPlan.value);
    }
    if (cargaKg.present) {
      map['carga_kg'] = Variable<double>(cargaKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rir.present) {
      map['rir'] = Variable<int>(rir.value);
    }
    if (confirmado.present) {
      map['confirmado'] = Variable<bool>(confirmado.value);
    }
    if (editado.present) {
      map['editado'] = Variable<bool>(editado.value);
    }
    if (dor.present) {
      map['dor'] = Variable<bool>(dor.value);
    }
    if (registradaEm.present) {
      map['registrada_em'] = Variable<DateTime>(registradaEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeriesCompanion(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('treinoId: $treinoId, ')
          ..write('itemPlanoId: $itemPlanoId, ')
          ..write('exercicioId: $exercicioId, ')
          ..write('numero: $numero, ')
          ..write('cargaPlanKg: $cargaPlanKg, ')
          ..write('repsPlan: $repsPlan, ')
          ..write('cargaKg: $cargaKg, ')
          ..write('reps: $reps, ')
          ..write('rir: $rir, ')
          ..write('confirmado: $confirmado, ')
          ..write('editado: $editado, ')
          ..write('dor: $dor, ')
          ..write('registradaEm: $registradaEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubstituicoesTable extends Substituicoes
    with TableInfo<$SubstituicoesTable, Substituicao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubstituicoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _excluidoEmMeta = const VerificationMeta(
    'excluidoEm',
  );
  @override
  late final GeneratedColumn<DateTime> excluidoEm = GeneratedColumn<DateTime>(
    'excluido_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sincronizadoEmMeta = const VerificationMeta(
    'sincronizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> sincronizadoEm =
      GeneratedColumn<DateTime>(
        'sincronizado_em',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemPlanoIdMeta = const VerificationMeta(
    'itemPlanoId',
  );
  @override
  late final GeneratedColumn<String> itemPlanoId = GeneratedColumn<String>(
    'item_plano_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES itens_plano (id)',
    ),
  );
  static const VerificationMeta _exercicioOriginalIdMeta =
      const VerificationMeta('exercicioOriginalId');
  @override
  late final GeneratedColumn<String> exercicioOriginalId =
      GeneratedColumn<String>(
        'exercicio_original_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES exercicios (id)',
        ),
      );
  static const VerificationMeta _exercicioNovoIdMeta = const VerificationMeta(
    'exercicioNovoId',
  );
  @override
  late final GeneratedColumn<String> exercicioNovoId = GeneratedColumn<String>(
    'exercicio_novo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercicios (id)',
    ),
  );
  static const VerificationMeta _escopoMeta = const VerificationMeta('escopo');
  @override
  late final GeneratedColumn<String> escopo = GeneratedColumn<String>(
    'escopo',
    aliasedName,
    false,
    check: () => escopo.isIn(EscopoSubstituicao.todos),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    usuarioId,
    itemPlanoId,
    exercicioOriginalId,
    exercicioNovoId,
    escopo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'substituicoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Substituicao> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('excluido_em')) {
      context.handle(
        _excluidoEmMeta,
        excluidoEm.isAcceptableOrUnknown(data['excluido_em']!, _excluidoEmMeta),
      );
    }
    if (data.containsKey('sincronizado_em')) {
      context.handle(
        _sincronizadoEmMeta,
        sincronizadoEm.isAcceptableOrUnknown(
          data['sincronizado_em']!,
          _sincronizadoEmMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    }
    if (data.containsKey('item_plano_id')) {
      context.handle(
        _itemPlanoIdMeta,
        itemPlanoId.isAcceptableOrUnknown(
          data['item_plano_id']!,
          _itemPlanoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_itemPlanoIdMeta);
    }
    if (data.containsKey('exercicio_original_id')) {
      context.handle(
        _exercicioOriginalIdMeta,
        exercicioOriginalId.isAcceptableOrUnknown(
          data['exercicio_original_id']!,
          _exercicioOriginalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exercicioOriginalIdMeta);
    }
    if (data.containsKey('exercicio_novo_id')) {
      context.handle(
        _exercicioNovoIdMeta,
        exercicioNovoId.isAcceptableOrUnknown(
          data['exercicio_novo_id']!,
          _exercicioNovoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exercicioNovoIdMeta);
    }
    if (data.containsKey('escopo')) {
      context.handle(
        _escopoMeta,
        escopo.isAcceptableOrUnknown(data['escopo']!, _escopoMeta),
      );
    } else if (isInserting) {
      context.missing(_escopoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Substituicao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Substituicao(
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
      excluidoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}excluido_em'],
      ),
      sincronizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sincronizado_em'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      ),
      itemPlanoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_plano_id'],
      )!,
      exercicioOriginalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercicio_original_id'],
      )!,
      exercicioNovoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercicio_novo_id'],
      )!,
      escopo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}escopo'],
      )!,
    );
  }

  @override
  $SubstituicoesTable createAlias(String alias) {
    return $SubstituicoesTable(attachedDatabase, alias);
  }
}

class Substituicao extends DataClass implements Insertable<Substituicao> {
  final DateTime atualizadoEm;
  final DateTime? excluidoEm;
  final DateTime? sincronizadoEm;
  final String id;
  final String? usuarioId;
  final String itemPlanoId;
  final String exercicioOriginalId;
  final String exercicioNovoId;
  final String escopo;
  const Substituicao({
    required this.atualizadoEm,
    this.excluidoEm,
    this.sincronizadoEm,
    required this.id,
    this.usuarioId,
    required this.itemPlanoId,
    required this.exercicioOriginalId,
    required this.exercicioNovoId,
    required this.escopo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    if (!nullToAbsent || excluidoEm != null) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm);
    }
    if (!nullToAbsent || sincronizadoEm != null) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || usuarioId != null) {
      map['usuario_id'] = Variable<String>(usuarioId);
    }
    map['item_plano_id'] = Variable<String>(itemPlanoId);
    map['exercicio_original_id'] = Variable<String>(exercicioOriginalId);
    map['exercicio_novo_id'] = Variable<String>(exercicioNovoId);
    map['escopo'] = Variable<String>(escopo);
    return map;
  }

  SubstituicoesCompanion toCompanion(bool nullToAbsent) {
    return SubstituicoesCompanion(
      atualizadoEm: Value(atualizadoEm),
      excluidoEm: excluidoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(excluidoEm),
      sincronizadoEm: sincronizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(sincronizadoEm),
      id: Value(id),
      usuarioId: usuarioId == null && nullToAbsent
          ? const Value.absent()
          : Value(usuarioId),
      itemPlanoId: Value(itemPlanoId),
      exercicioOriginalId: Value(exercicioOriginalId),
      exercicioNovoId: Value(exercicioNovoId),
      escopo: Value(escopo),
    );
  }

  factory Substituicao.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Substituicao(
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
      excluidoEm: serializer.fromJson<DateTime?>(json['excluidoEm']),
      sincronizadoEm: serializer.fromJson<DateTime?>(json['sincronizadoEm']),
      id: serializer.fromJson<String>(json['id']),
      usuarioId: serializer.fromJson<String?>(json['usuarioId']),
      itemPlanoId: serializer.fromJson<String>(json['itemPlanoId']),
      exercicioOriginalId: serializer.fromJson<String>(
        json['exercicioOriginalId'],
      ),
      exercicioNovoId: serializer.fromJson<String>(json['exercicioNovoId']),
      escopo: serializer.fromJson<String>(json['escopo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
      'excluidoEm': serializer.toJson<DateTime?>(excluidoEm),
      'sincronizadoEm': serializer.toJson<DateTime?>(sincronizadoEm),
      'id': serializer.toJson<String>(id),
      'usuarioId': serializer.toJson<String?>(usuarioId),
      'itemPlanoId': serializer.toJson<String>(itemPlanoId),
      'exercicioOriginalId': serializer.toJson<String>(exercicioOriginalId),
      'exercicioNovoId': serializer.toJson<String>(exercicioNovoId),
      'escopo': serializer.toJson<String>(escopo),
    };
  }

  Substituicao copyWith({
    DateTime? atualizadoEm,
    Value<DateTime?> excluidoEm = const Value.absent(),
    Value<DateTime?> sincronizadoEm = const Value.absent(),
    String? id,
    Value<String?> usuarioId = const Value.absent(),
    String? itemPlanoId,
    String? exercicioOriginalId,
    String? exercicioNovoId,
    String? escopo,
  }) => Substituicao(
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    excluidoEm: excluidoEm.present ? excluidoEm.value : this.excluidoEm,
    sincronizadoEm: sincronizadoEm.present
        ? sincronizadoEm.value
        : this.sincronizadoEm,
    id: id ?? this.id,
    usuarioId: usuarioId.present ? usuarioId.value : this.usuarioId,
    itemPlanoId: itemPlanoId ?? this.itemPlanoId,
    exercicioOriginalId: exercicioOriginalId ?? this.exercicioOriginalId,
    exercicioNovoId: exercicioNovoId ?? this.exercicioNovoId,
    escopo: escopo ?? this.escopo,
  );
  Substituicao copyWithCompanion(SubstituicoesCompanion data) {
    return Substituicao(
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
      excluidoEm: data.excluidoEm.present
          ? data.excluidoEm.value
          : this.excluidoEm,
      sincronizadoEm: data.sincronizadoEm.present
          ? data.sincronizadoEm.value
          : this.sincronizadoEm,
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      itemPlanoId: data.itemPlanoId.present
          ? data.itemPlanoId.value
          : this.itemPlanoId,
      exercicioOriginalId: data.exercicioOriginalId.present
          ? data.exercicioOriginalId.value
          : this.exercicioOriginalId,
      exercicioNovoId: data.exercicioNovoId.present
          ? data.exercicioNovoId.value
          : this.exercicioNovoId,
      escopo: data.escopo.present ? data.escopo.value : this.escopo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Substituicao(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('itemPlanoId: $itemPlanoId, ')
          ..write('exercicioOriginalId: $exercicioOriginalId, ')
          ..write('exercicioNovoId: $exercicioNovoId, ')
          ..write('escopo: $escopo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    atualizadoEm,
    excluidoEm,
    sincronizadoEm,
    id,
    usuarioId,
    itemPlanoId,
    exercicioOriginalId,
    exercicioNovoId,
    escopo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Substituicao &&
          other.atualizadoEm == this.atualizadoEm &&
          other.excluidoEm == this.excluidoEm &&
          other.sincronizadoEm == this.sincronizadoEm &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.itemPlanoId == this.itemPlanoId &&
          other.exercicioOriginalId == this.exercicioOriginalId &&
          other.exercicioNovoId == this.exercicioNovoId &&
          other.escopo == this.escopo);
}

class SubstituicoesCompanion extends UpdateCompanion<Substituicao> {
  final Value<DateTime> atualizadoEm;
  final Value<DateTime?> excluidoEm;
  final Value<DateTime?> sincronizadoEm;
  final Value<String> id;
  final Value<String?> usuarioId;
  final Value<String> itemPlanoId;
  final Value<String> exercicioOriginalId;
  final Value<String> exercicioNovoId;
  final Value<String> escopo;
  final Value<int> rowid;
  const SubstituicoesCompanion({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.itemPlanoId = const Value.absent(),
    this.exercicioOriginalId = const Value.absent(),
    this.exercicioNovoId = const Value.absent(),
    this.escopo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubstituicoesCompanion.insert({
    this.atualizadoEm = const Value.absent(),
    this.excluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    required String id,
    this.usuarioId = const Value.absent(),
    required String itemPlanoId,
    required String exercicioOriginalId,
    required String exercicioNovoId,
    required String escopo,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemPlanoId = Value(itemPlanoId),
       exercicioOriginalId = Value(exercicioOriginalId),
       exercicioNovoId = Value(exercicioNovoId),
       escopo = Value(escopo);
  static Insertable<Substituicao> custom({
    Expression<DateTime>? atualizadoEm,
    Expression<DateTime>? excluidoEm,
    Expression<DateTime>? sincronizadoEm,
    Expression<String>? id,
    Expression<String>? usuarioId,
    Expression<String>? itemPlanoId,
    Expression<String>? exercicioOriginalId,
    Expression<String>? exercicioNovoId,
    Expression<String>? escopo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (excluidoEm != null) 'excluido_em': excluidoEm,
      if (sincronizadoEm != null) 'sincronizado_em': sincronizadoEm,
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (itemPlanoId != null) 'item_plano_id': itemPlanoId,
      if (exercicioOriginalId != null)
        'exercicio_original_id': exercicioOriginalId,
      if (exercicioNovoId != null) 'exercicio_novo_id': exercicioNovoId,
      if (escopo != null) 'escopo': escopo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubstituicoesCompanion copyWith({
    Value<DateTime>? atualizadoEm,
    Value<DateTime?>? excluidoEm,
    Value<DateTime?>? sincronizadoEm,
    Value<String>? id,
    Value<String?>? usuarioId,
    Value<String>? itemPlanoId,
    Value<String>? exercicioOriginalId,
    Value<String>? exercicioNovoId,
    Value<String>? escopo,
    Value<int>? rowid,
  }) {
    return SubstituicoesCompanion(
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      excluidoEm: excluidoEm ?? this.excluidoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      itemPlanoId: itemPlanoId ?? this.itemPlanoId,
      exercicioOriginalId: exercicioOriginalId ?? this.exercicioOriginalId,
      exercicioNovoId: exercicioNovoId ?? this.exercicioNovoId,
      escopo: escopo ?? this.escopo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (excluidoEm.present) {
      map['excluido_em'] = Variable<DateTime>(excluidoEm.value);
    }
    if (sincronizadoEm.present) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (itemPlanoId.present) {
      map['item_plano_id'] = Variable<String>(itemPlanoId.value);
    }
    if (exercicioOriginalId.present) {
      map['exercicio_original_id'] = Variable<String>(
        exercicioOriginalId.value,
      );
    }
    if (exercicioNovoId.present) {
      map['exercicio_novo_id'] = Variable<String>(exercicioNovoId.value);
    }
    if (escopo.present) {
      map['escopo'] = Variable<String>(escopo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubstituicoesCompanion(')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('excluidoEm: $excluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('itemPlanoId: $itemPlanoId, ')
          ..write('exercicioOriginalId: $exercicioOriginalId, ')
          ..write('exercicioNovoId: $exercicioNovoId, ')
          ..write('escopo: $escopo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExerciciosTable exercicios = $ExerciciosTable(this);
  late final $PlanosTreinoTable planosTreino = $PlanosTreinoTable(this);
  late final $SessoesPlanoTable sessoesPlano = $SessoesPlanoTable(this);
  late final $ItensPlanoTable itensPlano = $ItensPlanoTable(this);
  late final $TreinosTable treinos = $TreinosTable(this);
  late final $SeriesTable series = $SeriesTable(this);
  late final $SubstituicoesTable substituicoes = $SubstituicoesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    exercicios,
    planosTreino,
    sessoesPlano,
    itensPlano,
    treinos,
    series,
    substituicoes,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ExerciciosTableCreateCompanionBuilder = ExerciciosCompanion Function({
  required String id,
  required String nome,
  required String musculosAlvo,
  required String padraoMovimento,
  required String equipamento,
  required String tipoCarga,
  Value<double> passoCargaKg,
  Value<String?> videoUrl,
  Value<String?> fonteId,
  Value<int> rowid,
});
typedef $$ExerciciosTableUpdateCompanionBuilder = ExerciciosCompanion Function({
  Value<String> id,
  Value<String> nome,
  Value<String> musculosAlvo,
  Value<String> padraoMovimento,
  Value<String> equipamento,
  Value<String> tipoCarga,
  Value<double> passoCargaKg,
  Value<String?> videoUrl,
  Value<String?> fonteId,
  Value<int> rowid,
});

final class $$ExerciciosTableReferences
    extends BaseReferences<_$AppDatabase, $ExerciciosTable, Exercicio> {
  $$ExerciciosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItensPlanoTable, List<ItemPlano>>
  _itensPlanoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itensPlano,
    aliasName: 'exercicios__id__itens_plano__exercicio_id',
  );

  $$ItensPlanoTableProcessedTableManager get itensPlanoRefs {
    final manager = $$ItensPlanoTableTableManager(
      $_db,
      $_db.itensPlano,
    ).filter((f) => f.exercicioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itensPlanoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SeriesTable, List<Serie>> _seriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.series,
    aliasName: 'exercicios__id__series__exercicio_id',
  );

  $$SeriesTableProcessedTableManager get seriesRefs {
    final manager = $$SeriesTableTableManager(
      $_db,
      $_db.series,
    ).filter((f) => f.exercicioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_seriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubstituicoesTable, List<Substituicao>>
  _substituicoesComoOriginalTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.substituicoes,
        aliasName: 'exercicios__id__substituicoes__exercicio_original_id',
      );

  $$SubstituicoesTableProcessedTableManager get substituicoesComoOriginal {
    final manager = $$SubstituicoesTableTableManager($_db, $_db.substituicoes)
        .filter(
          (f) =>
              f.exercicioOriginalId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _substituicoesComoOriginalTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubstituicoesTable, List<Substituicao>>
  _substituicoesComoNovoTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.substituicoes,
        aliasName: 'exercicios__id__substituicoes__exercicio_novo_id',
      );

  $$SubstituicoesTableProcessedTableManager get substituicoesComoNovo {
    final manager = $$SubstituicoesTableTableManager($_db, $_db.substituicoes)
        .filter(
          (f) => f.exercicioNovoId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _substituicoesComoNovoTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExerciciosTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciciosTable> {
  $$ExerciciosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get musculosAlvo => $composableBuilder(
    column: $table.musculosAlvo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get padraoMovimento => $composableBuilder(
    column: $table.padraoMovimento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipamento => $composableBuilder(
    column: $table.equipamento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoCarga => $composableBuilder(
    column: $table.tipoCarga,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get passoCargaKg => $composableBuilder(
    column: $table.passoCargaKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fonteId => $composableBuilder(
    column: $table.fonteId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itensPlanoRefs(
    Expression<bool> Function($$ItensPlanoTableFilterComposer f) f,
  ) {
    final $$ItensPlanoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensPlano,
      getReferencedColumn: (t) => t.exercicioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensPlanoTableFilterComposer(
            $db: $db,
            $table: $db.itensPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> seriesRefs(
    Expression<bool> Function($$SeriesTableFilterComposer f) f,
  ) {
    final $$SeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.exercicioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableFilterComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> substituicoesComoOriginal(
    Expression<bool> Function($$SubstituicoesTableFilterComposer f) f,
  ) {
    final $$SubstituicoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.substituicoes,
      getReferencedColumn: (t) => t.exercicioOriginalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubstituicoesTableFilterComposer(
            $db: $db,
            $table: $db.substituicoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> substituicoesComoNovo(
    Expression<bool> Function($$SubstituicoesTableFilterComposer f) f,
  ) {
    final $$SubstituicoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.substituicoes,
      getReferencedColumn: (t) => t.exercicioNovoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubstituicoesTableFilterComposer(
            $db: $db,
            $table: $db.substituicoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExerciciosTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciciosTable> {
  $$ExerciciosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get musculosAlvo => $composableBuilder(
    column: $table.musculosAlvo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get padraoMovimento => $composableBuilder(
    column: $table.padraoMovimento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipamento => $composableBuilder(
    column: $table.equipamento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoCarga => $composableBuilder(
    column: $table.tipoCarga,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get passoCargaKg => $composableBuilder(
    column: $table.passoCargaKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoUrl => $composableBuilder(
    column: $table.videoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fonteId => $composableBuilder(
    column: $table.fonteId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciciosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciciosTable> {
  $$ExerciciosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get musculosAlvo => $composableBuilder(
    column: $table.musculosAlvo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get padraoMovimento => $composableBuilder(
    column: $table.padraoMovimento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipamento => $composableBuilder(
    column: $table.equipamento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipoCarga =>
      $composableBuilder(column: $table.tipoCarga, builder: (column) => column);

  GeneratedColumn<double> get passoCargaKg => $composableBuilder(
    column: $table.passoCargaKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => column);

  GeneratedColumn<String> get fonteId =>
      $composableBuilder(column: $table.fonteId, builder: (column) => column);

  Expression<T> itensPlanoRefs<T extends Object>(
    Expression<T> Function($$ItensPlanoTableAnnotationComposer a) f,
  ) {
    final $$ItensPlanoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensPlano,
      getReferencedColumn: (t) => t.exercicioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensPlanoTableAnnotationComposer(
            $db: $db,
            $table: $db.itensPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> seriesRefs<T extends Object>(
    Expression<T> Function($$SeriesTableAnnotationComposer a) f,
  ) {
    final $$SeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.exercicioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> substituicoesComoOriginal<T extends Object>(
    Expression<T> Function($$SubstituicoesTableAnnotationComposer a) f,
  ) {
    final $$SubstituicoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.substituicoes,
      getReferencedColumn: (t) => t.exercicioOriginalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubstituicoesTableAnnotationComposer(
            $db: $db,
            $table: $db.substituicoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> substituicoesComoNovo<T extends Object>(
    Expression<T> Function($$SubstituicoesTableAnnotationComposer a) f,
  ) {
    final $$SubstituicoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.substituicoes,
      getReferencedColumn: (t) => t.exercicioNovoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubstituicoesTableAnnotationComposer(
            $db: $db,
            $table: $db.substituicoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExerciciosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciciosTable,
          Exercicio,
          $$ExerciciosTableFilterComposer,
          $$ExerciciosTableOrderingComposer,
          $$ExerciciosTableAnnotationComposer,
          $$ExerciciosTableCreateCompanionBuilder,
          $$ExerciciosTableUpdateCompanionBuilder,
          (Exercicio, $$ExerciciosTableReferences),
          Exercicio,
          PrefetchHooks Function({
            bool itensPlanoRefs,
            bool seriesRefs,
            bool substituicoesComoOriginal,
            bool substituicoesComoNovo,
          })
        > {
  $$ExerciciosTableTableManager(_$AppDatabase db, $ExerciciosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciciosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciciosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciciosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> musculosAlvo = const Value.absent(),
                Value<String> padraoMovimento = const Value.absent(),
                Value<String> equipamento = const Value.absent(),
                Value<String> tipoCarga = const Value.absent(),
                Value<double> passoCargaKg = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String?> fonteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciciosCompanion(
                id: id,
                nome: nome,
                musculosAlvo: musculosAlvo,
                padraoMovimento: padraoMovimento,
                equipamento: equipamento,
                tipoCarga: tipoCarga,
                passoCargaKg: passoCargaKg,
                videoUrl: videoUrl,
                fonteId: fonteId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nome,
                required String musculosAlvo,
                required String padraoMovimento,
                required String equipamento,
                required String tipoCarga,
                Value<double> passoCargaKg = const Value.absent(),
                Value<String?> videoUrl = const Value.absent(),
                Value<String?> fonteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciciosCompanion.insert(
                id: id,
                nome: nome,
                musculosAlvo: musculosAlvo,
                padraoMovimento: padraoMovimento,
                equipamento: equipamento,
                tipoCarga: tipoCarga,
                passoCargaKg: passoCargaKg,
                videoUrl: videoUrl,
                fonteId: fonteId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExerciciosTable, Exercicio>(table),
                  $$ExerciciosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                itensPlanoRefs = false,
                seriesRefs = false,
                substituicoesComoOriginal = false,
                substituicoesComoNovo = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itensPlanoRefs) db.itensPlano,
                    if (seriesRefs) db.series,
                    if (substituicoesComoOriginal) db.substituicoes,
                    if (substituicoesComoNovo) db.substituicoes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itensPlanoRefs)
                        await $_getPrefetchedData<
                          Exercicio,
                          $ExerciciosTable,
                          ItemPlano
                        >(
                          currentTable: table,
                          referencedTable: $$ExerciciosTableReferences
                              ._itensPlanoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExerciciosTableReferences(
                                db,
                                table,
                                p0,
                              ).itensPlanoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exercicioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (seriesRefs)
                        await $_getPrefetchedData<
                          Exercicio,
                          $ExerciciosTable,
                          Serie
                        >(
                          currentTable: table,
                          referencedTable: $$ExerciciosTableReferences
                              ._seriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExerciciosTableReferences(
                                db,
                                table,
                                p0,
                              ).seriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exercicioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (substituicoesComoOriginal)
                        await $_getPrefetchedData<
                          Exercicio,
                          $ExerciciosTable,
                          Substituicao
                        >(
                          currentTable: table,
                          referencedTable: $$ExerciciosTableReferences
                              ._substituicoesComoOriginalTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExerciciosTableReferences(
                                db,
                                table,
                                p0,
                              ).substituicoesComoOriginal,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exercicioOriginalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (substituicoesComoNovo)
                        await $_getPrefetchedData<
                          Exercicio,
                          $ExerciciosTable,
                          Substituicao
                        >(
                          currentTable: table,
                          referencedTable: $$ExerciciosTableReferences
                              ._substituicoesComoNovoTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExerciciosTableReferences(
                                db,
                                table,
                                p0,
                              ).substituicoesComoNovo,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exercicioNovoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExerciciosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciciosTable,
      Exercicio,
      $$ExerciciosTableFilterComposer,
      $$ExerciciosTableOrderingComposer,
      $$ExerciciosTableAnnotationComposer,
      $$ExerciciosTableCreateCompanionBuilder,
      $$ExerciciosTableUpdateCompanionBuilder,
      (Exercicio, $$ExerciciosTableReferences),
      Exercicio,
      PrefetchHooks Function({
        bool itensPlanoRefs,
        bool seriesRefs,
        bool substituicoesComoOriginal,
        bool substituicoesComoNovo,
      })
    >;
typedef $$PlanosTreinoTableCreateCompanionBuilder =
    PlanosTreinoCompanion Function({
      Value<DateTime> atualizadoEm,
      Value<DateTime?> excluidoEm,
      Value<DateTime?> sincronizadoEm,
      required String id,
      Value<String?> usuarioId,
      required String divisao,
      required int semanas,
      required DateTime inicioEm,
      Value<int> versao,
      Value<bool> ativo,
      Value<int> rowid,
    });
typedef $$PlanosTreinoTableUpdateCompanionBuilder =
    PlanosTreinoCompanion Function({
      Value<DateTime> atualizadoEm,
      Value<DateTime?> excluidoEm,
      Value<DateTime?> sincronizadoEm,
      Value<String> id,
      Value<String?> usuarioId,
      Value<String> divisao,
      Value<int> semanas,
      Value<DateTime> inicioEm,
      Value<int> versao,
      Value<bool> ativo,
      Value<int> rowid,
    });

final class $$PlanosTreinoTableReferences
    extends BaseReferences<_$AppDatabase, $PlanosTreinoTable, PlanoTreino> {
  $$PlanosTreinoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessoesPlanoTable, List<SessaoPlano>>
  _sessoesPlanoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessoesPlano,
    aliasName: 'planos_treino__id__sessoes_plano__plano_id',
  );

  $$SessoesPlanoTableProcessedTableManager get sessoesPlanoRefs {
    final manager = $$SessoesPlanoTableTableManager(
      $_db,
      $_db.sessoesPlano,
    ).filter((f) => f.planoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessoesPlanoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlanosTreinoTableFilterComposer
    extends Composer<_$AppDatabase, $PlanosTreinoTable> {
  $$PlanosTreinoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get divisao => $composableBuilder(
    column: $table.divisao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get semanas => $composableBuilder(
    column: $table.semanas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get inicioEm => $composableBuilder(
    column: $table.inicioEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versao => $composableBuilder(
    column: $table.versao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessoesPlanoRefs(
    Expression<bool> Function($$SessoesPlanoTableFilterComposer f) f,
  ) {
    final $$SessoesPlanoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessoesPlano,
      getReferencedColumn: (t) => t.planoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessoesPlanoTableFilterComposer(
            $db: $db,
            $table: $db.sessoesPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanosTreinoTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanosTreinoTable> {
  $$PlanosTreinoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get divisao => $composableBuilder(
    column: $table.divisao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get semanas => $composableBuilder(
    column: $table.semanas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get inicioEm => $composableBuilder(
    column: $table.inicioEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versao => $composableBuilder(
    column: $table.versao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanosTreinoTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanosTreinoTable> {
  $$PlanosTreinoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get divisao =>
      $composableBuilder(column: $table.divisao, builder: (column) => column);

  GeneratedColumn<int> get semanas =>
      $composableBuilder(column: $table.semanas, builder: (column) => column);

  GeneratedColumn<DateTime> get inicioEm =>
      $composableBuilder(column: $table.inicioEm, builder: (column) => column);

  GeneratedColumn<int> get versao =>
      $composableBuilder(column: $table.versao, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  Expression<T> sessoesPlanoRefs<T extends Object>(
    Expression<T> Function($$SessoesPlanoTableAnnotationComposer a) f,
  ) {
    final $$SessoesPlanoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessoesPlano,
      getReferencedColumn: (t) => t.planoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessoesPlanoTableAnnotationComposer(
            $db: $db,
            $table: $db.sessoesPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanosTreinoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanosTreinoTable,
          PlanoTreino,
          $$PlanosTreinoTableFilterComposer,
          $$PlanosTreinoTableOrderingComposer,
          $$PlanosTreinoTableAnnotationComposer,
          $$PlanosTreinoTableCreateCompanionBuilder,
          $$PlanosTreinoTableUpdateCompanionBuilder,
          (PlanoTreino, $$PlanosTreinoTableReferences),
          PlanoTreino,
          PrefetchHooks Function({bool sessoesPlanoRefs})
        > {
  $$PlanosTreinoTableTableManager(_$AppDatabase db, $PlanosTreinoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanosTreinoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanosTreinoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanosTreinoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> usuarioId = const Value.absent(),
                Value<String> divisao = const Value.absent(),
                Value<int> semanas = const Value.absent(),
                Value<DateTime> inicioEm = const Value.absent(),
                Value<int> versao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanosTreinoCompanion(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                usuarioId: usuarioId,
                divisao: divisao,
                semanas: semanas,
                inicioEm: inicioEm,
                versao: versao,
                ativo: ativo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                required String id,
                Value<String?> usuarioId = const Value.absent(),
                required String divisao,
                required int semanas,
                required DateTime inicioEm,
                Value<int> versao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanosTreinoCompanion.insert(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                usuarioId: usuarioId,
                divisao: divisao,
                semanas: semanas,
                inicioEm: inicioEm,
                versao: versao,
                ativo: ativo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanosTreinoTable, PlanoTreino>(table),
                  $$PlanosTreinoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessoesPlanoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessoesPlanoRefs) db.sessoesPlano],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessoesPlanoRefs)
                    await $_getPrefetchedData<
                      PlanoTreino,
                      $PlanosTreinoTable,
                      SessaoPlano
                    >(
                      currentTable: table,
                      referencedTable: $$PlanosTreinoTableReferences
                          ._sessoesPlanoRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlanosTreinoTableReferences(
                            db,
                            table,
                            p0,
                          ).sessoesPlanoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.planoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlanosTreinoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanosTreinoTable,
      PlanoTreino,
      $$PlanosTreinoTableFilterComposer,
      $$PlanosTreinoTableOrderingComposer,
      $$PlanosTreinoTableAnnotationComposer,
      $$PlanosTreinoTableCreateCompanionBuilder,
      $$PlanosTreinoTableUpdateCompanionBuilder,
      (PlanoTreino, $$PlanosTreinoTableReferences),
      PlanoTreino,
      PrefetchHooks Function({bool sessoesPlanoRefs})
    >;
typedef $$SessoesPlanoTableCreateCompanionBuilder =
    SessoesPlanoCompanion Function({
      Value<DateTime> atualizadoEm,
      Value<DateTime?> excluidoEm,
      Value<DateTime?> sincronizadoEm,
      required String id,
      required String planoId,
      required String dia,
      required String foco,
      required int ordem,
      Value<int> rowid,
    });
typedef $$SessoesPlanoTableUpdateCompanionBuilder =
    SessoesPlanoCompanion Function({
      Value<DateTime> atualizadoEm,
      Value<DateTime?> excluidoEm,
      Value<DateTime?> sincronizadoEm,
      Value<String> id,
      Value<String> planoId,
      Value<String> dia,
      Value<String> foco,
      Value<int> ordem,
      Value<int> rowid,
    });

final class $$SessoesPlanoTableReferences
    extends BaseReferences<_$AppDatabase, $SessoesPlanoTable, SessaoPlano> {
  $$SessoesPlanoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlanosTreinoTable _planoIdTable(_$AppDatabase db) =>
      db.planosTreino.createAlias('sessoes_plano__plano_id__planos_treino__id');

  $$PlanosTreinoTableProcessedTableManager get planoId {
    final $_column = $_itemColumn<String>('plano_id')!;

    final manager = $$PlanosTreinoTableTableManager(
      $_db,
      $_db.planosTreino,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItensPlanoTable, List<ItemPlano>>
  _itensPlanoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itensPlano,
    aliasName: 'sessoes_plano__id__itens_plano__sessao_plano_id',
  );

  $$ItensPlanoTableProcessedTableManager get itensPlanoRefs {
    final manager = $$ItensPlanoTableTableManager(
      $_db,
      $_db.itensPlano,
    ).filter((f) => f.sessaoPlanoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itensPlanoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TreinosTable, List<Treino>> _treinosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.treinos,
    aliasName: 'sessoes_plano__id__treinos__sessao_plano_id',
  );

  $$TreinosTableProcessedTableManager get treinosRefs {
    final manager = $$TreinosTableTableManager(
      $_db,
      $_db.treinos,
    ).filter((f) => f.sessaoPlanoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_treinosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessoesPlanoTableFilterComposer
    extends Composer<_$AppDatabase, $SessoesPlanoTable> {
  $$SessoesPlanoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dia => $composableBuilder(
    column: $table.dia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foco => $composableBuilder(
    column: $table.foco,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );

  $$PlanosTreinoTableFilterComposer get planoId {
    final $$PlanosTreinoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planoId,
      referencedTable: $db.planosTreino,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanosTreinoTableFilterComposer(
            $db: $db,
            $table: $db.planosTreino,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itensPlanoRefs(
    Expression<bool> Function($$ItensPlanoTableFilterComposer f) f,
  ) {
    final $$ItensPlanoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensPlano,
      getReferencedColumn: (t) => t.sessaoPlanoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensPlanoTableFilterComposer(
            $db: $db,
            $table: $db.itensPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> treinosRefs(
    Expression<bool> Function($$TreinosTableFilterComposer f) f,
  ) {
    final $$TreinosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.treinos,
      getReferencedColumn: (t) => t.sessaoPlanoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TreinosTableFilterComposer(
            $db: $db,
            $table: $db.treinos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessoesPlanoTableOrderingComposer
    extends Composer<_$AppDatabase, $SessoesPlanoTable> {
  $$SessoesPlanoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dia => $composableBuilder(
    column: $table.dia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foco => $composableBuilder(
    column: $table.foco,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlanosTreinoTableOrderingComposer get planoId {
    final $$PlanosTreinoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planoId,
      referencedTable: $db.planosTreino,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanosTreinoTableOrderingComposer(
            $db: $db,
            $table: $db.planosTreino,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessoesPlanoTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessoesPlanoTable> {
  $$SessoesPlanoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dia =>
      $composableBuilder(column: $table.dia, builder: (column) => column);

  GeneratedColumn<String> get foco =>
      $composableBuilder(column: $table.foco, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  $$PlanosTreinoTableAnnotationComposer get planoId {
    final $$PlanosTreinoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planoId,
      referencedTable: $db.planosTreino,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanosTreinoTableAnnotationComposer(
            $db: $db,
            $table: $db.planosTreino,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itensPlanoRefs<T extends Object>(
    Expression<T> Function($$ItensPlanoTableAnnotationComposer a) f,
  ) {
    final $$ItensPlanoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensPlano,
      getReferencedColumn: (t) => t.sessaoPlanoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensPlanoTableAnnotationComposer(
            $db: $db,
            $table: $db.itensPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> treinosRefs<T extends Object>(
    Expression<T> Function($$TreinosTableAnnotationComposer a) f,
  ) {
    final $$TreinosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.treinos,
      getReferencedColumn: (t) => t.sessaoPlanoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TreinosTableAnnotationComposer(
            $db: $db,
            $table: $db.treinos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessoesPlanoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessoesPlanoTable,
          SessaoPlano,
          $$SessoesPlanoTableFilterComposer,
          $$SessoesPlanoTableOrderingComposer,
          $$SessoesPlanoTableAnnotationComposer,
          $$SessoesPlanoTableCreateCompanionBuilder,
          $$SessoesPlanoTableUpdateCompanionBuilder,
          (SessaoPlano, $$SessoesPlanoTableReferences),
          SessaoPlano,
          PrefetchHooks Function({
            bool planoId,
            bool itensPlanoRefs,
            bool treinosRefs,
          })
        > {
  $$SessoesPlanoTableTableManager(_$AppDatabase db, $SessoesPlanoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessoesPlanoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessoesPlanoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessoesPlanoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> planoId = const Value.absent(),
                Value<String> dia = const Value.absent(),
                Value<String> foco = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessoesPlanoCompanion(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                planoId: planoId,
                dia: dia,
                foco: foco,
                ordem: ordem,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                required String id,
                required String planoId,
                required String dia,
                required String foco,
                required int ordem,
                Value<int> rowid = const Value.absent(),
              }) => SessoesPlanoCompanion.insert(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                planoId: planoId,
                dia: dia,
                foco: foco,
                ordem: ordem,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessoesPlanoTable, SessaoPlano>(table),
                  $$SessoesPlanoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({planoId = false, itensPlanoRefs = false, treinosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itensPlanoRefs) db.itensPlano,
                    if (treinosRefs) db.treinos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (planoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.planoId,
                            referencedTable: $$SessoesPlanoTableReferences
                                ._planoIdTable(db),
                            referencedColumn: $$SessoesPlanoTableReferences
                                ._planoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itensPlanoRefs)
                        await $_getPrefetchedData<
                          SessaoPlano,
                          $SessoesPlanoTable,
                          ItemPlano
                        >(
                          currentTable: table,
                          referencedTable: $$SessoesPlanoTableReferences
                              ._itensPlanoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessoesPlanoTableReferences(
                                db,
                                table,
                                p0,
                              ).itensPlanoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessaoPlanoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (treinosRefs)
                        await $_getPrefetchedData<
                          SessaoPlano,
                          $SessoesPlanoTable,
                          Treino
                        >(
                          currentTable: table,
                          referencedTable: $$SessoesPlanoTableReferences
                              ._treinosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessoesPlanoTableReferences(
                                db,
                                table,
                                p0,
                              ).treinosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessaoPlanoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessoesPlanoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessoesPlanoTable,
      SessaoPlano,
      $$SessoesPlanoTableFilterComposer,
      $$SessoesPlanoTableOrderingComposer,
      $$SessoesPlanoTableAnnotationComposer,
      $$SessoesPlanoTableCreateCompanionBuilder,
      $$SessoesPlanoTableUpdateCompanionBuilder,
      (SessaoPlano, $$SessoesPlanoTableReferences),
      SessaoPlano,
      PrefetchHooks Function({
        bool planoId,
        bool itensPlanoRefs,
        bool treinosRefs,
      })
    >;
typedef $$ItensPlanoTableCreateCompanionBuilder = ItensPlanoCompanion Function({
  Value<DateTime> atualizadoEm,
  Value<DateTime?> excluidoEm,
  Value<DateTime?> sincronizadoEm,
  required String id,
  required String sessaoPlanoId,
  required String exercicioId,
  required int ordem,
  required int series,
  required int repsMin,
  required int repsMax,
  Value<int?> rirAlvo,
  required int descansoS,
  Value<double?> cargaPlanKg,
  Value<String?> justificativa,
  Value<String?> fonteId,
  Value<int> rowid,
});
typedef $$ItensPlanoTableUpdateCompanionBuilder = ItensPlanoCompanion Function({
  Value<DateTime> atualizadoEm,
  Value<DateTime?> excluidoEm,
  Value<DateTime?> sincronizadoEm,
  Value<String> id,
  Value<String> sessaoPlanoId,
  Value<String> exercicioId,
  Value<int> ordem,
  Value<int> series,
  Value<int> repsMin,
  Value<int> repsMax,
  Value<int?> rirAlvo,
  Value<int> descansoS,
  Value<double?> cargaPlanKg,
  Value<String?> justificativa,
  Value<String?> fonteId,
  Value<int> rowid,
});

final class $$ItensPlanoTableReferences
    extends BaseReferences<_$AppDatabase, $ItensPlanoTable, ItemPlano> {
  $$ItensPlanoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessoesPlanoTable _sessaoPlanoIdTable(_$AppDatabase db) => db
      .sessoesPlano
      .createAlias('itens_plano__sessao_plano_id__sessoes_plano__id');

  $$SessoesPlanoTableProcessedTableManager get sessaoPlanoId {
    final $_column = $_itemColumn<String>('sessao_plano_id')!;

    final manager = $$SessoesPlanoTableTableManager(
      $_db,
      $_db.sessoesPlano,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessaoPlanoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExerciciosTable _exercicioIdTable(_$AppDatabase db) =>
      db.exercicios.createAlias('itens_plano__exercicio_id__exercicios__id');

  $$ExerciciosTableProcessedTableManager get exercicioId {
    final $_column = $_itemColumn<String>('exercicio_id')!;

    final manager = $$ExerciciosTableTableManager(
      $_db,
      $_db.exercicios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exercicioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SeriesTable, List<Serie>> _seriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.series,
    aliasName: 'itens_plano__id__series__item_plano_id',
  );

  $$SeriesTableProcessedTableManager get seriesRefs {
    final manager = $$SeriesTableTableManager(
      $_db,
      $_db.series,
    ).filter((f) => f.itemPlanoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_seriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubstituicoesTable, List<Substituicao>>
  _substituicoesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.substituicoes,
    aliasName: 'itens_plano__id__substituicoes__item_plano_id',
  );

  $$SubstituicoesTableProcessedTableManager get substituicoesRefs {
    final manager = $$SubstituicoesTableTableManager(
      $_db,
      $_db.substituicoes,
    ).filter((f) => f.itemPlanoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_substituicoesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItensPlanoTableFilterComposer
    extends Composer<_$AppDatabase, $ItensPlanoTable> {
  $$ItensPlanoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get series => $composableBuilder(
    column: $table.series,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsMin => $composableBuilder(
    column: $table.repsMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsMax => $composableBuilder(
    column: $table.repsMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rirAlvo => $composableBuilder(
    column: $table.rirAlvo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get descansoS => $composableBuilder(
    column: $table.descansoS,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cargaPlanKg => $composableBuilder(
    column: $table.cargaPlanKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get justificativa => $composableBuilder(
    column: $table.justificativa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fonteId => $composableBuilder(
    column: $table.fonteId,
    builder: (column) => ColumnFilters(column),
  );

  $$SessoesPlanoTableFilterComposer get sessaoPlanoId {
    final $$SessoesPlanoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessaoPlanoId,
      referencedTable: $db.sessoesPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessoesPlanoTableFilterComposer(
            $db: $db,
            $table: $db.sessoesPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableFilterComposer get exercicioId {
    final $$ExerciciosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableFilterComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> seriesRefs(
    Expression<bool> Function($$SeriesTableFilterComposer f) f,
  ) {
    final $$SeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.itemPlanoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableFilterComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> substituicoesRefs(
    Expression<bool> Function($$SubstituicoesTableFilterComposer f) f,
  ) {
    final $$SubstituicoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.substituicoes,
      getReferencedColumn: (t) => t.itemPlanoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubstituicoesTableFilterComposer(
            $db: $db,
            $table: $db.substituicoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItensPlanoTableOrderingComposer
    extends Composer<_$AppDatabase, $ItensPlanoTable> {
  $$ItensPlanoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get series => $composableBuilder(
    column: $table.series,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsMin => $composableBuilder(
    column: $table.repsMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsMax => $composableBuilder(
    column: $table.repsMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rirAlvo => $composableBuilder(
    column: $table.rirAlvo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get descansoS => $composableBuilder(
    column: $table.descansoS,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cargaPlanKg => $composableBuilder(
    column: $table.cargaPlanKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get justificativa => $composableBuilder(
    column: $table.justificativa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fonteId => $composableBuilder(
    column: $table.fonteId,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessoesPlanoTableOrderingComposer get sessaoPlanoId {
    final $$SessoesPlanoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessaoPlanoId,
      referencedTable: $db.sessoesPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessoesPlanoTableOrderingComposer(
            $db: $db,
            $table: $db.sessoesPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableOrderingComposer get exercicioId {
    final $$ExerciciosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableOrderingComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItensPlanoTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItensPlanoTable> {
  $$ItensPlanoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  GeneratedColumn<int> get series =>
      $composableBuilder(column: $table.series, builder: (column) => column);

  GeneratedColumn<int> get repsMin =>
      $composableBuilder(column: $table.repsMin, builder: (column) => column);

  GeneratedColumn<int> get repsMax =>
      $composableBuilder(column: $table.repsMax, builder: (column) => column);

  GeneratedColumn<int> get rirAlvo =>
      $composableBuilder(column: $table.rirAlvo, builder: (column) => column);

  GeneratedColumn<int> get descansoS =>
      $composableBuilder(column: $table.descansoS, builder: (column) => column);

  GeneratedColumn<double> get cargaPlanKg => $composableBuilder(
    column: $table.cargaPlanKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get justificativa => $composableBuilder(
    column: $table.justificativa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fonteId =>
      $composableBuilder(column: $table.fonteId, builder: (column) => column);

  $$SessoesPlanoTableAnnotationComposer get sessaoPlanoId {
    final $$SessoesPlanoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessaoPlanoId,
      referencedTable: $db.sessoesPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessoesPlanoTableAnnotationComposer(
            $db: $db,
            $table: $db.sessoesPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableAnnotationComposer get exercicioId {
    final $$ExerciciosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableAnnotationComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> seriesRefs<T extends Object>(
    Expression<T> Function($$SeriesTableAnnotationComposer a) f,
  ) {
    final $$SeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.itemPlanoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> substituicoesRefs<T extends Object>(
    Expression<T> Function($$SubstituicoesTableAnnotationComposer a) f,
  ) {
    final $$SubstituicoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.substituicoes,
      getReferencedColumn: (t) => t.itemPlanoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubstituicoesTableAnnotationComposer(
            $db: $db,
            $table: $db.substituicoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItensPlanoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItensPlanoTable,
          ItemPlano,
          $$ItensPlanoTableFilterComposer,
          $$ItensPlanoTableOrderingComposer,
          $$ItensPlanoTableAnnotationComposer,
          $$ItensPlanoTableCreateCompanionBuilder,
          $$ItensPlanoTableUpdateCompanionBuilder,
          (ItemPlano, $$ItensPlanoTableReferences),
          ItemPlano,
          PrefetchHooks Function({
            bool sessaoPlanoId,
            bool exercicioId,
            bool seriesRefs,
            bool substituicoesRefs,
          })
        > {
  $$ItensPlanoTableTableManager(_$AppDatabase db, $ItensPlanoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItensPlanoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItensPlanoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItensPlanoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> sessaoPlanoId = const Value.absent(),
                Value<String> exercicioId = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> series = const Value.absent(),
                Value<int> repsMin = const Value.absent(),
                Value<int> repsMax = const Value.absent(),
                Value<int?> rirAlvo = const Value.absent(),
                Value<int> descansoS = const Value.absent(),
                Value<double?> cargaPlanKg = const Value.absent(),
                Value<String?> justificativa = const Value.absent(),
                Value<String?> fonteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItensPlanoCompanion(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                sessaoPlanoId: sessaoPlanoId,
                exercicioId: exercicioId,
                ordem: ordem,
                series: series,
                repsMin: repsMin,
                repsMax: repsMax,
                rirAlvo: rirAlvo,
                descansoS: descansoS,
                cargaPlanKg: cargaPlanKg,
                justificativa: justificativa,
                fonteId: fonteId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                required String id,
                required String sessaoPlanoId,
                required String exercicioId,
                required int ordem,
                required int series,
                required int repsMin,
                required int repsMax,
                Value<int?> rirAlvo = const Value.absent(),
                required int descansoS,
                Value<double?> cargaPlanKg = const Value.absent(),
                Value<String?> justificativa = const Value.absent(),
                Value<String?> fonteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItensPlanoCompanion.insert(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                sessaoPlanoId: sessaoPlanoId,
                exercicioId: exercicioId,
                ordem: ordem,
                series: series,
                repsMin: repsMin,
                repsMax: repsMax,
                rirAlvo: rirAlvo,
                descansoS: descansoS,
                cargaPlanKg: cargaPlanKg,
                justificativa: justificativa,
                fonteId: fonteId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItensPlanoTable, ItemPlano>(table),
                  $$ItensPlanoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessaoPlanoId = false,
                exercicioId = false,
                seriesRefs = false,
                substituicoesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (seriesRefs) db.series,
                    if (substituicoesRefs) db.substituicoes,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessaoPlanoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessaoPlanoId,
                            referencedTable: $$ItensPlanoTableReferences
                                ._sessaoPlanoIdTable(db),
                            referencedColumn: $$ItensPlanoTableReferences
                                ._sessaoPlanoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exercicioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exercicioId,
                            referencedTable: $$ItensPlanoTableReferences
                                ._exercicioIdTable(db),
                            referencedColumn: $$ItensPlanoTableReferences
                                ._exercicioIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (seriesRefs)
                        await $_getPrefetchedData<
                          ItemPlano,
                          $ItensPlanoTable,
                          Serie
                        >(
                          currentTable: table,
                          referencedTable: $$ItensPlanoTableReferences
                              ._seriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItensPlanoTableReferences(
                                db,
                                table,
                                p0,
                              ).seriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemPlanoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (substituicoesRefs)
                        await $_getPrefetchedData<
                          ItemPlano,
                          $ItensPlanoTable,
                          Substituicao
                        >(
                          currentTable: table,
                          referencedTable: $$ItensPlanoTableReferences
                              ._substituicoesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItensPlanoTableReferences(
                                db,
                                table,
                                p0,
                              ).substituicoesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemPlanoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ItensPlanoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItensPlanoTable,
      ItemPlano,
      $$ItensPlanoTableFilterComposer,
      $$ItensPlanoTableOrderingComposer,
      $$ItensPlanoTableAnnotationComposer,
      $$ItensPlanoTableCreateCompanionBuilder,
      $$ItensPlanoTableUpdateCompanionBuilder,
      (ItemPlano, $$ItensPlanoTableReferences),
      ItemPlano,
      PrefetchHooks Function({
        bool sessaoPlanoId,
        bool exercicioId,
        bool seriesRefs,
        bool substituicoesRefs,
      })
    >;
typedef $$TreinosTableCreateCompanionBuilder = TreinosCompanion Function({
  Value<DateTime> atualizadoEm,
  Value<DateTime?> excluidoEm,
  Value<DateTime?> sincronizadoEm,
  required String id,
  Value<String?> usuarioId,
  required String sessaoPlanoId,
  required DateTime iniciadoEm,
  Value<DateTime?> finalizadoEm,
  Value<String> status,
  Value<String> modo,
  Value<int> rowid,
});
typedef $$TreinosTableUpdateCompanionBuilder = TreinosCompanion Function({
  Value<DateTime> atualizadoEm,
  Value<DateTime?> excluidoEm,
  Value<DateTime?> sincronizadoEm,
  Value<String> id,
  Value<String?> usuarioId,
  Value<String> sessaoPlanoId,
  Value<DateTime> iniciadoEm,
  Value<DateTime?> finalizadoEm,
  Value<String> status,
  Value<String> modo,
  Value<int> rowid,
});

final class $$TreinosTableReferences
    extends BaseReferences<_$AppDatabase, $TreinosTable, Treino> {
  $$TreinosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessoesPlanoTable _sessaoPlanoIdTable(_$AppDatabase db) => db
      .sessoesPlano
      .createAlias('treinos__sessao_plano_id__sessoes_plano__id');

  $$SessoesPlanoTableProcessedTableManager get sessaoPlanoId {
    final $_column = $_itemColumn<String>('sessao_plano_id')!;

    final manager = $$SessoesPlanoTableTableManager(
      $_db,
      $_db.sessoesPlano,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessaoPlanoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SeriesTable, List<Serie>> _seriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.series,
    aliasName: 'treinos__id__series__treino_id',
  );

  $$SeriesTableProcessedTableManager get seriesRefs {
    final manager = $$SeriesTableTableManager(
      $_db,
      $_db.series,
    ).filter((f) => f.treinoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_seriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TreinosTableFilterComposer
    extends Composer<_$AppDatabase, $TreinosTable> {
  $$TreinosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get iniciadoEm => $composableBuilder(
    column: $table.iniciadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finalizadoEm => $composableBuilder(
    column: $table.finalizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modo => $composableBuilder(
    column: $table.modo,
    builder: (column) => ColumnFilters(column),
  );

  $$SessoesPlanoTableFilterComposer get sessaoPlanoId {
    final $$SessoesPlanoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessaoPlanoId,
      referencedTable: $db.sessoesPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessoesPlanoTableFilterComposer(
            $db: $db,
            $table: $db.sessoesPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> seriesRefs(
    Expression<bool> Function($$SeriesTableFilterComposer f) f,
  ) {
    final $$SeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.treinoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableFilterComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TreinosTableOrderingComposer
    extends Composer<_$AppDatabase, $TreinosTable> {
  $$TreinosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get iniciadoEm => $composableBuilder(
    column: $table.iniciadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finalizadoEm => $composableBuilder(
    column: $table.finalizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modo => $composableBuilder(
    column: $table.modo,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessoesPlanoTableOrderingComposer get sessaoPlanoId {
    final $$SessoesPlanoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessaoPlanoId,
      referencedTable: $db.sessoesPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessoesPlanoTableOrderingComposer(
            $db: $db,
            $table: $db.sessoesPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TreinosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreinosTable> {
  $$TreinosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get iniciadoEm => $composableBuilder(
    column: $table.iniciadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get finalizadoEm => $composableBuilder(
    column: $table.finalizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get modo =>
      $composableBuilder(column: $table.modo, builder: (column) => column);

  $$SessoesPlanoTableAnnotationComposer get sessaoPlanoId {
    final $$SessoesPlanoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessaoPlanoId,
      referencedTable: $db.sessoesPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessoesPlanoTableAnnotationComposer(
            $db: $db,
            $table: $db.sessoesPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> seriesRefs<T extends Object>(
    Expression<T> Function($$SeriesTableAnnotationComposer a) f,
  ) {
    final $$SeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.treinoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TreinosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TreinosTable,
          Treino,
          $$TreinosTableFilterComposer,
          $$TreinosTableOrderingComposer,
          $$TreinosTableAnnotationComposer,
          $$TreinosTableCreateCompanionBuilder,
          $$TreinosTableUpdateCompanionBuilder,
          (Treino, $$TreinosTableReferences),
          Treino,
          PrefetchHooks Function({bool sessaoPlanoId, bool seriesRefs})
        > {
  $$TreinosTableTableManager(_$AppDatabase db, $TreinosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreinosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreinosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreinosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> usuarioId = const Value.absent(),
                Value<String> sessaoPlanoId = const Value.absent(),
                Value<DateTime> iniciadoEm = const Value.absent(),
                Value<DateTime?> finalizadoEm = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> modo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TreinosCompanion(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                usuarioId: usuarioId,
                sessaoPlanoId: sessaoPlanoId,
                iniciadoEm: iniciadoEm,
                finalizadoEm: finalizadoEm,
                status: status,
                modo: modo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                required String id,
                Value<String?> usuarioId = const Value.absent(),
                required String sessaoPlanoId,
                required DateTime iniciadoEm,
                Value<DateTime?> finalizadoEm = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> modo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TreinosCompanion.insert(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                usuarioId: usuarioId,
                sessaoPlanoId: sessaoPlanoId,
                iniciadoEm: iniciadoEm,
                finalizadoEm: finalizadoEm,
                status: status,
                modo: modo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TreinosTable, Treino>(table),
                  $$TreinosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessaoPlanoId = false, seriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (seriesRefs) db.series],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessaoPlanoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessaoPlanoId,
                        referencedTable: $$TreinosTableReferences
                            ._sessaoPlanoIdTable(db),
                        referencedColumn: $$TreinosTableReferences
                            ._sessaoPlanoIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (seriesRefs)
                    await $_getPrefetchedData<Treino, $TreinosTable, Serie>(
                      currentTable: table,
                      referencedTable: $$TreinosTableReferences
                          ._seriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TreinosTableReferences(db, table, p0).seriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.treinoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TreinosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TreinosTable,
      Treino,
      $$TreinosTableFilterComposer,
      $$TreinosTableOrderingComposer,
      $$TreinosTableAnnotationComposer,
      $$TreinosTableCreateCompanionBuilder,
      $$TreinosTableUpdateCompanionBuilder,
      (Treino, $$TreinosTableReferences),
      Treino,
      PrefetchHooks Function({bool sessaoPlanoId, bool seriesRefs})
    >;
typedef $$SeriesTableCreateCompanionBuilder = SeriesCompanion Function({
  Value<DateTime> atualizadoEm,
  Value<DateTime?> excluidoEm,
  Value<DateTime?> sincronizadoEm,
  required String id,
  required String treinoId,
  Value<String?> itemPlanoId,
  required String exercicioId,
  required int numero,
  Value<double?> cargaPlanKg,
  Value<int?> repsPlan,
  Value<double?> cargaKg,
  Value<int?> reps,
  Value<int?> rir,
  Value<bool> confirmado,
  Value<bool> editado,
  Value<bool> dor,
  required DateTime registradaEm,
  Value<int> rowid,
});
typedef $$SeriesTableUpdateCompanionBuilder = SeriesCompanion Function({
  Value<DateTime> atualizadoEm,
  Value<DateTime?> excluidoEm,
  Value<DateTime?> sincronizadoEm,
  Value<String> id,
  Value<String> treinoId,
  Value<String?> itemPlanoId,
  Value<String> exercicioId,
  Value<int> numero,
  Value<double?> cargaPlanKg,
  Value<int?> repsPlan,
  Value<double?> cargaKg,
  Value<int?> reps,
  Value<int?> rir,
  Value<bool> confirmado,
  Value<bool> editado,
  Value<bool> dor,
  Value<DateTime> registradaEm,
  Value<int> rowid,
});

final class $$SeriesTableReferences
    extends BaseReferences<_$AppDatabase, $SeriesTable, Serie> {
  $$SeriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TreinosTable _treinoIdTable(_$AppDatabase db) =>
      db.treinos.createAlias('series__treino_id__treinos__id');

  $$TreinosTableProcessedTableManager get treinoId {
    final $_column = $_itemColumn<String>('treino_id')!;

    final manager = $$TreinosTableTableManager(
      $_db,
      $_db.treinos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_treinoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItensPlanoTable _itemPlanoIdTable(_$AppDatabase db) =>
      db.itensPlano.createAlias('series__item_plano_id__itens_plano__id');

  $$ItensPlanoTableProcessedTableManager? get itemPlanoId {
    final $_column = $_itemColumn<String>('item_plano_id');
    if ($_column == null) return null;
    final manager = $$ItensPlanoTableTableManager(
      $_db,
      $_db.itensPlano,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemPlanoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExerciciosTable _exercicioIdTable(_$AppDatabase db) =>
      db.exercicios.createAlias('series__exercicio_id__exercicios__id');

  $$ExerciciosTableProcessedTableManager get exercicioId {
    final $_column = $_itemColumn<String>('exercicio_id')!;

    final manager = $$ExerciciosTableTableManager(
      $_db,
      $_db.exercicios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exercicioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SeriesTableFilterComposer
    extends Composer<_$AppDatabase, $SeriesTable> {
  $$SeriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cargaPlanKg => $composableBuilder(
    column: $table.cargaPlanKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsPlan => $composableBuilder(
    column: $table.repsPlan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cargaKg => $composableBuilder(
    column: $table.cargaKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get confirmado => $composableBuilder(
    column: $table.confirmado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get editado => $composableBuilder(
    column: $table.editado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dor => $composableBuilder(
    column: $table.dor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registradaEm => $composableBuilder(
    column: $table.registradaEm,
    builder: (column) => ColumnFilters(column),
  );

  $$TreinosTableFilterComposer get treinoId {
    final $$TreinosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.treinoId,
      referencedTable: $db.treinos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TreinosTableFilterComposer(
            $db: $db,
            $table: $db.treinos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItensPlanoTableFilterComposer get itemPlanoId {
    final $$ItensPlanoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemPlanoId,
      referencedTable: $db.itensPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensPlanoTableFilterComposer(
            $db: $db,
            $table: $db.itensPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableFilterComposer get exercicioId {
    final $$ExerciciosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableFilterComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SeriesTable> {
  $$SeriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cargaPlanKg => $composableBuilder(
    column: $table.cargaPlanKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsPlan => $composableBuilder(
    column: $table.repsPlan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cargaKg => $composableBuilder(
    column: $table.cargaKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get confirmado => $composableBuilder(
    column: $table.confirmado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get editado => $composableBuilder(
    column: $table.editado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dor => $composableBuilder(
    column: $table.dor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registradaEm => $composableBuilder(
    column: $table.registradaEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$TreinosTableOrderingComposer get treinoId {
    final $$TreinosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.treinoId,
      referencedTable: $db.treinos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TreinosTableOrderingComposer(
            $db: $db,
            $table: $db.treinos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItensPlanoTableOrderingComposer get itemPlanoId {
    final $$ItensPlanoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemPlanoId,
      referencedTable: $db.itensPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensPlanoTableOrderingComposer(
            $db: $db,
            $table: $db.itensPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableOrderingComposer get exercicioId {
    final $$ExerciciosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableOrderingComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeriesTable> {
  $$SeriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<double> get cargaPlanKg => $composableBuilder(
    column: $table.cargaPlanKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repsPlan =>
      $composableBuilder(column: $table.repsPlan, builder: (column) => column);

  GeneratedColumn<double> get cargaKg =>
      $composableBuilder(column: $table.cargaKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => column);

  GeneratedColumn<bool> get confirmado => $composableBuilder(
    column: $table.confirmado,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get editado =>
      $composableBuilder(column: $table.editado, builder: (column) => column);

  GeneratedColumn<bool> get dor =>
      $composableBuilder(column: $table.dor, builder: (column) => column);

  GeneratedColumn<DateTime> get registradaEm => $composableBuilder(
    column: $table.registradaEm,
    builder: (column) => column,
  );

  $$TreinosTableAnnotationComposer get treinoId {
    final $$TreinosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.treinoId,
      referencedTable: $db.treinos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TreinosTableAnnotationComposer(
            $db: $db,
            $table: $db.treinos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItensPlanoTableAnnotationComposer get itemPlanoId {
    final $$ItensPlanoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemPlanoId,
      referencedTable: $db.itensPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensPlanoTableAnnotationComposer(
            $db: $db,
            $table: $db.itensPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableAnnotationComposer get exercicioId {
    final $$ExerciciosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableAnnotationComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeriesTable,
          Serie,
          $$SeriesTableFilterComposer,
          $$SeriesTableOrderingComposer,
          $$SeriesTableAnnotationComposer,
          $$SeriesTableCreateCompanionBuilder,
          $$SeriesTableUpdateCompanionBuilder,
          (Serie, $$SeriesTableReferences),
          Serie,
          PrefetchHooks Function({
            bool treinoId,
            bool itemPlanoId,
            bool exercicioId,
          })
        > {
  $$SeriesTableTableManager(_$AppDatabase db, $SeriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> treinoId = const Value.absent(),
                Value<String?> itemPlanoId = const Value.absent(),
                Value<String> exercicioId = const Value.absent(),
                Value<int> numero = const Value.absent(),
                Value<double?> cargaPlanKg = const Value.absent(),
                Value<int?> repsPlan = const Value.absent(),
                Value<double?> cargaKg = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> rir = const Value.absent(),
                Value<bool> confirmado = const Value.absent(),
                Value<bool> editado = const Value.absent(),
                Value<bool> dor = const Value.absent(),
                Value<DateTime> registradaEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SeriesCompanion(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                treinoId: treinoId,
                itemPlanoId: itemPlanoId,
                exercicioId: exercicioId,
                numero: numero,
                cargaPlanKg: cargaPlanKg,
                repsPlan: repsPlan,
                cargaKg: cargaKg,
                reps: reps,
                rir: rir,
                confirmado: confirmado,
                editado: editado,
                dor: dor,
                registradaEm: registradaEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                required String id,
                required String treinoId,
                Value<String?> itemPlanoId = const Value.absent(),
                required String exercicioId,
                required int numero,
                Value<double?> cargaPlanKg = const Value.absent(),
                Value<int?> repsPlan = const Value.absent(),
                Value<double?> cargaKg = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> rir = const Value.absent(),
                Value<bool> confirmado = const Value.absent(),
                Value<bool> editado = const Value.absent(),
                Value<bool> dor = const Value.absent(),
                required DateTime registradaEm,
                Value<int> rowid = const Value.absent(),
              }) => SeriesCompanion.insert(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                treinoId: treinoId,
                itemPlanoId: itemPlanoId,
                exercicioId: exercicioId,
                numero: numero,
                cargaPlanKg: cargaPlanKg,
                repsPlan: repsPlan,
                cargaKg: cargaKg,
                reps: reps,
                rir: rir,
                confirmado: confirmado,
                editado: editado,
                dor: dor,
                registradaEm: registradaEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SeriesTable, Serie>(table),
                  $$SeriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({treinoId = false, itemPlanoId = false, exercicioId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (treinoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.treinoId,
                            referencedTable: $$SeriesTableReferences
                                ._treinoIdTable(db),
                            referencedColumn: $$SeriesTableReferences
                                ._treinoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (itemPlanoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.itemPlanoId,
                            referencedTable: $$SeriesTableReferences
                                ._itemPlanoIdTable(db),
                            referencedColumn: $$SeriesTableReferences
                                ._itemPlanoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exercicioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exercicioId,
                            referencedTable: $$SeriesTableReferences
                                ._exercicioIdTable(db),
                            referencedColumn: $$SeriesTableReferences
                                ._exercicioIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$SeriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeriesTable,
      Serie,
      $$SeriesTableFilterComposer,
      $$SeriesTableOrderingComposer,
      $$SeriesTableAnnotationComposer,
      $$SeriesTableCreateCompanionBuilder,
      $$SeriesTableUpdateCompanionBuilder,
      (Serie, $$SeriesTableReferences),
      Serie,
      PrefetchHooks Function({
        bool treinoId,
        bool itemPlanoId,
        bool exercicioId,
      })
    >;
typedef $$SubstituicoesTableCreateCompanionBuilder =
    SubstituicoesCompanion Function({
      Value<DateTime> atualizadoEm,
      Value<DateTime?> excluidoEm,
      Value<DateTime?> sincronizadoEm,
      required String id,
      Value<String?> usuarioId,
      required String itemPlanoId,
      required String exercicioOriginalId,
      required String exercicioNovoId,
      required String escopo,
      Value<int> rowid,
    });
typedef $$SubstituicoesTableUpdateCompanionBuilder =
    SubstituicoesCompanion Function({
      Value<DateTime> atualizadoEm,
      Value<DateTime?> excluidoEm,
      Value<DateTime?> sincronizadoEm,
      Value<String> id,
      Value<String?> usuarioId,
      Value<String> itemPlanoId,
      Value<String> exercicioOriginalId,
      Value<String> exercicioNovoId,
      Value<String> escopo,
      Value<int> rowid,
    });

final class $$SubstituicoesTableReferences
    extends BaseReferences<_$AppDatabase, $SubstituicoesTable, Substituicao> {
  $$SubstituicoesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ItensPlanoTable _itemPlanoIdTable(_$AppDatabase db) => db.itensPlano
      .createAlias('substituicoes__item_plano_id__itens_plano__id');

  $$ItensPlanoTableProcessedTableManager get itemPlanoId {
    final $_column = $_itemColumn<String>('item_plano_id')!;

    final manager = $$ItensPlanoTableTableManager(
      $_db,
      $_db.itensPlano,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemPlanoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExerciciosTable _exercicioOriginalIdTable(_$AppDatabase db) => db
      .exercicios
      .createAlias('substituicoes__exercicio_original_id__exercicios__id');

  $$ExerciciosTableProcessedTableManager get exercicioOriginalId {
    final $_column = $_itemColumn<String>('exercicio_original_id')!;

    final manager = $$ExerciciosTableTableManager(
      $_db,
      $_db.exercicios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exercicioOriginalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExerciciosTable _exercicioNovoIdTable(_$AppDatabase db) => db
      .exercicios
      .createAlias('substituicoes__exercicio_novo_id__exercicios__id');

  $$ExerciciosTableProcessedTableManager get exercicioNovoId {
    final $_column = $_itemColumn<String>('exercicio_novo_id')!;

    final manager = $$ExerciciosTableTableManager(
      $_db,
      $_db.exercicios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exercicioNovoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubstituicoesTableFilterComposer
    extends Composer<_$AppDatabase, $SubstituicoesTable> {
  $$SubstituicoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get escopo => $composableBuilder(
    column: $table.escopo,
    builder: (column) => ColumnFilters(column),
  );

  $$ItensPlanoTableFilterComposer get itemPlanoId {
    final $$ItensPlanoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemPlanoId,
      referencedTable: $db.itensPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensPlanoTableFilterComposer(
            $db: $db,
            $table: $db.itensPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableFilterComposer get exercicioOriginalId {
    final $$ExerciciosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioOriginalId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableFilterComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableFilterComposer get exercicioNovoId {
    final $$ExerciciosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioNovoId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableFilterComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubstituicoesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubstituicoesTable> {
  $$SubstituicoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get escopo => $composableBuilder(
    column: $table.escopo,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItensPlanoTableOrderingComposer get itemPlanoId {
    final $$ItensPlanoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemPlanoId,
      referencedTable: $db.itensPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensPlanoTableOrderingComposer(
            $db: $db,
            $table: $db.itensPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableOrderingComposer get exercicioOriginalId {
    final $$ExerciciosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioOriginalId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableOrderingComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableOrderingComposer get exercicioNovoId {
    final $$ExerciciosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioNovoId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableOrderingComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubstituicoesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubstituicoesTable> {
  $$SubstituicoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get excluidoEm => $composableBuilder(
    column: $table.excluidoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sincronizadoEm => $composableBuilder(
    column: $table.sincronizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get escopo =>
      $composableBuilder(column: $table.escopo, builder: (column) => column);

  $$ItensPlanoTableAnnotationComposer get itemPlanoId {
    final $$ItensPlanoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemPlanoId,
      referencedTable: $db.itensPlano,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensPlanoTableAnnotationComposer(
            $db: $db,
            $table: $db.itensPlano,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableAnnotationComposer get exercicioOriginalId {
    final $$ExerciciosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioOriginalId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableAnnotationComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciciosTableAnnotationComposer get exercicioNovoId {
    final $$ExerciciosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exercicioNovoId,
      referencedTable: $db.exercicios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciciosTableAnnotationComposer(
            $db: $db,
            $table: $db.exercicios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubstituicoesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubstituicoesTable,
          Substituicao,
          $$SubstituicoesTableFilterComposer,
          $$SubstituicoesTableOrderingComposer,
          $$SubstituicoesTableAnnotationComposer,
          $$SubstituicoesTableCreateCompanionBuilder,
          $$SubstituicoesTableUpdateCompanionBuilder,
          (Substituicao, $$SubstituicoesTableReferences),
          Substituicao,
          PrefetchHooks Function({
            bool itemPlanoId,
            bool exercicioOriginalId,
            bool exercicioNovoId,
          })
        > {
  $$SubstituicoesTableTableManager(_$AppDatabase db, $SubstituicoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubstituicoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubstituicoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubstituicoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> usuarioId = const Value.absent(),
                Value<String> itemPlanoId = const Value.absent(),
                Value<String> exercicioOriginalId = const Value.absent(),
                Value<String> exercicioNovoId = const Value.absent(),
                Value<String> escopo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubstituicoesCompanion(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                usuarioId: usuarioId,
                itemPlanoId: itemPlanoId,
                exercicioOriginalId: exercicioOriginalId,
                exercicioNovoId: exercicioNovoId,
                escopo: escopo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> excluidoEm = const Value.absent(),
                Value<DateTime?> sincronizadoEm = const Value.absent(),
                required String id,
                Value<String?> usuarioId = const Value.absent(),
                required String itemPlanoId,
                required String exercicioOriginalId,
                required String exercicioNovoId,
                required String escopo,
                Value<int> rowid = const Value.absent(),
              }) => SubstituicoesCompanion.insert(
                atualizadoEm: atualizadoEm,
                excluidoEm: excluidoEm,
                sincronizadoEm: sincronizadoEm,
                id: id,
                usuarioId: usuarioId,
                itemPlanoId: itemPlanoId,
                exercicioOriginalId: exercicioOriginalId,
                exercicioNovoId: exercicioNovoId,
                escopo: escopo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubstituicoesTable, Substituicao>(table),
                  $$SubstituicoesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                itemPlanoId = false,
                exercicioOriginalId = false,
                exercicioNovoId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (itemPlanoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.itemPlanoId,
                            referencedTable: $$SubstituicoesTableReferences
                                ._itemPlanoIdTable(db),
                            referencedColumn: $$SubstituicoesTableReferences
                                ._itemPlanoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exercicioOriginalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exercicioOriginalId,
                            referencedTable: $$SubstituicoesTableReferences
                                ._exercicioOriginalIdTable(db),
                            referencedColumn: $$SubstituicoesTableReferences
                                ._exercicioOriginalIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exercicioNovoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exercicioNovoId,
                            referencedTable: $$SubstituicoesTableReferences
                                ._exercicioNovoIdTable(db),
                            referencedColumn: $$SubstituicoesTableReferences
                                ._exercicioNovoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$SubstituicoesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubstituicoesTable,
      Substituicao,
      $$SubstituicoesTableFilterComposer,
      $$SubstituicoesTableOrderingComposer,
      $$SubstituicoesTableAnnotationComposer,
      $$SubstituicoesTableCreateCompanionBuilder,
      $$SubstituicoesTableUpdateCompanionBuilder,
      (Substituicao, $$SubstituicoesTableReferences),
      Substituicao,
      PrefetchHooks Function({
        bool itemPlanoId,
        bool exercicioOriginalId,
        bool exercicioNovoId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExerciciosTableTableManager get exercicios =>
      $$ExerciciosTableTableManager(_db, _db.exercicios);
  $$PlanosTreinoTableTableManager get planosTreino =>
      $$PlanosTreinoTableTableManager(_db, _db.planosTreino);
  $$SessoesPlanoTableTableManager get sessoesPlano =>
      $$SessoesPlanoTableTableManager(_db, _db.sessoesPlano);
  $$ItensPlanoTableTableManager get itensPlano =>
      $$ItensPlanoTableTableManager(_db, _db.itensPlano);
  $$TreinosTableTableManager get treinos =>
      $$TreinosTableTableManager(_db, _db.treinos);
  $$SeriesTableTableManager get series =>
      $$SeriesTableTableManager(_db, _db.series);
  $$SubstituicoesTableTableManager get substituicoes =>
      $$SubstituicoesTableTableManager(_db, _db.substituicoes);
}
