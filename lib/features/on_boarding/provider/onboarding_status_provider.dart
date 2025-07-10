import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingStatusProvider =
    StateNotifierProvider<OnboardingStatusNotifier, bool>((ref) {
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

class OnboardingState {
  final bool loading;
  final String? error;
  final bool complete;
  OnboardingState({this.loading = false, this.error, this.complete = false});

  OnboardingState copyWith({bool? loading, String? error, bool? complete}) {
    return OnboardingState(
      loading: loading ?? this.loading,
      error: error,
      complete: complete ?? this.complete,
    );
  }
}

final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, OnboardingState>((ref) {
  return OnboardingViewModel();
});

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  OnboardingViewModel() : super(OnboardingState());

  Future<void> completeOnboarding(List<String> selectedCategories) async {
    if (selectedCategories.isEmpty) {
      state = state.copyWith(error: 'Select at least one topic');
      return;
    }
    state = state.copyWith(loading: true, error: null);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'selectedTopics': selectedCategories});
      // Mark onboarding as complete (local storage)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingComplete', true);
      state = state.copyWith(loading: false, complete: true);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
