import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/text_style.dart';


class Headline extends StatelessWidget {
  Headline({super.key, required this.headline, required this.sub_headline});

  String headline;
  String? sub_headline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headline, style: theme.textTheme.headlineLarge),
        Text(sub_headline!,style:theme.textTheme.headlineSmall,)

      ],
    );
  }
}
