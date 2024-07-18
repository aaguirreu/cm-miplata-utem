import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_transaction_screen.dart';
import 'category_screen.dart';
import 'set_balance_screen.dart';
import 'category_chart_screen.dart';
import 'all_transactions_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalBalance = 0.0;
  double totalExpenses = 0.0;
  double totalIncome = 0.0;
  List<Map<String, dynamic>> recentTransactions = [];
  List<String> categories = ['Food', 'Transport', 'Entertainment'];
  bool isInitialBalanceSet = false;
  int _selectedIndex = 0;

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
        totalIncome += amount;
      } else {
        totalBalance -= amount;
        totalExpenses += amount;
      }
    });
  }

  void _updateTransaction(int index, Map<String, dynamic> updatedTransaction) {
    setState(() {
      if (recentTransactions[index]['type'] == 'income') {
        totalBalance -= recentTransactions[index]['amount'];
        totalIncome -= recentTransactions[index]['amount'];
      } else {
        totalBalance += recentTransactions[index]['amount'];
        totalExpenses -= recentTransactions[index]['amount'];
      }

      recentTransactions[index] = updatedTransaction;

      if (updatedTransaction['type'] == 'income') {
        totalBalance += updatedTransaction['amount'];
        totalIncome += updatedTransaction['amount'];
      } else {
        totalBalance -= updatedTransaction['amount'];
        totalExpenses += updatedTransaction['amount'];
      }
    });
  }

  void _deleteTransaction(int index) {
    setState(() {
      if (recentTransactions[index]['type'] == 'income') {
        totalBalance -= recentTransactions[index]['amount'];
        totalIncome -= recentTransactions[index]['amount'];
      } else {
        totalBalance += recentTransactions[index]['amount'];
        totalExpenses -= recentTransactions[index]['amount'];
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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddTransactionScreen(onAddTransaction: _addTransaction, categories: categories),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryScreen(
              categories: categories,
              onUpdateCategories: _updateCategories,
              recentTransactions: recentTransactions,
            ),
          ),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryChartScreen(recentTransactions: recentTransactions),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Color(0xFFefbdeb),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Color(0xFFefbdeb),
                    elevation: 0,
                    title: Text('App Mi Plata UTEM'),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: _signOut,
                      ),
                    ],
                  ),
                  Padding(
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Color(0xFFefbdeb),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Expenses',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalExpenses.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Income',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalIncome.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: recentTransactions.isEmpty
                        ? Center(child: Text('No recent transactions'))
                        : ListView.builder(
                      itemCount: recentTransactions.length < 4 ? recentTransactions.length : 4,
                      itemBuilder: (context, index) {
                        final transaction = recentTransactions[index];
                        return Card(
                          child: ListTile(
                            title: Text(transaction['title']),
                            subtitle: Text('${transaction['date']} - ${transaction['category'] ?? ''}'),
                            trailing: Text(
                              '\$${transaction['amount'].toStringAsFixed(2)}',
                              style: TextStyle(
                                color: transaction['type'] == 'income'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (recentTransactions.length > 4)
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Category Chart',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}


















