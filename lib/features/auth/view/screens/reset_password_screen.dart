import 'package:connect/core/widgets/buttons/submit_button.dart';
import 'package:connect/features/auth/view/screens/sign_screens/signup_screen.dart';
import 'package:connect/features/home/view/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/buttons/back_button.dart';

import '../../view_model/auth_viewmodel.dart';
import '../../widgets/headline.dart';


final isFormValidProvider = StateProvider<bool>((ref) => false);

class ResetPasswordScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the isFormValidProvider
    // final isFormValid = ref.watch(isFormValidProvider);
    //
    // // Function to check if both fields are filled
    // void _updateFormValidity() {
    //   final emailFilled = _newPasswordController.text.isNotEmpty;
    //   final passwordFilled = _confirmPasswordController.text.isNotEmpty;
    //   ref.read(isFormValidProvider.notifier).state = emailFilled && passwordFilled;
    // }
    //
    // // Add listeners to the controllers
    // _newPasswordController.addListener(_updateFormValidity);
    // _confirmPasswordController.addListener(_updateFormValidity);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const CustomBackButton(),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                Headline(
                  headline: 'Reset Password',
                  sub_headline: 'Enter your new password',
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),

                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Password is required.';
                  //   }
                  //   final passwordRegex = RegExp(
                  //     r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$',
                  //   );
                  //   if (!passwordRegex.hasMatch(value)) {
                  //     return 'Password must include:\n'
                  //         '- At least 6 characters\n'
                  //         '- Uppercase, lowercase, number, and special character.';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Password is required.';
                  //   }
                  //   final passwordRegex = RegExp(
                  //     r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$',
                  //   );
                  //   if (!passwordRegex.hasMatch(value)) {
                  //     return 'Password must include:\n'
                  //         '- At least 6 characters\n'
                  //         '- Uppercase, lowercase, number, and special character.';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SubmitButton(
                      isEnabled: true,
                      onSubmit: (){
                        Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => Home()),
                                        (route) => false, // Removes all previous routes
                                  );
                      },
                      // onSubmit: () async {
                      //   if (_formKey.currentState!.validate()) {
                      //     try {
                      //       await ref.read(authViewModelProvider).login(
                      //         _newPasswordController.text.trim(),
                      //         _confirmPasswordController.text.trim(),
                      //       );
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(
                      //           content: Text('Sign Up Successful!'),
                      //           backgroundColor: Colors.green,
                      //         ),
                      //       );
                      //       Navigator.pushAndRemoveUntil(
                      //         context,
                      //         MaterialPageRoute(builder: (context) => Home()),
                      //             (route) => false, // Removes all previous routes
                      //       );
                      //     } catch (e) {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         SnackBar(
                      //           content: Text('Error: ${e.toString()}'),
                      //           backgroundColor: Colors.red,
                      //         ),
                      //       );
                      //     }
                      //   } else {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //         content: Text('Please fix the errors in the form.'),
                      //         backgroundColor: Colors.orange,
                      //       ),
                      //     );
                      //   }
                      // },
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
