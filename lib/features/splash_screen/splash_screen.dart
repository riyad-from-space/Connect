import 'dart:async';
import 'package:connect/features/auth/widgets/auth_checker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthChecker()),
              (route) => false, // Removes all previous routes
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Ellipse 1.png',
                    height: 95,
                    width: 95,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Powered by Connect',
                style: KTextStyle.subtitle1.copyWith(
                  fontFamily: GoogleFonts.openSans().fontFamily,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: const Color(0xff7E7F88),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
