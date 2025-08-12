import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Inter',
      primarySwatch: Colors.blue,
      // You can customize other theme properties here
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Inter',
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      // You can customize other theme properties here
    );
  }
} 