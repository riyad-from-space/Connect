import 'package:connect/features/auth/view/screens/signup_type_screen.dart';
import 'package:connect/features/home/view/home_screen.dart';
import 'package:connect/features/on_boarding/provider/onboarding_status_provider.dart';
import 'package:connect/features/on_boarding/view/screens/topic_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view/screens/login_screens/login_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingStatus = ref.watch(onboardingStatusProvider);
    final theme = Theme.of(context);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If user is logged in
        if (userSnapshot.hasData && userSnapshot.data != null) {
          // If onboarding not seen, show onboarding
          if (!onboardingStatus) {
            return const TopicSelectionScreen();
          } else {
            // If onboarding seen, show home
            return HomeScreen();
          }
        }

        // If not logged in
        if (!onboardingStatus) {
          return SignupTypeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
