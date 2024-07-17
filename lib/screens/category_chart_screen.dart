// category_chart_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryChartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recentTransactions;

  CategoryChartScreen({required this.recentTransactions});

  Map<String, double> _calculateCategoryTotals() {
    Map<String, double> categoryTotals = {};
    for (var transaction in recentTransactions) {
      if (transaction['type'] == 'expense') {
        String category = transaction['category'] ?? 'Uncategorized';
        if (categoryTotals.containsKey(category)) {
          categoryTotals[category] = categoryTotals[category]! + transaction['amount'];
        } else {
          categoryTotals[category] = transaction['amount'];
        }
      }
    }
    return categoryTotals;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryTotals = _calculateCategoryTotals();
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses by Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: categoryTotals.isEmpty
            ? Center(child: Text('No expenses to show'))
            : PieChart(
          PieChartData(
            sections: categoryTotals.entries.map((entry) {
              return PieChartSectionData(
                color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
                value: entry.value,
                title: '${entry.key}: \$${entry.value.toStringAsFixed(2)}',
                radius: 50,
                titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
