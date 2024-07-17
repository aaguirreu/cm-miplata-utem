// home_screen.dart
import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';
import 'category_screen.dart';
import 'set_balance_screen.dart';

class HomeScreen extends StatefulWidget {
  final double totalBalance;
  final List<Map<String, dynamic>> recentTransactions;

  HomeScreen({required this.totalBalance, required this.recentTransactions});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double totalBalance;
  late List<Map<String, dynamic>> recentTransactions;
  List<String> categories = ['Food', 'Transport', 'Entertainment'];

  @override
  void initState() {
    super.initState();
    totalBalance = widget.totalBalance;
    recentTransactions = widget.recentTransactions;
  }

  void _addTransaction(String title, double amount, String type, String category) {
    setState(() {
      recentTransactions.add({
        'title': title,
        'amount': amount,
        'date': DateTime.now().toString().split(' ')[0],
        'type': type,
        'category': category,
      });

      if (type == 'income') {
        totalBalance += amount;
      } else {
        totalBalance -= amount;
      }
    });
  }

  void _updateCategories(List<String> updatedCategories) {
    setState(() {
      categories = updatedCategories;
    });
  }

  void _setInitialBalance(double balance) {
    setState(() {
      totalBalance = balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance: \$${totalBalance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SetBalanceScreen(onSetBalance: _setInitialBalance),
                  ),
                );
              },
              child: Text('Set Initial Balance'),
            ),
            SizedBox(height: 20),
            Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: recentTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = recentTransactions[index];
                  return ListTile(
                    title: Text(transaction['title']),
                    subtitle: Text('${transaction['date']} - ${transaction['category'] ?? ''}'),
                    trailing: Text(
                      '\$${transaction['amount'].toStringAsFixed(2)}',
                      style: TextStyle(
                          color: transaction['type'] == 'income'
                              ? Colors.green
                              : Colors.red),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddTransactionScreen(onAddTransaction: _addTransaction, categories: categories),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(
                    categories: categories,
                    onUpdateCategories: _updateCategories,
                    recentTransactions: recentTransactions,
                  ),
                ),
              );
            },
            child: Icon(Icons.category),
          ),
        ],
      ),
    );
  }
}





