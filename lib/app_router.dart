import 'package:connect/features/auth/view/screens/sign_screens/signup_screen.dart';
import 'package:connect/features/auth/view/screens/signup_type_screen.dart';
import 'package:connect/features/auth/view/screens/verification_code_screen.dart';
import 'package:connect/features/auth/view/screens/login_screens/login_screen.dart';
import 'package:connect/features/auth/widgets/auth_checker.dart';
import 'package:connect/features/blogs/data/model/blog_model.dart';
import 'package:connect/features/blogs/view/blog_add_edit_screen.dart';
import 'package:connect/features/blogs/view/screens/post_detail_screen.dart';
import 'package:connect/features/home/view/home_screen.dart';
import 'package:connect/features/settings/view/settings_screen.dart';
import 'package:connect/features/splash_screen/splash_screen.dart';
import 'package:connect/features/user_profile/view/user_profile_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        // Start with SplashScreen, which should navigate to AuthChecker after loading
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/auth-checker':
        return MaterialPageRoute(builder: (_) => AuthChecker());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case '/signup-type':
        return MaterialPageRoute(builder: (_) => SignupTypeScreen());
      case '/verification-code':
        return MaterialPageRoute(builder: (_) => VerificationCodeScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/user-profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      // Blog Routes
      case '/create-post':
        return MaterialPageRoute(builder: (_) => const BlogAddEditScreen());
      
      case '/edit-post':
        final post = settings.arguments as Blog;
        return MaterialPageRoute(builder: (_) => BlogAddEditScreen(post: post));

      case '/post-detail':
        final post = settings.arguments as Blog;
        return MaterialPageRoute(builder: (_) => PostDetailScreen(post: post));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
