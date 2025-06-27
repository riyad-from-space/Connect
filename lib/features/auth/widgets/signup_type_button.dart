import 'package:connect/core/constants/colours.dart';
import 'package:flutter/material.dart';

class SignupTypeButton extends StatelessWidget {
  SignupTypeButton(
      {super.key,
      required this.background_color,
      required this.provider_name,
      this.icon,
      this.image,
      this.isGoogle = false});

  String provider_name;
  Color background_color;
  Icon? icon;
  Image? image;
  bool isGoogle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.only(left: 30),
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(120),
        color: background_color,
      ),
      child: Row(
        children: [
          isGoogle ? image! : icon!,
          const SizedBox(width: 20),
          Text('Continue with ',
              style: theme.textTheme.headlineLarge!.copyWith(
                fontSize: 22,
              )),
          const SizedBox(width: 2),
          Text(provider_name,
              style: theme.textTheme.headlineLarge!
                  .copyWith(fontSize: 22, color: KColor.white)),
        ],
      ),
    );
  }
}
