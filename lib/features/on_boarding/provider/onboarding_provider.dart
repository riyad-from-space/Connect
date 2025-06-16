import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingStatus extends StateNotifier<bool> {
  OnboardingStatus() : super(false) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('seenOnboarding') ?? false;
  }

  Future<void> setComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    state = true;
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', false);
    state = false;
  }
}

final onboardingStatusProvider =
    StateNotifierProvider<OnboardingStatus, bool>((ref) => OnboardingStatus());
