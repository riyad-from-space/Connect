import 'package:flutter/material.dart';


import '../../blogs/view/blog_details.dart';
import '../data/model/blog_model.dart';

class ContentList extends StatelessWidget {
  final List<Properties> contents;

  const ContentList({
    super.key,
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contents.length,
      itemBuilder: (context, index) {
        final content = contents[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PostDetails(),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(content.image),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(content.name),
                      Text('Topic: ${content.topic}'),
                    ],
                  ),
                ],
              ),
              Text(content.heading),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
