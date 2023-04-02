import 'package:flutter/material.dart';

enum MyTheme {
  defaultTheme,
}

final _defaultTheme = ThemeData.dark(useMaterial3: true).copyWith(
  appBarTheme: AppBarTheme(
    toolbarHeight: 80.0,
    backgroundColor: Colors.grey.shade900,
    titleTextStyle: TextStyle(
      fontSize: 36.0,
      color: Colors.grey.shade200,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: CardTheme(color: Colors.grey.shade800),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey, height: 1.5),
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
  ),
  tabBarTheme: TabBarTheme(unselectedLabelColor: Colors.grey.shade50),
  textTheme: TextTheme(
    headlineSmall: TextStyle(
      fontSize: 32.0,
      color: Colors.grey.shade100,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    titleLarge: TextStyle(
      fontSize: 28.0,
      color: Colors.grey.shade100,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    titleMedium: TextStyle(
      fontSize: 24.0,
      color: Colors.grey.shade100,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.0,
      color: Colors.grey.shade50,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.0,
      color: Colors.grey.shade50,
      height: 1.5,
    ),
  ),
);

extension MyThemeExtension on MyTheme {
  ThemeData get theme {
    switch (this) {
      case MyTheme.defaultTheme:
        return _defaultTheme;
      default:
        return ThemeData.fallback(useMaterial3: true);
    }
  }
}
