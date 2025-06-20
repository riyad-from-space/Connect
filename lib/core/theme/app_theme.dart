import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colours.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: KColor.primary,
      brightness: Brightness.light,
    ).copyWith(
      secondary: KColor.secondary,
      surface: KColor.surface,
      background: KColor.background,
      // Adding semantic colors for better theme consistency
      onPrimary: KColor.white,
      onSecondary: KColor.white,
      onSurface: KColor.textPrimary,
      onBackground: KColor.textPrimary,
    ),
    scaffoldBackgroundColor: KColor.background,
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: KColor.black,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: KColor.black,
        height: 1.2,
      ),
      headlineSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,

        color: const Color(0xff5C5D67),
      )
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: KColor.white,
      elevation: 0,
      iconTheme: IconThemeData(color: KColor.black),
      titleTextStyle: GoogleFonts.poppins(
        color: KColor.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: KColor.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: KColor.blackOpacity5,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: KColor.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(color: KColor.grey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: KColor.primary,
        foregroundColor: KColor.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: KColor.blackOpacity5,
      selectedColor: KColor.primaryOpacity20,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      labelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: KColor.darkGrey,
      ),
      secondaryLabelStyle: TextStyle(color: KColor.white),
      brightness: Brightness.light,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: KColor.primary,
      brightness: Brightness.dark,
    ).copyWith(
      secondary: KColor.secondary,
      surface: KColor.darkSurface,
      background: KColor.darkBackground,
      // Adding semantic colors for better theme consistency
      onPrimary: KColor.white,
      onSecondary: KColor.white,
      onSurface: KColor.darkTextPrimary,
      onBackground: KColor.darkTextPrimary,
    ),
    scaffoldBackgroundColor: KColor.darkBackground,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(

      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: KColor.darkTextSecondary,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: KColor.white,
        height: 1.2,
      ),
      headlineSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: GoogleFonts.openSans().fontFamily,
        color: const Color(0xff5C5D67),
      )
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: KColor.darkSurface,
      elevation: 0,
      iconTheme: IconThemeData(color: KColor.darkTextPrimary),
      titleTextStyle: GoogleFonts.poppins(
        color: KColor.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: KColor.darkCard,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: KColor.darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: KColor.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(color: KColor.darkTextTertiary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: KColor.primary,
        foregroundColor: KColor.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF2C2C2C),
      selectedColor: KColor.primaryOpacity20,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      labelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: KColor.white,
      ),
      secondaryLabelStyle: TextStyle(color: KColor.white),
      brightness: Brightness.dark,
    ),
  );
}
