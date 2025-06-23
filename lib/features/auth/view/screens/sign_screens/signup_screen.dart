import 'package:connect/core/constants/colours.dart';
import 'package:connect/core/widgets/buttons/submit_button.dart';
import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:connect/features/auth/view/screens/login_screens/login_screen.dart';
import 'package:connect/features/auth/widgets/headline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final isFormValidProvider = StateProvider<bool>((ref) => false);

class SignupScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFormValid = ref.watch(isFormValidProvider);
        final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    void _updateFormValidity() {
      final firstNameFilled = _firstNameController.text.isNotEmpty;
      final lastNameFilled = _lastNameController.text.isNotEmpty;
      final usernameFilled = _usernameController.text.isNotEmpty;
      final emailFilled = _emailController.text.isNotEmpty;
      final passwordFilled = _passwordController.text.isNotEmpty;
      ref.read(isFormValidProvider.notifier).state =
          firstNameFilled && lastNameFilled && usernameFilled && emailFilled && passwordFilled;
    }

    _firstNameController.addListener(_updateFormValidity);
    _lastNameController.addListener(_updateFormValidity);
    _usernameController.addListener(_updateFormValidity);
    _emailController.addListener(_updateFormValidity);
    _passwordController.addListener(_updateFormValidity);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left:16, right: 16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            headline: 'Signup',
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
                    headline: 'Welcome To Connect',
                    sub_headline: 'Enter your details to create an account',
                  ),
                  const SizedBox(height: 20),
                  // Add your text fields here
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required.';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required.';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required.';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters.';
                      }
                      return null;
                    },
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
                      // Debug print for diagnosis
                      print('Validating email: ' + value);
                      // More robust email regex
                      final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}");
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address.';
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
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$',
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
                        message: 'Please fill in all fields!',
                        isEnabled: isFormValid,
                        onSubmit: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await ref.read(authControllerProvider.notifier).register(
                                firstName: _firstNameController.text.trim(),
                                lastName: _lastNameController.text.trim(),
                                username: _usernameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Sign Up Successful! Please check your email for a verification link.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
              
                              Navigator.pushReplacementNamed(context, '/category-selection');
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e
                                      .toString()
                                      .replaceAll('Exception: ', '')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                Text('Please fix the errors in the form.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Already have an account?',
                  style: theme.textTheme.headlineSmall
                ),
                const SizedBox(width: 2),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    ' Log In',
                     style: theme.textTheme.headlineSmall!.copyWith(
                      color: KColor.primary,
                      fontWeight: FontWeight.w700,)
                  ),
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

