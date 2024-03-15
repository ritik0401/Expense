import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Expensesp extends StatefulWidget {
  const Expensesp({Key? key}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expensesp> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionsString = prefs.getString('transactions');
    if (transactionsString != null) {
      setState(() {
        transactions =
            List<Map<String, dynamic>>.from(json.decode(transactionsString));
      });
    }
  }

  Future<void> _deleteTransaction(int index) async {
    transactions.removeAt(index); // Remove the transaction from the list
    final prefs = await SharedPreferences.getInstance();
    // Update the stored transactions in SharedPreferences
    await prefs.setString('transactions', json.encode(transactions));
    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          var transaction = transactions[index];
          return ListTile(
            title: Text('${transaction['name']} - \$${transaction['amount']}'),
            subtitle: Text(
                'Date: ${transaction['date']} - Category: ${transaction['category']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTransaction(index),
            ),
          );
        },
      ),
    );
  }
}
