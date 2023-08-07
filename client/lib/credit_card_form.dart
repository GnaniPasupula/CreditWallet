import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreditCardForm extends StatefulWidget {
  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _outstandingController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _limitController.dispose();
    _outstandingController.dispose();
    _expiryDateController.dispose();
    _cardNameController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final formData = {
      'cardNumber': _cardNumberController.text,
      'limit': _limitController.text,
      'outStanding': _outstandingController.text,
      'expiryDate': _expiryDateController.text,
      'cardName': _cardNameController.text,
      'bankName': _bankNameController.text,
    };

    const apiUrl = 'http://192.168.1.8:3000/creditCard/add'; 

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );

      if (response.statusCode == 201) {
        log('Form data submitted successfully!');
      } else {
        log('Error submitting form data: ${response.body}');
      }
    } catch (e) {
      log('Error submitting form data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(labelText: 'Card Number'),
                ),
                TextFormField(
                  controller: _limitController,
                  decoration: InputDecoration(labelText: 'Limit'),
                ),
                TextFormField(
                  controller: _outstandingController,
                  decoration: InputDecoration(labelText: 'Outstanding'),
                ),
                TextFormField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(labelText: 'Expiry Date'),
                ),
                TextFormField(
                  controller: _cardNameController, 
                  decoration: InputDecoration(labelText: 'Card Name'),
                ),
                TextFormField(
                  controller: _bankNameController,
                  decoration: InputDecoration(labelText: 'Bank Name'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _submitForm();
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
