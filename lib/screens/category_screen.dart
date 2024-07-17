// category_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryScreen extends StatefulWidget {
  final List<String> categories;
  final Function(List<String>) onUpdateCategories;
  final List<Map<String, dynamic>> recentTransactions;

  CategoryScreen({required this.categories, required this.onUpdateCategories, required this.recentTransactions});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _categoryController = TextEditingController();
  late List<String> categories;
  late Map<String, double> categoryTotals;

  @override
  void initState() {
    super.initState();
    categories = List.from(widget.categories);
    _calculateCategoryTotals();
  }

  void _calculateCategoryTotals() {
    categoryTotals = {};
    for (var transaction in widget.recentTransactions) {
      if (transaction['type'] == 'expense') {
        String category = transaction['category'] ?? 'Uncategorized';
        if (categoryTotals.containsKey(category)) {
          categoryTotals[category] = categoryTotals[category]! + transaction['amount'];
        } else {
          categoryTotals[category] = transaction['amount'];
        }
      }
    }
  }

  void _addCategory() {
    if (_categoryController.text.isNotEmpty) {
      setState(() {
        categories.add(_categoryController.text);
        _categoryController.clear();
      });
      widget.onUpdateCategories(categories);
    }
  }

  void _removeCategory(String category) {
    setState(() {
      categories.remove(category);
    });
    widget.onUpdateCategories(categories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'New Category'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addCategory,
              child: Text('Add Category'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(categories[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeCategory(categories[index]),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Expenses by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: categoryTotals.isEmpty
                  ? Center(child: Text('No expenses to show'))
                  : PieChart(
                PieChartData(
                  sections: categoryTotals.entries.map((entry) {
                    return PieChartSectionData(
                      color: Colors.primaries[categories.indexOf(entry.key) % Colors.primaries.length],
                      value: entry.value,
                      title: '${entry.key}: \$${entry.value.toStringAsFixed(2)}',
                      radius: 50,
                      titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


