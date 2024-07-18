import 'package:flutter/material.dart';

class SetBalanceScreen extends StatefulWidget {
  final Function(double) onSetBalance;

  SetBalanceScreen({required this.onSetBalance});

  @override
  _SetBalanceScreenState createState() => _SetBalanceScreenState();
}

class _SetBalanceScreenState extends State<SetBalanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _balanceController = TextEditingController();

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      widget.onSetBalance(double.parse(_balanceController.text));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Initial Balance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _balanceController,
                decoration: InputDecoration(labelText: 'Initial Balance'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a balance';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Set Balance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


