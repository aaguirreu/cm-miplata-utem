import 'package:flutter/material.dart';

class AppBarBalanceWidget extends StatelessWidget {
  final double totalBalance;
  final bool isInitialBalanceSet;
  final VoidCallback onSetBalance;
  final VoidCallback onSignOut;

  const AppBarBalanceWidget({
    Key? key,
    required this.totalBalance,
    required this.isInitialBalanceSet,
    required this.onSetBalance,
    required this.onSignOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFefbdeb),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Color(0xFFefbdeb),
              elevation: 0,
              title: Text('Home Screen'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: onSignOut,
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
                      onPressed: onSetBalance,
                      child: Text('Set Initial Balance'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
