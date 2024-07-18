import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_transaction_screen.dart';
import 'category_screen.dart';
import 'set_balance_screen.dart';
import 'category_chart_screen.dart';
import 'all_transactions_screen.dart';
import 'login_screen.dart';
import '../services/transaction_service.dart';
import '../widgets/appbar_balance_widget.dart';
import '../widgets/recent_transactions_widget.dart';
import '../widgets/total_widget.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TransactionService _transactionService = TransactionService();
  List<String> categories = ['Food', 'Transport', 'Entertainment'];
  bool isInitialBalanceSet = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddTransactionScreen(
              onAddTransaction: (title, amount, type, category) {
                setState(() {
                  _transactionService.addTransaction(title, amount, type, category);
                });
              },
              categories: categories,
            ),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryScreen(
              categories: categories,
              onUpdateCategories: (updatedCategories) {
                setState(() {
                  categories = updatedCategories;
                });
              },
              recentTransactions: _transactionService.recentTransactions,
            ),
          ),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryChartScreen(
              recentTransactions: _transactionService.recentTransactions,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBarBalanceWidget(
            totalBalance: _transactionService.totalBalance,
            isInitialBalanceSet: isInitialBalanceSet,
            onSetBalance: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SetBalanceScreen(
                    onSetBalance: (balance) {
                      setState(() {
                        _transactionService.setInitialBalance(balance);
                        isInitialBalanceSet = true;
                      });
                    },
                  ),
                ),
              );
            },
            onSignOut: _signOut,
          ),
          TotalWidget(
            totalExpenses: _transactionService.totalExpenses,
            totalIncome: _transactionService.totalIncome,
          ),
          RecentTransactionsWidget(
            recentTransactions: _transactionService.recentTransactions,
            onViewAllTransactions: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AllTransactionsScreen(
                    transactions: _transactionService.recentTransactions,
                    onUpdateTransaction: (index, updatedTransaction) {
                      setState(() {
                        _transactionService.updateTransaction(index, updatedTransaction);
                      });
                    },
                    onDeleteTransaction: (index) {
                      setState(() {
                        _transactionService.deleteTransaction(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}






