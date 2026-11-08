import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/db/repositorios/evolucao_repository.dart';
import '../../core/formatacao.dart';
import '../../core/theme/tokens.dart';

/// Valor de um ponto com a unidade da métrica: "82,5 kg", "12 reps", "45 s".
String formatarValorEvolucao(double valor, MetricaEvolucao metrica) =>
    switch (metrica) {
      MetricaEvolucao.umRm => '${formatarUmRm(valor)} kg',
      MetricaEvolucao.reps => '${valor.round()} reps',
      MetricaEvolucao.segundos => '${valor.round()} s',
    };

/// Linha da evolução nas últimas [semanas] semanas: um ponto por treino, os
/// recordes em Avanço.
class GraficoEvolucao extends StatelessWidget {
  const GraficoEvolucao({
    super.key,
    required this.pontos,
    required this.metrica,
    required this.agora,
    this.semanas = 8,
  });

  final List<PontoEvolucao> pontos;
  final MetricaEvolucao metrica;
  final DateTime agora;
  final int semanas;

  DateTime get _inicio => agora.subtract(Duration(days: 7 * semanas));

  double _x(DateTime data) => data.difference(_inicio).inHours / 24;

  String get _descricao {
    if (pontos.isEmpty) return 'Sem treinos nas últimas $semanas semanas.';
    final primeiro = pontos.first;
    final ultimo = pontos.last;
    final recordes = pontos
        .where((p) => p.recorde)
        .map((p) => formatarData(p.data));
    return 'Últimas $semanas semanas: de '
        '${formatarValorEvolucao(primeiro.valor, metrica)} em '
        '${formatarData(primeiro.data)} para '
        '${formatarValorEvolucao(ultimo.valor, metrica)} em '
        '${formatarData(ultimo.data)}'
        '${recordes.isEmpty ? '' : '; recorde em ${recordes.join(', ')}'}.';
  }

  @override
  Widget build(BuildContext context) {
    final valores = pontos.map((p) => p.valor);
    final menor = valores.reduce(math.min);
    final maior = valores.reduce(math.max);
    final folga = math.max((maior - menor) * 0.15, maior * 0.05);
    final minY = math.max(0.0, menor - folga);
    final maxY = maior + folga;
    final totalDias = 7.0 * semanas;

    return Semantics(
      label: _descricao,
      excludeSemantics: true,
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: totalDias,
            minY: minY,
            maxY: maxY,
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: _intervalo(minY, maxY),
              getDrawingHorizontalLine: (_) =>
                  const FlLine(color: Cores.ferro700, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: _intervalo(minY, maxY),
                  getTitlesWidget: (valor, meta) => SideTitleWidget(
                    meta: meta,
                    child: Text(
                      valor.round().toString(),
                      style: Textos.rotulo.copyWith(fontSize: 10),
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: 14,
                  getTitlesWidget: (valor, meta) => SideTitleWidget(
                    meta: meta,
                    child: Text(
                      formatarData(_inicio.add(Duration(days: valor.round()))),
                      style: Textos.rotulo.copyWith(fontSize: 10),
                    ),
                  ),
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => Cores.ferro700,
                getTooltipItems: (tocados) => [
                  for (final t in tocados)
                    LineTooltipItem(
                      '${formatarValorEvolucao(t.y, metrica)}\n'
                      '${formatarData(pontos[t.spotIndex].data)}',
                      Textos.secundario.copyWith(color: Cores.giz),
                    ),
                ],
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [for (final p in pontos) FlSpot(_x(p.data), p.valor)],
                color: Cores.brasa,
                barWidth: 3,
                dotData: FlDotData(
                  getDotPainter: (_, _, _, indice) {
                    final recorde = pontos[indice].recorde;
                    return FlDotCirclePainter(
                      radius: recorde ? 6 : 4,
                      color: recorde ? Cores.avanco : Cores.brasa,
                      strokeWidth: 2,
                      strokeColor: Cores.ferro800,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Uns 3 ou 4 traços no eixo, em números redondos.
  static double _intervalo(double minY, double maxY) {
    final bruto = (maxY - minY) / 3;
    if (bruto <= 0) return 1;
    final ordem = math
        .pow(10, (math.log(bruto) / math.ln10).floor())
        .toDouble();
    for (final passo in [1, 2, 2.5, 5, 10]) {
      if (passo * ordem >= bruto) return passo * ordem;
    }
    return 10 * ordem;
  }
}
