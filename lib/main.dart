import 'package:flutter/material.dart';
import 'package:flutter_application/login_page.dart';
import 'package:flutter_application/signup_page.dart';
import 'package:flutter_application/welcome1.dart';
import 'package:flutter_application/welcome2.dart';
import 'package:flutter_application/welcome3.dart';
import 'package:flutter_application/welcome4.dart';

void main() {
  runApp(const SignLanguageApp());
}

class SignLanguageApp extends StatelessWidget {
  const SignLanguageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Welcome1(),
        '/welcome2': (context) => const Welcome2(),
        '/welcome3': (context) => const Welcome3(),
        '/welcome4': (context) => const Welcome4(),
        '/login_page': (context) => const LoginPage(),
        '/signup_page': (context) => const SignupPage(),
      },
    );
  }
}
