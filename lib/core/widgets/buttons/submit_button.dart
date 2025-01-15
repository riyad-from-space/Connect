import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/text_style.dart';

class SubmitButton extends StatefulWidget {
  final bool submit;
  final Function onsubmit;

  const SubmitButton({super.key, required this.submit, required this.onsubmit});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.submit) {
          widget.onsubmit();
        }
      },
      child: Container(
        height: 46,
        width: 290,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            color: widget.submit ? const Color(0xffA76FFF) : const Color.fromARGB(255, 201, 176, 240)),
        child: Center(
          child: Text(
            'Continue',
            style: KTextStyle.subtitle1.copyWith(
              fontFamily: GoogleFonts.openSans().fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: const Color(0xff17131B),
            ),
          ),
        ),
      ),
    );
  }
}
