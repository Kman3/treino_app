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

/// Nome do equipamento do catálogo: "maquina" → "Máquina".
String nomeEquipamento(String equipamento) => switch (equipamento) {
  'barra' => 'Barra',
  'halteres' => 'Halteres',
  'maquina' => 'Máquina',
  'polia' => 'Polia',
  'barra-fixa' => 'Barra fixa',
  'nenhum' => 'Peso do corpo',
  _ => equipamento,
};

/// Nome do padrão de movimento do catálogo: "puxar-vertical" → "Puxar na
/// vertical".
String nomePadrao(String padrao) => switch (padrao) {
  'empurrar-horizontal' => 'Empurrar na horizontal',
  'empurrar-vertical' => 'Empurrar na vertical',
  'aducao-horizontal' => 'Adução horizontal do ombro',
  'abducao-ombro' => 'Abdução do ombro',
  'extensao-cotovelo' => 'Extensão do cotovelo',
  'flexao-cotovelo' => 'Flexão do cotovelo',
  'puxar-vertical' => 'Puxar na vertical',
  'puxar-horizontal' => 'Puxar na horizontal',
  'agachar' => 'Agachar',
  'extensao-joelho' => 'Extensão do joelho',
  'flexao-joelho' => 'Flexão do joelho',
  'dobrar-quadril' => 'Dobrar o quadril',
  'avanco' => 'Avanço',
  'flexao-plantar' => 'Flexão plantar',
  'anti-extensao' => 'Antiextensão do tronco',
  'flexao-tronco' => 'Flexão do tronco',
  _ => padrao,
};

/// 1RM estimado arredondado a meio quilo: 82.33 → "82,5".
String formatarUmRm(double kg) => formatarKg((kg * 2).round() / 2);

/// "4 × 6–10", ou "3 × 30–45 s" para exercícios por tempo.
String formatarPrescricao(ItemPlano item, Exercicio exercicio) {
  final faixa = item.repsMin == item.repsMax
      ? '${item.repsMin}'
      : '${item.repsMin}–${item.repsMax}';
  final unidade = exercicio.tipoCarga == TipoCarga.tempo ? ' s' : '';
  return '${item.series} × $faixa$unidade';
}
