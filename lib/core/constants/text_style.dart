import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colours.dart';

class KTextStyle {
  static final TextStyle headline1 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: KColor.black,
    height: 1.2,
  );

  static final TextStyle headline2 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: KColor.black,
    height: 1.2,
  );

  static final TextStyle headline3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: KColor.black,
    height: 1.2,
  );

  static final TextStyle subtitle1 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: KColor.black,
    height: 1.5,
  );

  static final TextStyle subtitle2 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: KColor.black,
    height: 1.5,
  );

  static final TextStyle bodyText1 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: KColor.darkGrey,
    height: 1.5,
  );

  static final TextStyle bodyText2 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: KColor.darkGrey,
    height: 1.5,
  );

  static final TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: KColor.white,
    height: 1.5,
  );

  static final TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: KColor.grey,
    height: 1.5,
  );

  // Special Styles
  static final TextStyle link = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: KColor.primary,
    height: 1.5,
  );

  static final TextStyle error = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: KColor.error,
    height: 1.5,
  );

  static TextStyle sub_headline =  TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: GoogleFonts.openSans().fontFamily,
    color: const Color(0xff5C5D67),
  );

    static TextStyle for_description =  TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: GoogleFonts.openSans().fontFamily,
    color: const Color(0xff5C5D67
    ),
  );
}