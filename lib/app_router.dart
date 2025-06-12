
import 'package:connect/features/auth/view/screens/sign_screens/signup_screen.dart';
import 'package:connect/features/auth/view/screens/signup_type_screen.dart';
import 'package:connect/features/auth/view/screens/user_info_input_screen.dart';
import 'package:connect/features/auth/view/screens/verification_code_screen.dart';
import 'package:connect/features/home/view/home_screen.dart';
import 'package:connect/features/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'features/auth/view/screens/login_screens/login_screen.dart';
import 'features/auth/widgets/auth_checker.dart';
import 'features/blogs/view/screens/feed_screen.dart';
import 'features/blogs/view/screens/post_detail_screen.dart';
import 'features/blogs/view/screens/category_selection_screen.dart';
import 'features/blogs/data/model/blog_model.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/category-selection':
        return MaterialPageRoute(
            builder: (_) => const CategorySelectionScreen());
      case '/feed':
        return MaterialPageRoute(builder: (_) => const FeedScreen());
      case '/post-detail':
        final post = settings.arguments as BlogPost;
        return MaterialPageRoute(builder: (_) => PostDetailScreen(post: post));
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/auth-checker':
        return MaterialPageRoute(builder: (_) => AuthChecker());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case '/signup-type':
        return MaterialPageRoute(builder: (_) => SignupTypeScreen());
      case '/verification-code':
        return MaterialPageRoute(builder: (_) => VerificationCodeScreen());
      case '/user-info':
        return MaterialPageRoute(builder: (_) => UserInfoInputScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => Home());
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
