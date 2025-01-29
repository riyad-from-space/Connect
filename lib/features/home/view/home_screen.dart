import 'package:connect/features/blogs/view_model/blog_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/colours.dart';
import '../../../core/constants/text_style.dart';

import '../../blogs/view/blog_add_edit_screen.dart';
import '../../blogs/view/blog_details.dart';

import '../../user_profile/view/user_profile_screen.dart';

class Home extends ConsumerWidget {
  List<String> itemList = ['UI Design', 'UX Design', 'Visual Design', 'Visual Design', 'Motion'];

  @override
  List<int> selectedTopicsIndex = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogsNotifier = ref.read(blogPostViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      blogsNotifier.load();
    });
    final blogs = ref.watch(blogPostViewModelProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyProfile(),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/Profile.png',
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.12,
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.05,
                    width: screenWidth * 0.10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffD6E5EA)),
                    ),
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Under Development!'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xff7E7F88),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore',
                        style: KTextStyle.subtitle1.copyWith(
                          fontFamily: GoogleFonts.openSans().fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: const Color(0xff17131B),
                        ),
                      ),

                      // SizedBox(
                      //   height: screenHeight * 0.04,
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: itemList.length,
                      //     itemBuilder: (context, index) {
                      //       return Container(
                      //         margin: EdgeInsets.only(right: 5),
                      //         padding: EdgeInsets.symmetric(
                      //             vertical: screenWidth * 0.01, horizontal: screenWidth * 0.03),
                      //         decoration: BoxDecoration(
                      //           color: selectedTopicsIndex.contains(index)
                      //               ? const Color(0xffF4E300)
                      //               : const Color(0xffF2F9FB),
                      //           border: Border.all(width: 1, color: const Color(0xffD6E5EA)),
                      //           borderRadius: BorderRadius.circular(40),
                      //         ),
                      //         child: Center(
                      //           child: InkWell(
                      //             onTap: () {
                      //               setState(() {
                      //                 if (selectedTopicsIndex.contains(index)) {
                      //                   selectedTopicsIndex.remove(index);
                      //                 } else {
                      //                   selectedTopicsIndex.add(index);
                      //                 }
                      //               });
                      //             },
                      //             child: Text(
                      //               itemList[index],
                      //               style: KTextStyle.subtitle1.copyWith(
                      //                   color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      blogs.isEmpty?
                          Center(child: Text("No Blogs Available")):

                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: blogs.length, // Use the list length from the contents
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PostDetails(), // Navigate to PostDetails
                                ),
                              );
                            },
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/images/Ellipse 4.png'),
                                      SizedBox(width: screenWidth * .02),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Riyad Ahmed', // Replace with your desired name if available in the data
                                            style: KTextStyle.subtitle1.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xff17131B),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '30/01/2025', // You may want to replace this with dynamic data if available
                                            style: KTextStyle.subtitle1.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff000000),
                                              fontSize: 12,
                                            ),
                                          ),
                                          // Text(
                                          //   'Topic: Blog Post',
                                          //   style: KTextStyle.subtitle1.copyWith(
                                          //     fontWeight: FontWeight.w700,
                                          //     color: const Color(0xff5C5D67),
                                          //     fontSize: 12,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: screenWidth * .5,
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
                                                      width: 390,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(24),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets.fromLTRB(8, 100, 8, 10),
                                                      height: 235,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(24),
                                                          color: Colors.white),
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 14),
                                                        child: Center(
                                                          child: Column(children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          AddEditBlogPostScreen(
                                                                              blogPost: blogs[index]),
                                                                    ));
                                                              },
                                                              child: Text('Edit Blog',
                                                                  style: KTextStyle.bottom_sheet1),
                                                            ),
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
                                                            // const SizedBox(height: 14),
                                                            // Text('Block Author',
                                                            //     style: KTextStyle.bottom_sheet2),
                                                            // const SizedBox(
                                                            //   height: 14,
                                                            // ),

                                                            const SizedBox(height: 14),
                                                            Text('Report This Blog',
                                                                style: KTextStyle.bottom_sheet2),
                                                            const SizedBox(
                                                              height: 14,
                                                            ),

                                                            Container(
                                                              height: 1,
                                                              color: const Color(0xffEFEFEF),
                                                            ),
                                                            const SizedBox(height: 14),
                                                            GestureDetector(
                                                              onTap: () {
                                                                ref
                                                                    .read(blogPostViewModelProvider.notifier)
                                                                    .deleteBlogPost(blogs[index].id);
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(
                                                                      backgroundColor: Colors.red,
                                                                      content: Text('Blog deleted!')),
                                                                );
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text('Delete Blog',
                                                                  style: KTextStyle.bottom_sheet2),
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
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    blogs[index].title, // This is now heading from the content data
                                    style: KTextStyle.subtitle1.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff17131B),
                                      fontSize: 22,
                                    ),
                                    maxLines: 1,

                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    blogs[index].content, // This is now author/content from the content data
                                    style: KTextStyle.subtitle1.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff17131B),
                                      fontSize: 14,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.fade,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Read Time : 7 min',
                                        style: KTextStyle.subtitle1.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff00C922),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Image.asset('assets/images/Bookmark.png'),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    height: 1,
                                    decoration: const BoxDecoration(color: Color(0xffEAEAEA)),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xffF2F9FB),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/Home.png'),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Under Development!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                child: Ink(
                  child: Image.asset(
                    'assets/images/8666693_search_icon.png',
                    width: screenWidth * 0.06,
                    height: screenHeight * 0.03,
                    color: const Color(0xff5C5D67),
                  ),
                ),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Under Development!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEditBlogPostScreen()),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0xffA76FFF),
                    radius: 30,
                    child: Icon(Icons.add, size: 40, color: Colors.white),
                  ),
                ),
              ),
              label: 'Floating',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Under Development!'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  child: Image.asset('assets/images/Bookmark.png')),
              label: 'Save',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/Path_33946.png'),
              label: 'Settings',
            ),
          ],
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
