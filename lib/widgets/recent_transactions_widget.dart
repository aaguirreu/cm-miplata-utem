import 'package:flutter/material.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentTransactions;
  final VoidCallback onViewAllTransactions;

  const RecentTransactionsWidget({
    Key? key,
    required this.recentTransactions,
    required this.onViewAllTransactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                          color: transaction['type'] == 'income' ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (recentTransactions.length > 4)
              ElevatedButton(
                onPressed: onViewAllTransactions,
                child: Text('View All Transactions'),
              ),
          ],
        ),
      ),
    );
  }
}
