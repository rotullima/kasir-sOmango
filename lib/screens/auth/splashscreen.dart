import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FDF2),
        body: Center(
          child: Image.asset(
            'assets/logo.png',
            width: 250,
          ),
        ),
      ),
    );
  }
}
