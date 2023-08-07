import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

const String apiBaseUrl = 'http://192.168.1.8:3000';
//const String apiBaseUrl = 'http://localhost:3000';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: authenticateWithGoogle,
            child: Text("Authenticate with Google"),
          ),
        ),
      ),
    );
  }
}

void authenticateWithGoogle() async {
  try {
    final response = await http.get(Uri.parse('$apiBaseUrl/auth/google'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log('Response body: $data');
    } else {
      log('Error: ${response.statusCode}');
      log('Response body: ${response.body}');
    }
  } catch (e) {
    log('Error: $e');
  }
}

