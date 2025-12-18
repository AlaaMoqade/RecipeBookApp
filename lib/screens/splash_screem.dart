import 'package:flutter/material.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  void _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final bool loggedIn = await SharedPrefs.isLoggedIn();

    if (!loggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/img/public/logo.png',
          fit: BoxFit.cover,
          alignment: Alignment.center, 
        ),
      ),
    );
  }
}
