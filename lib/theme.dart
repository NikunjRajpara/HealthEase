import 'package:flutter/material.dart';

class AppTheme {
  static const _brandSeed = Color(0xFF0DBB77);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _brandSeed,
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _brandSeed,
        brightness: Brightness.dark,
      );
}
