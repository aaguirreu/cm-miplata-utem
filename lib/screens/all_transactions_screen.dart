// all_transactions_screen.dart
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
  List<Map<String, dynamic>> filteredTransactions = [];
  TextEditingController searchController = TextEditingController();
  String filterType = 'all';
  String filterCategory = 'all';

  @override
  void initState() {
    super.initState();
    filteredTransactions = widget.transactions;
    searchController.addListener(_filterTransactions);
  }

  void _filterTransactions() {
    setState(() {
      filteredTransactions = widget.transactions.where((transaction) {
        bool matchesSearch = transaction['title']
            .toLowerCase()
            .contains(searchController.text.toLowerCase()) ||
            transaction['category']
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
        bool matchesType = filterType == 'all' ||
            (filterType == 'income' && transaction['type'] == 'income') ||
            (filterType == 'expense' && transaction['type'] == 'expense');
        bool matchesCategory = filterCategory == 'all' ||
            (transaction['category'] != null &&
                transaction['category'].toLowerCase() ==
                    filterCategory.toLowerCase());

        return matchesSearch && matchesType && matchesCategory;
      }).toList();
    });
  }

  void _updateTransaction(int index, Map<String, dynamic> updatedTransaction) {
    widget.onUpdateTransaction(index, updatedTransaction);
    _filterTransactions();
  }

  void _deleteTransaction(int index) {
    widget.onDeleteTransaction(index);
    _filterTransactions();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Transactions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Transactions',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                DropdownButton<String>(
                  value: filterType,
                  items: [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'income', child: Text('Income')),
                    DropdownMenuItem(value: 'expense', child: Text('Expense')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      filterType = value!;
                      _filterTransactions();
                    });
                  },
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: filterCategory,
                  items: [
                    DropdownMenuItem(value: 'all', child: Text('All Categories')),
                    ...widget.transactions
                        .where((t) => t['type'] == 'expense')
                        .map((t) => t['category'])
                        .toSet()
                        .map((category) => DropdownMenuItem<String>(
                        value: category, child: Text(category)))
                        .toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      filterCategory = value!;
                      _filterTransactions();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = filteredTransactions[index];
                  return ListTile(
                    title: Text(transaction['title']),
                    subtitle: Text('${transaction['date']} - ${transaction['category'] ?? ''}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(index, transaction);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTransaction(index),
                        ),
                      ],
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

  void _showEditDialog(int index, Map<String, dynamic> transaction) {
    final TextEditingController titleController =
    TextEditingController(text: transaction['title']);
    final TextEditingController amountController =
    TextEditingController(text: transaction['amount'].toString());
    String type = transaction['type'];
    String category = transaction['category'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: type,
                items: [
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (value) {
                  setState(() {
                    type = value!;
                  });
                },
              ),
              if (type == 'expense')
                DropdownButton<String>(
                  value: category,
                  items: widget.transactions
                      .where((t) => t['type'] == 'expense')
                      .map((t) => t['category'])
                      .toSet()
                      .map((category) => DropdownMenuItem<String>(
                      value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedTransaction = {
                  'title': titleController.text,
                  'amount': double.tryParse(amountController.text) ?? 0.0,
                  'type': type,
                  'category': type == 'expense' ? category : null,
                  'date': transaction['date'],
                };
                _updateTransaction(index, updatedTransaction);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}



