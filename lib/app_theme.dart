import 'package:flutter/material.dart';

class AppTheme {
  // Brand blues
  static const Color brandBlue = Color(0xFF1A73E8); // Google-like blue
  static const Color brandBlueDark =
      Color(0xFF0F5CCB); // darker accent (optional)

  static ThemeData get light => _theme(Brightness.light);
  static ThemeData get dark => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: brandBlue,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,

      // Make buttons consistently blue
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const MaterialStatePropertyAll(Size.fromHeight(48)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return scheme.primary.withOpacity(0.38);
            }
            return scheme.primary; // blue
          }),
          foregroundColor: MaterialStatePropertyAll(scheme.onPrimary),
        ),
      ),

      // Inputs look consistent on all pages
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceVariant.withOpacity(0.30),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIconColor: scheme.onSurfaceVariant,
      ),

      // Chips / Segments use themed colors
      chipTheme: ChipThemeData(
        labelStyle: TextStyle(
          color: brightness == Brightness.light
              ? scheme.onSurface
              : scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: scheme.surfaceVariant,
        selectedColor: scheme.primary,
        side: BorderSide(color: scheme.outlineVariant),
        shape: StadiumBorder(),
      ),

      // App bar tint
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
    );
  }
}
