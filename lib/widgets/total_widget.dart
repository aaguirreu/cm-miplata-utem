import 'package:flutter/material.dart';

class TotalWidget extends StatelessWidget {
  final double totalExpenses;
  final double totalIncome;

  const TotalWidget({
    Key? key,
    required this.totalExpenses,
    required this.totalIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F0F6), // Color de fondo blanco
        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
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
    );
  }
}
