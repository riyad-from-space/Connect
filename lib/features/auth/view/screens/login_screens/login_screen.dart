import 'package:connect/core/constants/colours.dart';
import 'package:connect/core/widgets/buttons/submit_button.dart';
import 'package:connect/features/auth/view_model/auth_viewmodel_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/headline.dart';

final isFormValidProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the isFormValidProvider
    final isFormValid = ref.watch(isFormValidProvider);
    final theme = Theme.of(context);

    // Function to check if both fields are filled
    void updateFormValidity() {
      final emailFilled = _emailController.text.isNotEmpty;
      final passwordFilled = _passwordController.text.isNotEmpty;
      ref.read(isFormValidProvider.notifier).state =
          emailFilled && passwordFilled;
    }

    // Add listeners to the controllers
    _emailController.addListener(updateFormValidity);
    _passwordController.addListener(updateFormValidity);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // appBar: AppBar(
      //   backgroundColor: theme.scaffoldBackgroundColor,
      //   elevation: 0,
      //   leading: InkWell(
      //     onTap: () => Navigator.pop(context),
      //     child: const CustomBackButton(),
      //   ),
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Ellipse 1.png',
                        height: 60,
                        width: 60,
                        alignment: Alignment.center,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Headline(
                            headline: 'Login',
                            sub_headline: '',
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Headline(
                    headline: 'Welcome Back',
                    sub_headline: 'Enter your email address and password',
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required.';
                      }
                      final emailRegex =
                          RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid Gmail address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required.';
                      }
                      final passwordRegex = RegExp(
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*#?&]{6,}$',
                      );
                      if (!passwordRegex.hasMatch(value)) {
                        return 'Password must include:\n'
                            '- At least 6 characters\n'
                            '- Uppercase, lowercase, number, and special character.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      SubmitButton(
                        message: 'Please provide both email and password!',
                        isEnabled: isFormValid,
                        onSubmit: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              // Inside your onSubmit or similar function
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .login(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login Successful!'),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              // Navigate to Home page
                              Navigator.pushReplacementNamed(context, '/home');
                            } on FirebaseAuthException catch (e) {
                              String errorMessage =
                                  'An error occurred. Please try again.';

                              if (e.code == 'user-not-found' ||
                                  e.code == 'wrong-password') {
                                errorMessage = 'Invalid credential';
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e is Exception
                                      ? e
                                          .toString()
                                          .replaceAll('Exception: ', '')
                                      : e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please fix the errors in the form.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Don\'t have an account?',
                              style: theme.textTheme.headlineSmall),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/signup');
                            },
                            child: Text('Sign Up',
                                style: theme.textTheme.headlineSmall!.copyWith(
                                  color: KColor.primary,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
