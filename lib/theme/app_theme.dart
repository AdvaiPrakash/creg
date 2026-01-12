
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color _neonLime = Color(0xFFCCFF00); // Neon Lime
  static const Color _darkNavy = Color(0xFF0B1221); // Deep Background
  static const Color _surfaceNavy = Color(0xFF162032); // Input Field Background
  static const Color _textWhite = Colors.white;
  static const Color _textGrey = Color(0xFF8F9BB3);

  // Light Theme (Optional backup, but focusing on Dark as primary for this design)
  static const Color _lightPrimary = _neonLime;
  static const Color _lightBackground = Colors.white;

  static TextTheme _textTheme(bool isDark) {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDark ? _textWhite : Colors.black,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: isDark ? _textWhite : Colors.black,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: isDark ? _neonLime : Colors.black,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: isDark ? _textWhite : Colors.black87,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: isDark ? _textGrey : Colors.black54,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black, // Dark text on Lime button
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(bool isDark) {
    Color fillColor = isDark ? _surfaceNavy : Colors.grey[100]!;
    Color borderColor = Colors.transparent;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      hintStyle: TextStyle(
        color: _textGrey,
        fontSize: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: _neonLime,
          width: 1.5,
        ),
      ),
      prefixIconColor: _textGrey,
    );
  }

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightBackground,
    primaryColor: _neonLime,
    colorScheme: const ColorScheme.light(
      primary: _neonLime,
      secondary: _darkNavy,
      surface: Colors.white,
      background: _lightBackground,
    ),
    textTheme: _textTheme(false),
    inputDecorationTheme: _inputDecorationTheme(false),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _neonLime,
        foregroundColor: _darkNavy,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkNavy,
    primaryColor: _neonLime,
    colorScheme: const ColorScheme.dark(
      primary: _neonLime,
      secondary: _neonLime,
      surface: _surfaceNavy,
      background: _darkNavy,
      onPrimary: _darkNavy,
    ),
    textTheme: _textTheme(true),
    inputDecorationTheme: _inputDecorationTheme(true),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _textWhite,
      ),
      iconTheme: const IconThemeData(color: _textWhite),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _neonLime,
        foregroundColor: _darkNavy,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
  );
}
