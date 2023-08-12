import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signup() async {
    const url = 'http://localhost:3000/auth/signup';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      _showSuccessDialog('User registered successfully');
    } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'];
      _showErrorDialog(errorMessage);
    }
  }

  Future<void> _signin() async {
    final url = 'http://localhost:3000/auth/signin';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final authToken = responseData['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', authToken);
      Navigator.of(context).pushReplacementNamed('/credit_card_screen'); // Navigate to credit_card_screen.dart screen
    } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message'];
      _showErrorDialog(errorMessage);
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: Text('Sign Up'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _signin,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
