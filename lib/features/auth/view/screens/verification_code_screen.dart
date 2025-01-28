import 'dart:async';
import 'package:connect/features/auth/view/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/widgets/buttons/back_button.dart';
import '../../../../core/widgets/buttons/submit_button.dart';
import '../../widgets/headline.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  String? _code;
  int _remainingSeconds = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSubmitEnabled = _code != null && _code!.length == 4 && _remainingSeconds > 0;

    return Scaffold(
      // appBar: AppBar(
      //   leading: InkWell(
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //     child: const CustomBackButton(),
      //   ),
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
          child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Headline(
                headline: 'Verification Code',
                sub_headline: 'We sent a code to helloriyad@gmail.com',
              ),
              const SizedBox(height: 50),
              Center(
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  onChanged: (String value) {
                    setState(() {
                      _code = value;
                    });
                  },
                  onCompleted: (String value) {},
                  enablePinAutofill: false,
                  autoFocus: true,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).primaryColor),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.circle,
                    activeColor: Colors.yellow,
                    fieldHeight: 70,
                    fieldWidth: 70,
                    inactiveColor: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  ' Resend In $_remainingSeconds ',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: SubmitButton(
                  isEnabled: true,
                  onSubmit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResetPasswordScreen())

                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
