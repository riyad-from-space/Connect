import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppIntroductionScreen extends StatelessWidget {
  const AppIntroductionScreen({super.key});

  Future<void> _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    Navigator.pushReplacementNamed(context, '/signup-type');
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Connect!",
          body:
              "Connect with people, share your thoughts, and explore trending topics.",
          image:
              Center(child: Image.asset('assets/images/Logo.png', height: 120)),
        ),
        PageViewModel(
          title: "Chat & Messaging",
          body:
              "Send messages, join conversations, and stay in touch with your friends.",
          image: Center(
              child: Icon(Icons.chat_bubble_outline,
                  size: 120, color: Colors.purple)),
        ),
        PageViewModel(
          title: "Blogs & Reactions",
          body:
              "Read, write, and react to blogs. Express yourself and engage with the community.",
          image: Center(
              child: Icon(Icons.article_outlined,
                  size: 120, color: Colors.purple)),
        ),
        PageViewModel(
          title: "Personalize Your Experience",
          body: "Choose your interests and customize your feed.",
          image:
              Center(child: Icon(Icons.tune, size: 120, color: Colors.purple)),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Get Started",
          style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.black26,
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.purple,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
