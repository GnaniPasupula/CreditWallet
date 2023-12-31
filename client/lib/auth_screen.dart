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
  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); 

  bool _isSignIn = true; // Initially set to Sign In
  bool passwordsMatch = false; // Initialize passwordsMatch to false

   @override
  void initState() {
    super.initState();
    _signUpPasswordController.addListener(updatePasswordsMatch);
    _confirmPasswordController.addListener(updatePasswordsMatch);
  }

  void updatePasswordsMatch() {
    setState(() {
      passwordsMatch = _signUpPasswordController.text == _confirmPasswordController.text;
    });
  }

  Future<void> _signup() async {
    // const url = 'http://localhost:3000/auth/signup';
    const url = 'http://192.168.249.80:3000/auth/signup';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': _signUpEmailController.text,
        'password': _signUpPasswordController.text,
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
    // final url = 'http://localhost:3000/auth/signin';
    const url = 'http://192.168.249.80:3000/auth/signin';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': _signInEmailController.text,
          'password': _signInPasswordController.text,
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
    catch (error) {
      print('Error during HTTP request: $error');
    }  
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success', style: TextStyle(color: Colors.green)),
        content: Text(message, style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK', style: TextStyle(color: Colors.green)),
          ),
        ],
        backgroundColor: Colors.yellow,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error', style: TextStyle(color: Colors.red)),
        content: Text(message, style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
        backgroundColor: Colors.yellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set a dark background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20), // Add some spacing
              ToggleButtons(
                constraints: const BoxConstraints.tightFor(height: 30), // Set the desired height
                isSelected: [_isSignIn, !_isSignIn],
                onPressed: (index) {
                  setState(() {
                    _isSignIn = index == 0; // Toggle the state
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: _isSignIn ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: !_isSignIn ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
                fillColor: Colors.yellow,
                selectedColor: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),

              SizedBox(height: 20),
              if (_isSignIn) // Display Sign In fields
                Column(
                  children: [
                    TextField(
                      controller: _signInEmailController,
                      style: TextStyle(color: Colors.yellow),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.yellow),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _signInPasswordController,
                      style: TextStyle(color: Colors.yellow),
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.yellow),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              if (!_isSignIn) // Display Sign Up fields
                Column(
                  children: [
                    TextField(
                      controller: _signUpEmailController,
                      style: TextStyle(color: Colors.yellow),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.yellow),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _signUpPasswordController,
                      style: TextStyle(color: Colors.yellow),
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.yellow),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      obscureText: true,
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      style: TextStyle(color: Colors.yellow),
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.yellow),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              SizedBox(height: 20),
              AbsorbPointer(
                absorbing: _isSignIn ? false : !passwordsMatch,
                child: ElevatedButton(
                  onPressed: (_isSignIn ? _signin : _signup),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: IgnorePointer(
                    ignoring: (!_isSignIn && !passwordsMatch),
                    child: Opacity(
                      opacity: (passwordsMatch && _signUpPasswordController.text.length!=0) || _isSignIn? 1.0 : 0.5,
                      child: Text(
                        _isSignIn ? 'Sign In' : 'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
