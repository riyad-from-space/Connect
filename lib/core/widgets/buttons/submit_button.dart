import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/text_style.dart';

class SubmitButton extends StatefulWidget {
  final bool isEnabled;
  final Function? onSubmit;
  final String buttonText;
  final String message;


  const SubmitButton({
    super.key,
    required this.isEnabled,
    this.onSubmit,
    this.buttonText = 'Continue',
    required this.message
  });

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.isEnabled && widget.onSubmit != null) {
          widget.onSubmit!();
        }

        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.message),
              backgroundColor: Colors.red,
            ),
          );

        }

      },
      child: Container(
        height: 46,
        width: 290,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          color: widget.isEnabled ? const Color(0xffA76FFF) : const Color.fromARGB(255, 201, 176, 240),
        ),
        child: Center(
          child: Text(
            widget.buttonText,
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
