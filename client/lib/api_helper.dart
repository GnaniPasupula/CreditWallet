import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'credit_card_data.dart';

class ApiHelper {
  static const baseUrl = 'http://localhost:3000';
  //static const baseUrl = 'http://192.168.1.8:3000';
  
  static Future<List<CreditCardData>> fetchCreditCardData() async {
    final url = '$baseUrl/creditCard/get';

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      // print("authToken from get");
      // print(authToken);

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<CreditCardData> creditCards = jsonData
            .map((data) => CreditCardData.fromJson(data))
            .toList();
        return creditCards;
      } else {
        throw Exception('Failed to fetch credit card data :(');
      }
    } catch (e) {
      throw Exception('Error fetching credit card data: $e');
    }
  }

static Future<CreditCardData?> deleteCreditCard(String cardNumber) async {
  final url = '$baseUrl/creditCard/delete/$cardNumber';

  try {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    final response = await http.delete(
      Uri.parse(url),
      headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
    );

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      return CreditCardData.fromJson(jsonData);
    } else {
      throw Exception('Failed to delete credit card');
    }
  } catch (e) {
    throw Exception('Error deleting credit card: $e');
  }
}

static Future<CreditCardData?> updateCreditCard(
    String cardNumber,
    double limit,
    double outStanding,
    String expiryDate,
    String cardName,
    String bankName,
  ) async {
    final url = '$baseUrl/creditCard/update/$cardNumber';

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'limit': limit,
          'outStanding': outStanding,
          'expiryDate': expiryDate,
          'cardName': cardName,
          'bankName': bankName,
        }),
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        return CreditCardData.fromJson(jsonData);
      } else {
        throw Exception('Failed to update credit card');
      }
    } catch (e) {
      throw Exception('Error updating credit card: $e');
    }
  }


static Future<CreditCardData?> addCreditCard(
    String cardNumber,
    double limit,
    double outStanding,
    String expiryDate,
    String cardName,
    String bankName,
  ) async {
    final url = '$baseUrl/creditCard/add';

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      // print("authToken from add");
      // print(authToken);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cardNumber': cardNumber,
          'limit': limit,
          'outStanding': outStanding,
          'expiryDate': expiryDate,
          'cardName': cardName,
          'bankName': bankName,
        }),
      );

      if (response.statusCode == 201) {
        final dynamic jsonData = json.decode(response.body);
        return CreditCardData.fromJson(jsonData);
      } else {
        throw Exception('Failed to add credit card');
      }
    } catch (e) {
      throw Exception('Error adding credit card: $e');
    }
  }

  static Future<Transaction?> addTransactionToCard(String cardNumber, Map<String, dynamic> transactionData) async {
    final url = '$baseUrl/creditCard/addTransaction/$cardNumber';

    // print('cardNumber: ${cardNumber}');
    // print('transactionData: ${transactionData}');

    final ftransactionData = {
      'transactionAmount': transactionData['transactionAmount'],  
      'transactionTitle': transactionData['transactionTitle'],  
      'transactionCategory': transactionData['transactionCategory'],  
      'transactionDate': transactionData['transactionDate'],  
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      final response = await http.put(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $authToken', 'Content-Type': 'application/json'},
        body: jsonEncode(ftransactionData),
      );

      print('response.statusCode ${response.statusCode}');
      if (response.statusCode == 201) {
        final dynamic jsonData = json.decode(response.body);
        return Transaction(
          amount: jsonData['transactionAmount'].toDouble() ?? 0.0,
          title: jsonData['transactionTitle'] ?? "Unknown",
          category: jsonData['transactionCategory'] ?? "Unknown",
          date: DateTime.parse(jsonData['transactionDate']),
        );
      } else {
        throw Exception('Failed to add transaction');
      }
    } catch (e) {
      throw Exception('api_helper:Error adding transaction: $e');
    }
  }

  static Future<void> deleteCreditCardTransaction(String cardNumber, String transactionDate) async {
    final url = '$baseUrl/creditCard/transactions/$cardNumber/$transactionDate';

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Transaction deleted successfully
      } else {
        throw Exception('Failed to delete transaction');
      }
    } catch (e) {
      throw Exception('Error deleting transaction: $e');
    }
  }



}
