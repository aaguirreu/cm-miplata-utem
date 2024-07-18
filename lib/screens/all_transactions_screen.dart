import 'package:flutter/material.dart';

class AllTransactionsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(int, Map<String, dynamic>) onUpdateTransaction;
  final Function(int) onDeleteTransaction;

  AllTransactionsScreen({
    required this.transactions,
    required this.onUpdateTransaction,
    required this.onDeleteTransaction,
  });

  @override
  _AllTransactionsScreenState createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  String _selectedType = 'all';
  String? _selectedCategory;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _categories = widget.transactions
        .where((transaction) => transaction['type'] == 'expense')
        .map<String>((transaction) => transaction['category'] as String)
        .toSet()
        .toList();
    _categories.insert(0, 'All');
    _selectedCategory = 'All';
  }

  List<Map<String, dynamic>> _filterTransactions() {
    List<Map<String, dynamic>> filteredTransactions = widget.transactions;

    if (_selectedType != 'all') {
      filteredTransactions = filteredTransactions
          .where((transaction) => transaction['type'] == _selectedType)
          .toList();
    }

    if (_selectedType == 'expense' && _selectedCategory != 'All') {
      filteredTransactions = filteredTransactions
          .where((transaction) => transaction['category'] == _selectedCategory)
          .toList();
    }

    return filteredTransactions;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTransactions = _filterTransactions();

    return Scaffold(
      appBar: AppBar(
        title: Text('All Transactions'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (filteredTransactions.isEmpty)
              Center(child: Text('No transactions found')),
            ...filteredTransactions.map((transaction) {
              return ListTile(
                title: Text(transaction['title']),
                subtitle: Text(
                    '${transaction['date']} - ${transaction['category'] ?? ''}'),
                trailing: Text(
                  '\$${transaction['amount'].toStringAsFixed(2)}',
                  style: TextStyle(
                      color: transaction['type'] == 'income'
                          ? Colors.green
                          : Colors.red),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Transactions'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  items: [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'income', child: Text('Income')),
                    DropdownMenuItem(value: 'expense', child: Text('Expense')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                      if (_selectedType != 'expense') {
                        _selectedCategory = 'All';
                      }
                    });
                  },
                  decoration: InputDecoration(labelText: 'Type'),
                ),
                if (_selectedType == 'expense')
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: _categories
                        .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Category'),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedType = 'all';
                  _selectedCategory = 'All';
                });
                Navigator.of(context).pop();
              },
              child: Text('Clear Filters'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Apply Filters'),
            ),
          ],
        );
      },
    );
  }
}





