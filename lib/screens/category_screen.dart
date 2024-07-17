// category_screen.dart
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    categories = List.from(widget.categories);
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
          ],
        ),
      ),
    );
  }
}



