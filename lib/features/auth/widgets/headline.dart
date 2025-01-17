import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/text_style.dart';


class Headline extends StatelessWidget {
  Headline({super.key, required this.headline, required this.sub_headline});

  String headline;
  String sub_headline;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headline, style: KTextStyle.headline),
        Text(sub_headline,style:KTextStyle.sub_headline ,)

      ],
    );
  }
}
