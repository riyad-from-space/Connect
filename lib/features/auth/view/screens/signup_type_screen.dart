import 'package:connect/features/auth/view/screens/login_screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/colours.dart';
import '../../widgets/signup_type_button.dart';

class SignupTypeScreen extends StatefulWidget {
  const SignupTypeScreen({super.key});

  @override
  State<SignupTypeScreen> createState() => _SignupTypeScreenState();
}

class _SignupTypeScreenState extends State<SignupTypeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 154, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/Logo.png',
              height: 50,
              width: 50,
            ),
            const SizedBox(height: 30),
            Text('We Are Preparing Something Great For You!',
                style: theme.textTheme.headlineLarge),
            const SizedBox(height: 30),
            // InkWell(
            //     onTap: () {
            //       Navigator.pushNamed(context, '/signup');
            //     },
            //     child: SignupTypeButton(
            //       background_color: KColor.black,
            //       provider_name: "Apple",
            //       icon: const Icon(
            //         Icons.apple,
            //         color: Colors.white,
            //         size: 30,
            //       ),
            //     )),
            // const SizedBox(height: 30),
            // InkWell(
            //   onTap: () {
            //     Navigator.pushNamed(context, '/signup');
            //   },
            //   child: SignupTypeButton(
            //     background_color: KColor.backgrounforGoogle,
            //     provider_name: "Google",
            //     icon: const Icon(Icons.apple),
            //     isGoogle: true,
            //     image: Image.asset("assets/images/Logo (3).png"),
            //   ),
            // ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: SignupTypeButton(
                background_color: KColor.backgrounforEmail,
                provider_name: "Email",
                icon: const Icon(
                  Icons.email,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Already have an account?',
                    style: theme.textTheme.headlineSmall),
                const SizedBox(width: 2),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(' Log In',
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: KColor.primary,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'By continuing, you accept the Terms Of Use and Privacy Policy.',
              style: theme.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
