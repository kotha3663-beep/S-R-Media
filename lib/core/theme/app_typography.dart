import 'package:flutter/material.dart';

class AppTypography {
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, height: 1.5),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  );
}
