import 'package:connect/features/on_boarding/view/screens/app_introduction_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  @override
  void initState() {
    super.initState();
    try {
      _controller = VideoPlayerController.asset('assets/images/splash.webm')
        ..initialize().then((_) {
          setState(() {
            _initialized = true;
          });
          _controller.play();
        });
      _controller.setLooping(false);
      _controller.addListener(() async {
        if (_controller.value.position >= _controller.value.duration &&
            _initialized) {
          final prefs = await SharedPreferences.getInstance();
          final onboardingComplete =
              prefs.getBool('onboardingComplete') ?? false;
          if (!onboardingComplete) {
            print('Navigating to AppIntroductionScreen from SplashScreen');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const AppIntroductionScreen()),
              (route) => false,
            );
          } else {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              print('Navigating to HomeScreen from SplashScreen');
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              print('Navigating to SignupTypeScreen from SplashScreen');
              Navigator.pushReplacementNamed(context, '/signup-type');
            }
          }
        }
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load splash video: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _initialized
                ? SizedBox(
                    width: 180,
                    height: 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Powered by Connect',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
