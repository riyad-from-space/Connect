import 'package:flutter/material.dart';

import '../../../core/constants/colours.dart';
import '../../../core/constants/text_style.dart';
import '../widgets/visibility_widget.dart';


class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<CustomBottomSheet> {
  TextEditingController commentController = TextEditingController();
  List<Properties> component = [
    Properties(
        name: 'Adom Shafi',
        topic:
        'This is very usefull blog post, I love this ! Thank You @mansur for this kind of post 😍',
        image: 'assets/images/Ellipse 31.png',
        time: '20 min ago',
        heartCount: 126),
    Properties(
        name: 'Sami Ahmed',
        topic:
        'I alredy read about UX and its makes me improve my design work. Now i can reserch more about UX the UI. Also this post really very helpfull to me. I just learn somthing new about UX 😁👌',
        image: 'assets/images/Ellipse 31 (3).png',
        time: '1 Day ago',
        heartCount: 126),
    Properties(
        name: 'Mahdi Ahmed',
        topic:
        'I alredy read about UX and its makes me improve my design work. Now i can reserch more about UX the UI. Also this post really very helpfull to me. I just learn somthing new about UX.',
        image: 'assets/images/Ellipse 31 (2).png',
        time: '1 Day ago',
        heartCount: 126),
  ];
  List<ReplyProperties> reply = [
    ReplyProperties(
        name: 'Mansurul Haque',
        topic:
        'Thank You @adom_shafi for this kind comments ! Its Mean a lot ❤',
        image: 'assets/images/Ellipse 4 (3).png',
        time: '1 Day ago',
        heartcount: 126),
  ];

  List<bool> isImageToggledList = List.filled(10, false);
  final List<bool> _isImageToggledList = List.filled(10, false);
  bool visible = false;
  bool isvisible = false;
  bool _isvisible = false;

  void _toggleHeart(int index) {
    setState(() {
      if (isImageToggledList[index]) {
        component[index].heartCount--;
      } else {
        component[index].heartCount++;
      }
      isImageToggledList[index] = !isImageToggledList[index];
    });
  }

  void toggleHeart(int index) {
    setState(() {
      if (_isImageToggledList[index]) {
        reply[index].heartcount--;
      } else {
        reply[index].heartcount++;
      }
      _isImageToggledList[index] = !_isImageToggledList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 680,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 3,
                            width: 50,
                            decoration:
                            const BoxDecoration(color: Color(0xffE4E4E9)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: component.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(component[index].image),
                                    const SizedBox(width: 10),
                                    Text(
                                      component[index].name,
                                      style: KTextStyle.subtitle1.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: KColor.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      component[index].time,
                                      style: KTextStyle.subtitle1.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: KColor.ash,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 128),
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                              backgroundColor:
                                              Colors.transparent,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 250,
                                                        width: 370,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(24),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                24),
                                                            color:
                                                            Colors.white),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0, 16, 0, 14),
                                                          child: Center(
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                    'Report This Comment',
                                                                    style: KTextStyle
                                                                        .bottom_sheet2),
                                                                const SizedBox(
                                                                    height: 14),
                                                                Container(
                                                                  height: 1,
                                                                  color: const Color(
                                                                      0xffEFEFEF),
                                                                ),
                                                                const SizedBox(
                                                                    height: 14),
                                                                Text(
                                                                    'Block User',
                                                                    style: KTextStyle
                                                                        .bottom_sheet2),
                                                                const SizedBox(
                                                                    height: 14),
                                                                Container(
                                                                  height: 1,
                                                                  color: const Color(
                                                                      0xffEFEFEF),
                                                                ),
                                                                const SizedBox(
                                                                    height: 14),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'Dismiss',
                                                                      style: KTextStyle
                                                                          .bottom_sheet1),
                                                                ),
                                                                const SizedBox(
                                                                    height: 14),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Image.asset(
                                              'assets/images/Menu.png')),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  component[index].topic,
                                  style: KTextStyle.for_description,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => _toggleHeart(index),
                                      child: Image.asset(
                                        isImageToggledList[index]
                                            ? 'assets/images/Heart (2).png'
                                            : 'assets/images/Heart (1).png',
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${component[index].heartCount}',
                                      style: KTextStyle.subtitle1.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: KColor.ash,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          component[index].isReplyVisible =
                                          !component[index].isReplyVisible;
                                        });
                                      },
                                      child: component[index].isReplyVisible
                                          ? Image.asset(
                                          'assets/images/Comments (4).png')
                                          : Image.asset(
                                          'assets/images/Comments (1).png'),
                                    ),
                                    const SizedBox(width: 118),
                                    Text(
                                      'Reply',
                                      style: KTextStyle.subtitle1.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: KColor.ash,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Visibility(
                                    visible: component[index].isReplyVisible,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 182,
                                          width: 2,
                                          color: const Color(0xffE1E1E1),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(reply[0].image),
                                                const SizedBox(width: 10),
                                                Text(
                                                  reply[0].name,
                                                  style: KTextStyle.subtitle1
                                                      .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: KColor.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  reply[0].time,
                                                  style: KTextStyle.subtitle1
                                                      .copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    color: KColor.ash,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(width: 88),
                                                Image.asset(
                                                    'assets/images/Menu.png'),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            SizedBox(
                                              width: 320,
                                              child: Expanded(
                                                child: Text(
                                                  reply[0].topic,
                                                  style: KTextStyle
                                                      .for_description,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => toggleHeart(0),
                                                  child: Image.asset(
                                                    _isImageToggledList[0]
                                                        ? 'assets/images/Heart (2).png'
                                                        : 'assets/images/Heart (1).png',
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '${reply[0].heartcount}',
                                                  style: KTextStyle.subtitle1
                                                      .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: KColor.ash,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(width: 30),
                                                Image.asset(
                                                    'assets/images/Comments (1).png'),
                                                const SizedBox(width: 110),
                                                Text(
                                                  'Reply',
                                                  style: KTextStyle.subtitle1
                                                      .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: KColor.ash,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 25),
                                            Text(
                                              'See All Reply',
                                              style:
                                              KTextStyle.subtitle1.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff00C922),
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                const SizedBox(height: 30),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MentionVisibility(
                    isVisibility: visible,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1, color: const Color(0xffD4D4D4))),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                      child: TextField(
                        obscureText: false,
                        onChanged: (text) {
                          setState(() {
                            _isvisible = text.isNotEmpty;
                          });
                          if (text.endsWith('@')) {
                            visible = true;
                          } else {
                            visible = false;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: _isvisible
                              ? IconButton(
                            icon:
                            Image.asset('assets/images/Send (1).png'),
                            onPressed: () {
                              commentController.clear();
                            },
                          )
                              : Image.asset('assets/images/Send.png'),
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: ' Write your comment',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Properties {
  String name;
  String topic;
  String image;
  String time;
  int heartCount;
  bool isReplyVisible;

  Properties(
      {required this.name,
        required this.topic,
        required this.image,
        required this.time,
        required this.heartCount,
        this.isReplyVisible = false});
}

class ReplyProperties {
  String name;
  String topic;
  String image;
  String time;
  int heartcount;

  ReplyProperties(
      {required this.name,
        required this.topic,
        required this.image,
        required this.time,
        required this.heartcount});
}
