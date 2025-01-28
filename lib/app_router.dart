import 'package:connect/features/auth/view/screens/sign_screens/signup_screen.dart';
import 'package:connect/features/auth/view/screens/signup_type_screen.dart';
import 'package:connect/features/auth/view/screens/user_info_input_screen.dart';
import 'package:connect/features/auth/view/screens/verification_code_screen.dart';
import 'package:connect/features/home/view/home_screen.dart';
import 'package:connect/features/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'features/auth/view/screens/login_screens/login_screen.dart';
import 'features/auth/widgets/auth_checker.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/auth-checker':
        return MaterialPageRoute(builder: (_) => AuthChecker());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
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
          builder: (_) => Scaffold(body: Center(child: Text('Unknown route'))),
        );
    }
  }
}
