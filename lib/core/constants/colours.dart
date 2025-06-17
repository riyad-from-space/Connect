import 'package:flutter/material.dart';

class KColor {
  // Primary Colors
  static const Color primary = Color(0xffA76FFF);
  static const Color secondary = Color(0xFF00C922);
  static const Color accent = Color(0xFF246BFD);
  
  // Text Colors - Light Theme
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF404040);
  static const Color textTertiary = Color(0xFF666666);
  
  // Text Colors - Dark Theme
  static const Color darkTextPrimary = Color(0xFFE6E6E6);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  static const Color darkTextTertiary = Color(0xFF999999);
  
  // Neutral Colors
  static const Color black = Color(0xff17131B);
  static const Color darkGrey = Color(0xff5C5D67);
  static const Color grey = Color(0xff7E7F88);
  static const Color lightGrey = Color(0xffC0C0C9);
  static const Color white = Colors.white;
  
  // Background Colors - Light Theme
  static const Color background = Color(0xffF2F9FB);
  static const Color surface = Color(0xffFAFAFA);
  
  // Background Colors - Dark Theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);

  // Status Colors
  static const Color success = Color(0xFF00C922);
  static const Color error = Color(0xFFE23F36);
  static const Color warning = Color(0xFFFFA500);
  static const Color info = Color(0xFF246BFD);

  // Social Colors
  static const Color backgroundForGoogle = Color(0xff18436E);
  static const Color backgrounforEmail = Color(0xffE23F36);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xffA76FFF),
    Color(0xFF8A4FD8),
  ];
  
  // Opacity Colors
  static Color blackOpacity5 = black.withOpacity(0.05);
  static Color blackOpacity10 = black.withOpacity(0.1);
  static Color primaryOpacity10 = primary.withOpacity(0.1);
  static Color primaryOpacity20 = primary.withOpacity(0.2);
  static Color whiteOpacity60 = white.withOpacity(0.6);
}
