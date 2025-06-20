import 'package:connect/core/constants/colours.dart';
import 'package:flutter/material.dart';


class SubmitButton extends StatefulWidget {
  final bool isEnabled;
  final Function? onSubmit;
  final String buttonText;
  final String message;


  const SubmitButton({
    super.key,
    required this.isEnabled,
    this.onSubmit,
    this.buttonText = 'Continue',
    required this.message
  });

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: () {
        if (widget.isEnabled && widget.onSubmit != null) {
          widget.onSubmit!();
        }

        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.message),
              backgroundColor: Colors.red,
            ),
          );

        }

      },
      child: Container(
        height: 46,
        width: 290,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          gradient: widget.isEnabled
              ? KColor.purpleGradient
              : null,
          color: widget.isEnabled
              ? null
              : const Color.fromARGB(255, 201, 176, 240),
        ),
        child: Center(
          child: Text(
            widget.buttonText,
            style: theme.textTheme.headlineSmall!.copyWith(
              color: widget.isEnabled ? KColor.white : KColor.black,
            ),
          ),
        ),
      ),
    );
  }
}
