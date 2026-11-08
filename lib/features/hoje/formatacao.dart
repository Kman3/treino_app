import '../../core/db/app_database.dart';

/// 62.5 → "62,5"; 60.0 → "60".
String formatarKg(double kg) {
  final texto = kg == kg.roundToDouble()
      ? kg.toStringAsFixed(0)
      : kg.toStringAsFixed(1);
  return texto.replaceAll('.', ',');
}

/// "4 × 6–10", ou "3 × 30–45 s" para exercícios por tempo.
String formatarPrescricao(ItemPlano item, Exercicio exercicio) {
  final faixa = item.repsMin == item.repsMax
      ? '${item.repsMin}'
      : '${item.repsMin}–${item.repsMax}';
  final unidade = exercicio.tipoCarga == TipoCarga.tempo ? ' s' : '';
  return '${item.series} × $faixa$unidade';
}
