import 'package:flutter/material.dart';
import './auth_screen.dart'; // Import your authentication screen
import './credit_card_screen.dart'; // Import your credit card screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (ctx) => AuthScreen(), // Auth route
        '/credit_card_screen': (ctx) => CreditCardScreen(), // Credit card screen route
      },
    );
  }
}
