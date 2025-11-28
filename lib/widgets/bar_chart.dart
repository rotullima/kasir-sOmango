import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_textStyles.dart';

class AppBarChart extends StatelessWidget {
  final List<dynamic> data;
  const AppBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 20,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.toY.toString(),
                  AppTextStyles.chartText.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                getTitlesWidget: (value, meta) {
                  final names = data.map((e) => e.name).toList();
                  return SizedBox(
                    width: 55,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        names[value.toInt()],
                        style: AppTextStyles.chartText.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(
            data.length,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[i].total,
                  color: AppColors.textSecondary,
                  width: 16,
                  borderRadius: BorderRadius.circular(AppSizes.cardSmallRadius),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
