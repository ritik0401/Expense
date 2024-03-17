import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

BarChartGroupData makeGroupData(int x, double y, double width) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: Color.fromARGB(255, 8, 116, 158),
        width: width,
        borderRadius: BorderRadius.circular(6),
      ),
    ],
  );
}
