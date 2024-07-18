import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final List<String> categories;
  final Function(List<String>) onUpdateCategories;
  final List<Map<String, dynamic>> recentTransactions;

  CategoryScreen({
    required this.categories,
    required this.onUpdateCategories,
    required this.recentTransactions,
  });

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();

  void _addCategory() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.categories.add(_categoryController.text);
        widget.onUpdateCategories(widget.categories);
        _categoryController.clear();
      });
    }
  }

  void _removeCategory(String category) {
    setState(() {
      widget.categories.remove(category);
      widget.onUpdateCategories(widget.categories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'New Category'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addCategory,
                    child: Text('Add Category'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...widget.categories.map((category) => ListTile(
              title: Text(category),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _removeCategory(category),
              ),
            )),
          ],
        ),
      ),
    );
  }
}





