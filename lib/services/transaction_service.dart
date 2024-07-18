class TransactionService {
  double totalBalance = 0.0;
  double totalExpenses = 0.0;
  double totalIncome = 0.0;
  List<Map<String, dynamic>> recentTransactions = [];

  void addTransaction(String title, double amount, String type, String category) {
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
  }

  void updateTransaction(int index, Map<String, dynamic> updatedTransaction) {
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
  }

  void deleteTransaction(int index) {
    if (recentTransactions[index]['type'] == 'income') {
      totalBalance -= recentTransactions[index]['amount'];
      totalIncome -= recentTransactions[index]['amount'];
    } else {
      totalBalance += recentTransactions[index]['amount'];
      totalExpenses -= recentTransactions[index]['amount'];
    }
    recentTransactions.removeAt(index);
  }

  void setInitialBalance(double balance) {
    totalBalance = balance;
  }
}
