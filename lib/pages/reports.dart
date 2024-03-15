import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<Reports> {
  late List<Map<String, dynamic>> transactions;

  @override
  void initState() {
    super.initState();
    transactions = [];
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionsString = prefs.getString('transactions');
    if (transactionsString != null) {
      setState(() {
        transactions =
            List<Map<String, dynamic>>.from(json.decode(transactionsString));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: transactions.isNotEmpty
          ? Center(
              child: PieChart(
                PieChartData(
                  sections: _getSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            )
          : Center(child: Text('No data available')),
    );
  }

  List<PieChartSectionData> _getSections() {
    Map<String, double> categoryTotals = {};
    transactions.forEach((transaction) {
      String category = transaction['category'];
      double amount = double.parse(transaction['amount']);
      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + amount;
      } else {
        categoryTotals[category] = amount;
      }
    });

    List<PieChartSectionData> sections = [];
    var colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple
    ];
    int colorIndex = 0;

    categoryTotals.forEach((category, total) {
      final color = colors[colorIndex % colors.length];
      sections.add(
        PieChartSectionData(
          color: color,
          value: total,
          title:
              '${category.substring(0, 1).toUpperCase()}${category.substring(1)}: \$${total.toStringAsFixed(2)}',
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
          ),
        ),
      );
      colorIndex++;
    });

    return sections;
  }
}
