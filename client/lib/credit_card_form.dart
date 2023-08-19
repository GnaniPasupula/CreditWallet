import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_helper.dart';
import 'credit_card_data.dart';

class CreditCardForm extends StatefulWidget {
  final VoidCallback onCardAdded;
  final bool isEditing;
  final CreditCardData? creditCard;

  CreditCardForm({
    Key? key,
    required this.onCardAdded,
    required this.isEditing,
    this.creditCard,
  }) : super(key: key);

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

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditing;

    if (_isEditing) {
      _populateFormFields(widget.creditCard);
    }
  }

  void _populateFormFields(CreditCardData? creditCard) {
    if (creditCard != null) {
      _cardNumberController.text = creditCard.cardNumber;
      _limitController.text = creditCard.limit.toString();
      _outstandingController.text = creditCard.outStanding.toString();
      _expiryDateController.text = creditCard.expiryDate;
      _cardNameController.text = creditCard.cardName;
      _bankNameController.text = creditCard.bankName;
    }
  }

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

    try {
      if (_isEditing) {
        final updatedCard = await ApiHelper.updateCreditCard(
          formData['cardNumber']!,
          double.parse(formData['limit']!),
          double.parse(formData['outStanding']!),
          formData['expiryDate']!,
          formData['cardName']!,
          formData['bankName']!,
        );

        if (updatedCard != null) {
          log('Credit card updated successfully: $updatedCard');
          Navigator.of(context).pop(updatedCard);
        } else {
          log('Error updating credit card');
        }
      } else {
        final creditCardData = await ApiHelper.addCreditCard(
          formData['cardNumber']!,
          double.parse(formData['limit']!),
          double.parse(formData['outStanding']!),
          formData['expiryDate']!,
          formData['cardName']!,
          formData['bankName']!,
        );

        if (creditCardData != null) {
          log('Credit card added successfully: $creditCardData');
          widget.onCardAdded(); // Call the callback to notify parent widget
          Navigator.of(context).pop();
        } else {
          log('Error adding credit card');
        }
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
                    _submitForm();
                  },
                  child: Text(_isEditing ? 'Update' : 'Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
