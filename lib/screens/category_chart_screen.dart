import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryChartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recentTransactions;

  CategoryChartScreen({required this.recentTransactions});

  List<ExpenseData> _generateData() {
    Map<String, double> categoryTotals = {};

    for (var transaction in recentTransactions) {
      if (transaction['type'] == 'expense') {
        String category = transaction['category'] ?? 'Uncategorized';
        double amount = transaction['amount'];

        if (categoryTotals.containsKey(category)) {
          categoryTotals[category] = categoryTotals[category]! + amount;
        } else {
          categoryTotals[category] = amount;
        }
      }
    }

    return categoryTotals.entries
        .map((entry) => ExpenseData(category: entry.key, amount: entry.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Chart'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Expenses by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: 400, // Adjust the height as needed
              child: SfCircularChart(
                legend: Legend(isVisible: true),
                series: <CircularSeries>[
                  PieSeries<ExpenseData, String>(
                    dataSource: _generateData(),
                    xValueMapper: (ExpenseData data, _) => data.category,
                    yValueMapper: (ExpenseData data, _) => data.amount,
                    dataLabelMapper: (ExpenseData data, _) => '${data.category}: \$${data.amount.toStringAsFixed(2)}',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseData {
  final String category;
  final double amount;

  ExpenseData({required this.category, required this.amount});
}


