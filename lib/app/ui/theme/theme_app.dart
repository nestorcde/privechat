import 'package:flutter/material.dart';
final ThemeData appThemeData = ThemeData(
  primaryColor: Colors.blueAccent,
  //fontFamily: 'Georgia',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue),
);