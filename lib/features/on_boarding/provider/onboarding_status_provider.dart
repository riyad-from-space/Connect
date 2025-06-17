import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingStatusProvider = StateNotifierProvider<OnboardingStatusNotifier, bool>((ref) {
  return OnboardingStatusNotifier();
});

class OnboardingStatusNotifier extends StateNotifier<bool> {
  OnboardingStatusNotifier() : super(false) {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('onboardingComplete') ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    state = true;
  }

  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', false);
    state = false;
  }
}
