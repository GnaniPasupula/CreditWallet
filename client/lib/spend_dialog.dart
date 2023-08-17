import 'dart:math';

import 'package:flutter/material.dart';
import 'api_helper.dart';
import 'credit_card_data.dart';

class SpendDetailsDialog extends StatefulWidget {
  final Function(Transaction) onSave;
  final List<CreditCardData> creditCards;
  final int currentIndex; 

  SpendDetailsDialog({
    required this.onSave,
    required this.creditCards,
    required this.currentIndex,
  });


  @override
  _SpendDetailsDialogState createState() => _SpendDetailsDialogState();
}

class _SpendDetailsDialogState extends State<SpendDetailsDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final formData = {
      'transactionAmount': amountController.text,
      'transactionTitle': titleController.text,
      'transactionCategory': categoryController.text,
      'transactionDate': selectedDate.toIso8601String(),
    };

    // print('Title: ${titleController.text}');
    // print('Amount: ${amountController.text}');
    // print('Category: ${categoryController.text}');
    // print('Date: $selectedDate');

    // print('form data :${formData}');

    try {
      final addedTransaction = await ApiHelper.addTransactionToCard(
        widget.creditCards[widget.currentIndex].cardNumber,
        formData,
      );

      if (addedTransaction != null) {
        widget.onSave.call(addedTransaction);
        Navigator.of(context).pop(addedTransaction);
      } else {
        // Handle error case
        print("spend_dialog:Erros adding transaction data1");
      }
    } catch (e) {
      // Handle error case
      print("spend_dialog:Erros adding transaction data2${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Spend Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: amountController,
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          TextField(
            controller: categoryController,
            decoration: InputDecoration(labelText: 'Category'),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Text('Select Date'),
              ),
              SizedBox(width: 20),
              TextButton(
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null && picked != selectedTime) {
                    setState(() {
                      selectedTime = picked;
                    });
                  }
                },
                child: Text('Select Time'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final transaction = Transaction(
              date: DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute),
              amount: double.tryParse(amountController.text) ?? 0.0,
              title: titleController.text,
              category: categoryController.text,
            );

            widget.onSave(transaction);
            Navigator.of(context).pop();
            _submitForm();

          },
          child: Text('Save'),
        ),
      ],
      
    );
  }
}
