import 'package:connect/features/blogs/view/comments_bottomsheet.dart';
import 'package:flutter/material.dart';


import '../../../core/constants/text_style.dart';
import '../../home/view/home_screen.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({super.key});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  List<UsersProperties> content = [
    UsersProperties(
        name: 'Mansurul Haque',
        topic: 'Why You Need UX In Design?',
        heading: 'Why UX Design Is More Important Then UI Design.',
        subheading:
        'User experience (UX) design is the process design teams use to create products that provide meaningful and relevant experiences to users. This involves the design of the entire process of acquiring and integrating the product, including aspects of branding, design, usability and function.',
        author: 'User Experinces Design !',
        image: 'assets/images/Ellipse 4.png'),
  ];
  bool isImageToggled = false;
  int heartCount = 0;

  void _toggleHeart() {
    setState(() {
      if (isImageToggled) {
        heartCount--;
      } else {
        heartCount++;
      }
      isImageToggled = !isImageToggled;
    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(

      barrierColor: Colors.black.withOpacity(0.8),


      context: context,

      isScrollControlled: true,
      builder: (BuildContext context) {
        return const CustomBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            pinned: true,
            floating: true,
            stretch: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xffD6E5EA))),
                      child: Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                            color: Color(0xff7E7F88),
                          )),
                    ),
                  ),
                ),
                Text(
                  'Blog Post',
                  style: KTextStyle.subtitle1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff17131B),
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return Column(
                            children: [
                              Container(
                                width: 370,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              Container(
                                margin:
                                const EdgeInsets.fromLTRB(8, 100, 8, 10),
                                height: 235,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.white),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 16, 0, 14),
                                  child: Center(
                                    child: Column(children: [
                                      Text('Display Settings',
                                          style: KTextStyle.bottom_sheet1),
                                      const SizedBox(height: 14),
                                      Container(
                                        height: 1,
                                        color: const Color(0xffEFEFEF),
                                      ),
                                      const SizedBox(height: 14),
                                      Text('Follow This Author',
                                          style: KTextStyle.bottom_sheet1),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Container(
                                        height: 1,
                                        color: const Color(0xffEFEFEF),
                                      ),
                                      const SizedBox(height: 14),
                                      Text('Block Author',
                                          style: KTextStyle.bottom_sheet2),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Container(
                                        height: 1,
                                        color: const Color(0xffEFEFEF),
                                      ),
                                      const SizedBox(height: 14),
                                      Text('Report This Blog',
                                          style: KTextStyle.bottom_sheet2),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  height: 58,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white),
                                  child: Center(
                                      child: Text('Cancel',
                                          style: KTextStyle.bottom_sheet1)),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xffD6E5EA)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Image.asset('assets/images/Ellipse 30.png'),
                            const SizedBox(width: 3),
                            Image.asset('assets/images/Ellipse 30.png'),
                            const SizedBox(
                              width: 3,
                            ),
                            Image.asset('assets/images/Ellipse 30.png'),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: content.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        content[index].image,
                                        height: 66,
                                        width: 66,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            content[index].name,
                                            style:
                                            KTextStyle.subtitle1.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xff17131B),
                                              fontSize: 18,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Topic:',
                                                style: KTextStyle.subtitle1
                                                    .copyWith(
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    color: const Color(
                                                        0xff5C5D67),
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                content[index].topic,
                                                style: KTextStyle.subtitle1
                                                    .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                  const Color(0xff17131B),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    content[index].heading,
                                    style: KTextStyle.subtitle1.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff17131B),
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    content[index].subheading,
                                    style: KTextStyle.subtitle1.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff5C5D67),
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                      width: 400,
                                      child: Image.asset(
                                        'assets/images/Rectangle 10.png',
                                      )),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    content[index].author,
                                    style: KTextStyle.subtitle1.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff17131B),
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'User experience design is the process designers use to build products that provide great experiences to their users. UX design refers to feelings and emotions users experience when interacting with a product.',
                                    style: KTextStyle.subtitle1.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff5C5D67),
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      height: 1,
                                      decoration: const BoxDecoration(
                                          color: Color(0xffEAEAEA))),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ]),
                          );
                        }),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _toggleHeart,
                    child: Image.asset(
                      isImageToggled
                          ? 'assets/images/Heart (2).png'
                          : 'assets/images/Heart (1).png',
                      height: 24,
                      width: 24,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    '$heartCount',
                    style: KTextStyle.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff5C5D67),
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            label: 'react',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                _showBottomSheet();
              },
              child: Image.asset('assets/images/Comments.png'),
            ),
            label: 'comment',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
                onTap: (){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Under Development!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                child: Image.asset('assets/images/Share.png')),
            label: 'share',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
                onTap: (){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Under Development!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                child: Image.asset('assets/images/Bookmark.png')),
            label: 'save',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
        KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle:
        KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.normal),
      ),
    );
  }
}

class UsersProperties {
  String name;
  String topic;
  String heading;
  String subheading;
  String author;

  String image;

  UsersProperties(
      {required this.name,
        required this.topic,
        required this.heading,
        required this.subheading,
        required this.author,
        required this.image});
}
