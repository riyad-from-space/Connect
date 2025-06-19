import 'package:flutter/material.dart';

class AiFeaturesButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  final Color? color;

  const AiFeaturesButton({
    Key? key,
    required this.onPressed,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonColor = color ?? colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: 'AI Features',
        child: IconButton(
          icon: Icon(
            Icons.auto_awesome,
            color: buttonColor,
            size: size,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
