// lib/src/views/splash/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    /// Fade-in animation
    Timer(const Duration(milliseconds: 200), () {
      setState(() => _opacity = 1.0);
    });

    /// Navigate to Home after animation
    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, HomeScreen.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),
        opacity: _opacity,
        child: Center(
          child: Lottie.network(
            // Weather animation
            "https://assets2.lottiefiles.com/packages/lf20_j2ka6x2h.json",
            width: 220,
            height: 220,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
