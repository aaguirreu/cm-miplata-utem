// home_screen.dart
import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';
import 'category_screen.dart';
import 'set_balance_screen.dart';
import 'category_chart_screen.dart';
import 'all_transactions_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalBalance = 0.0;
  List<Map<String, dynamic>> recentTransactions = [];
  List<String> categories = ['Food', 'Transport', 'Entertainment'];
  bool isInitialBalanceSet = false;

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

  void _updateTransaction(int index, Map<String, dynamic> updatedTransaction) {
    setState(() {
      recentTransactions[index] = updatedTransaction;
      if (updatedTransaction['type'] == 'income') {
        totalBalance += updatedTransaction['amount'];
      } else {
        totalBalance -= updatedTransaction['amount'];
      }
    });
  }

  void _deleteTransaction(int index) {
    setState(() {
      if (recentTransactions[index]['type'] == 'income') {
        totalBalance -= recentTransactions[index]['amount'];
      } else {
        totalBalance += recentTransactions[index]['amount'];
      }
      recentTransactions.removeAt(index);
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
      isInitialBalanceSet = true;
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
            if (!isInitialBalanceSet)
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
              child: recentTransactions.isEmpty
                  ? Center(child: Text('No recent transactions'))
                  : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: recentTransactions.length < 4 ? recentTransactions.length : 4,
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AllTransactionsScreen(
                            transactions: recentTransactions,
                            onUpdateTransaction: _updateTransaction,
                            onDeleteTransaction: _deleteTransaction,
                          ),
                        ),
                      );
                    },
                    child: Text('View All Transactions'),
                  ),
                ],
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
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CategoryChartScreen(recentTransactions: recentTransactions),
                ),
              );
            },
            child: Icon(Icons.pie_chart),
          ),
        ],
      ),
    );
  }
}











