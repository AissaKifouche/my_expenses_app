import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart'; // Adjust import path as needed

class SixMonthExpenseChart extends StatelessWidget {
  final List<MonthlyExpense> expenses;
  final AppData appData; // 1. Added AppData dependency

  const SixMonthExpenseChart({
    super.key,
    required this.expenses,
    required this.appData,
  });

  static const _teal = Color(0xFF058E84);
  static const _darkGreen = Color(0xFF002017);
  static const _mintAccent = Color(0xFF00E4B2);

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return SizedBox(
        height: 180.h,
        child: const Center(child: Text("No expense data available")),
      );
    }

    // Determine max y-axis ceiling dynamically
    final maxAmount = expenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    final maxY = maxAmount == 0 ? 100.0 : maxAmount * 1.2;

    return AspectRatio(
      aspectRatio: 1.7,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => _darkGreen,
                tooltipMargin: 8.h,
                tooltipPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                tooltipBorderRadius: BorderRadius.circular(8.r),
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    final monthName = _monthNames[expenses[index].month - 1];

                    // 2. Used dynamic appData currency symbol in tooltip
                    return LineTooltipItem(
                      '$monthName\n${appData.currency.symbol}${spot.y.toStringAsFixed(2)}',
                      TextStyle(
                        color: _mintAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    );
                  }).toList();
                },
              ),
              getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    const FlLine(
                      color: _teal,
                      strokeWidth: 2,
                      dashArray: [4, 4],
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: _teal,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  );
                }).toList();
              },
            ),

            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxY / 4,
              getDrawingHorizontalLine: (value) => const FlLine(
                color: Color(0xFFF0F0F0),
                strokeWidth: 1,
              ),
            ),

            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42.w,
                  getTitlesWidget: (value, meta) {
                    // 3. Used dynamic appData currency symbol on Y-Axis
                    return Text(
                      '${appData.currency.symbol}${value.toInt()}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < expenses.length) {
                      final monthIndex = expenses[index].month - 1;
                      return Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          _monthNames[monthIndex],
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),

            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (expenses.length - 1).toDouble(),
            minY: 0,
            maxY: maxY,

            lineBarsData: [
              LineChartBarData(
                spots: expenses.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.amount);
                }).toList(),
                isCurved: true,
                curveSmoothness: 0.35,
                color: _teal,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2.5,
                      strokeColor: _teal,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _teal.withValues(alpha: 0.25),
                      _teal.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}