import 'package:flutter/material.dart';


import '../../../core/constants/text_style.dart';

class MentionVisibility extends StatefulWidget {
  final bool isVisibility;
  const MentionVisibility({super.key, required this.isVisibility});

  @override
  State<MentionVisibility> createState() => _MentionVisibilityState();
}

class _MentionVisibilityState extends State<MentionVisibility> {
  List<Properties> component = [
    Properties(
      name: 'Mansurul Haque',
      image: 'assets/images/Ellipse 4 (4).png',
    ),
    Properties(
      name: 'Mahdi Ahmed',
      image: 'assets/images/Ellipse 31 (4).png',
    ),
    Properties(
      name: 'Moinul Haqe',
      image: 'assets/images/Ellipse 32.png',
    ),
    Properties(
      name: 'Mehrajul Islam',
      image: 'assets/images/Ellipse 32 (1).png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.isVisibility,
        child: Container(
            height: 220,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
            ),
            child: ListView.builder(
                itemCount: component.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              component[index].image,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              component[index].name,
                              style: KTextStyle.subtitle1.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff17131B),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                  );
                })));
  }
}

class Properties {
  String name;

  String image;

  Properties({
    required this.name,
    required this.image,
  });
}
