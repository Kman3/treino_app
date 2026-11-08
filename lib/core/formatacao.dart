import 'db/app_database.dart';

/// 62.5 → "62,5"; 60.0 → "60".
String formatarKg(double kg) {
  final texto = kg == kg.roundToDouble()
      ? kg.toStringAsFixed(0)
      : kg.toStringAsFixed(1);
  return texto.replaceAll('.', ',');
}

/// Volume em kg, inteiro e com separador de milhar: 12450.0 → "12.450".
String formatarVolume(double kg) {
  final digitos = kg.round().toString();
  final grupos = <String>[];
  for (var fim = digitos.length; fim > 0; fim -= 3) {
    grupos.insert(0, digitos.substring(fim - 3 < 0 ? 0 : fim - 3, fim));
  }
  return grupos.join('.');
}

/// "08/11".
String formatarData(DateTime data) =>
    '${data.day.toString().padLeft(2, '0')}/'
    '${data.month.toString().padLeft(2, '0')}';

/// 0.5 → "50%".
String formatarPercentual(double fracao) => '${(fracao * 100).round()}%';

/// Lê "62,5" ou "62.5". Devolve nulo se não for um número.
double? lerNumero(String texto) =>
    double.tryParse(texto.trim().replaceAll(',', '.'));

/// "+2,5" / "−1" / "" para a diferença entre o real e o plano.
String formatarDiferenca(num diferenca) {
  if (diferenca == 0) return '';
  final valor = formatarKg(diferenca.abs().toDouble());
  return diferenca > 0 ? '+$valor' : '−$valor';
}

/// "1 h 05 min" ou "42 min".
String formatarDuracao(Duration duracao) {
  final minutos = duracao.inMinutes;
  if (minutos < 60) return '$minutos min';
  return '${minutos ~/ 60} h ${(minutos % 60).toString().padLeft(2, '0')} min';
}

/// "4 × 6–10", ou "3 × 30–45 s" para exercícios por tempo.
String formatarPrescricao(ItemPlano item, Exercicio exercicio) {
  final faixa = item.repsMin == item.repsMax
      ? '${item.repsMin}'
      : '${item.repsMin}–${item.repsMax}';
  final unidade = exercicio.tipoCarga == TipoCarga.tempo ? ' s' : '';
  return '${item.series} × $faixa$unidade';
}
