// lib/main.dart

import 'package:flutter/material.dart';
import 'theme.dart';
import 'constants.dart';


import 'screens/auth/onboarding/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BITOO',
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(),

      home: SplashScreen(),
    );
  }
}