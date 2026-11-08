import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Nível de evidência do "Por que este exercício".
enum NivelEvidencia {
  alto('Alta', 'meta-análise ou revisão sistemática'),
  moderado('Moderada', 'ensaio controlado com medida de massa ou força'),
  baixo('Baixa', 'ativação muscular, revisão narrativa ou prática comum');

  const NivelEvidencia(this.rotulo, this.explicacao);

  final String rotulo;
  final String explicacao;

  static NivelEvidencia de(String valor) => switch (valor) {
    'alto' => alto,
    'moderado' => moderado,
    _ => baixo,
  };
}

/// Por que um padrão de movimento está no plano, com a fonte.
class Justificativa {
  const Justificativa({
    required this.texto,
    required this.fonte,
    required this.nivel,
    required this.revisado,
  });

  factory Justificativa.deJson(Map<String, Object?> json) => Justificativa(
    texto: json['texto']! as String,
    fonte: json['fonte']! as String,
    nivel: NivelEvidencia.de(json['nivel']! as String),
    revisado: json['revisado'] as bool? ?? false,
  );

  final String texto;
  final String fonte;
  final NivelEvidencia nivel;

  /// Falso enquanto a pessoa não conferiu a fonte.
  final bool revisado;
}

/// Lê o JSON de justificativas (padrão de movimento → texto). Chaves que
/// começam com `_` são notas, não padrões.
Map<String, Justificativa> lerJustificativas(String conteudo) {
  final json = jsonDecode(conteudo) as Map<String, Object?>;
  return {
    for (final MapEntry(:key, :value) in json.entries)
      if (!key.startsWith('_'))
        key: Justificativa.deJson(value! as Map<String, Object?>),
  };
}

const arquivoJustificativas = 'assets/seed/justificativas.json';

final justificativasProvider = FutureProvider<Map<String, Justificativa>>(
  (ref) async =>
      lerJustificativas(await rootBundle.loadString(arquivoJustificativas)),
);
