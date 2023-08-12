import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'credit_card_data.dart';

class ApiHelper {
  //static const baseUrl = 'http://192.168.1.8:3000';
  static const baseUrl = 'http://localhost:3000';

  static Future<List<CreditCardData>> fetchCreditCardData() async {
    final url = '$baseUrl/creditCard/get';

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

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
      final response = await http.delete(Uri.parse(url));

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

}
