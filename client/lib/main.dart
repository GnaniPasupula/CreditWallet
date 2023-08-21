import 'package:flutter/material.dart';
import './auth_screen.dart'; // Import your authentication screen
import './credit_card_screen.dart'; // Import your credit card screen

void main() {
  runApp(MyApp());
}

  final List<Color> gradientColor = [
    const Color(0xffffa31d),
    const Color(0xffef5454),
  ];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xffef5454, <int, Color>{
          50:  gradientColor[0],
          100: gradientColor[0],
          200: gradientColor[0],
          300: gradientColor[0],
          400: gradientColor[0],
          500: gradientColor[0],
          600: gradientColor[0],
          700: gradientColor[0],
          800: gradientColor[0],
          900: gradientColor[0],
        }),      
      ),
      routes: {
        '/': (ctx) => AuthScreen(), // Auth route
        '/credit_card_screen': (ctx) => CreditCardScreen(), // Credit card screen route
      },
    );
  }
}
