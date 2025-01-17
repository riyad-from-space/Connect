import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/text_style.dart';

class SignupTypeButton extends StatelessWidget {
  SignupTypeButton(
      {super.key,
      required this.background_color,
      required this.provider_name,
      this.icon,
      this.image,
      this.isGoogle = false});

  String provider_name;
  Color background_color;
  Icon? icon;
  Image? image;
  bool isGoogle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30),
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(120),
        color: background_color,
      ),
      child: Row(
        children: [
          isGoogle ? image! : icon!,
          const SizedBox(width: 50),
          Text(
            'Continue with ',
            style: KTextStyle.subtitle1.copyWith(
              fontFamily: GoogleFonts.openSans().fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: const Color(0xffA6A6A6),
            ),
          ),
          const SizedBox(width: 2),
          Text(
            provider_name,
            style: KTextStyle.subtitle1.copyWith(
              fontFamily: GoogleFonts.openSans().fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
