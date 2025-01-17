import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xffD6E5EA)),
      ),
      child: Container(
          margin: const EdgeInsets.only(left: 5),
          child: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Color(0xff7E7F88),
          )),
    );
  }
}
