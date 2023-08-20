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
  final TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedCategory = "Food"; // Default selected category

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final formData = {
      'transactionAmount': amountController.text,
      'transactionTitle': titleController.text,
      'transactionCategory': selectedCategory,
      'transactionDate': selectedDate.toIso8601String(),
      'transactionNote': noteController.text,
    };

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
        print("spend_dialog:Error adding transaction data");
      }
    } catch (e) {
      // Handle error case
      print("spend_dialog:Error adding transaction data: $e");
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

          DropdownButtonFormField<String>(
            value: selectedCategory,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCategory = newValue;
                });
              }
            },
            items: <String>[
              "Fashion",
              "Food",
              "Health",
              "Fuel",
              "Travel",
              "Entertainment",
              "EMI",
              "Bills",
              "Others",
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(labelText: 'Category'),
          ),
          TextField(
            controller: noteController,
            decoration: InputDecoration(labelText: 'Note'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                child: Text(
                  'Date |${selectedDate.day}/${selectedDate.month}/${selectedDate.year}|',
                ),
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
                child: Text(
                  'Time |${selectedTime.hour}:${selectedTime.minute}|',
                ),
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
              date: DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              ),
              amount: double.tryParse(amountController.text) ?? 0.0,
              title: titleController.text,
              category: selectedCategory,
              note: noteController.text
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
