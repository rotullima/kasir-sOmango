import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_colors.dart';
import '../constants/app_textStyles.dart';

class AppLineChart extends StatelessWidget {
  final List<dynamic> data;
  const AppLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final months = data.map((e) => e.month).toList();
                  return Text(
                    months[value.toInt()],
                    style: AppTextStyles.chartText.copyWith(color: AppColors.textSecondary),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 50,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: AppTextStyles.chartText.copyWith(color: AppColors.textSecondary),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: data.length - 1,
          minY: 0,
          maxY: 300,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (i) => FlSpot(i.toDouble(), data[i].total),
              ),
              isCurved: true,
              color: AppColors.textSecondary,
              barWidth: 3,
              dotData: FlDotData(show: true),
            )
          ],
        ),
      ),
    );
  }
}
