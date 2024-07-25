import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xFFFAF8ED),
    primary: Color(0xFF99B080),
    secondary: Color(0xFF748E63),
    surface: Colors.white,
    onSurface: Colors.black,
    onError: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.grey,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Colors.black,
    primary: Color(0xFF748E63),
    secondary: Color(0xFF3A4733),
    surface: Color(0xFF121212),
    onSurface: Colors.white,
    onError: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.grey,
  ),
);
