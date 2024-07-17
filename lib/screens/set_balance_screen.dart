// set_balance_screen.dart
import 'package:flutter/material.dart';

class SetBalanceScreen extends StatefulWidget {
  final Function(double) onSetBalance;

  SetBalanceScreen({required this.onSetBalance});

  @override
  _SetBalanceScreenState createState() => _SetBalanceScreenState();
}

class _SetBalanceScreenState extends State<SetBalanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _balanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Initial Balance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _balanceController,
                decoration: InputDecoration(labelText: 'Initial Balance'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a balance';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    double balance = double.tryParse(_balanceController.text) ?? 0.0;
                    widget.onSetBalance(balance);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Set Balance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
