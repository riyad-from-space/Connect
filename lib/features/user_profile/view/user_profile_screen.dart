import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:connect/features/blogs/view_model/blog_viewmodel.dart';
import 'package:connect/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final userBlogsAsync = ref.watch(userBlogsProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view profile')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    user.firstName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Posts Section
          Expanded(
            child: userBlogsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (blogs) {
                if (blogs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No posts yet',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/create-post'),
                          child: const Text('Create Your First Post'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    final blog = blogs[index];
                    return Dismissible(
                      key: Key(blog.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        ref.read(blogControllerProvider).deleteBlog(blog.id);
                      },
                      child: PostCard(
                        post: blog,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/post-detail',
                            arguments: blog,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}






















// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../../../core/constants/text_style.dart';
// import '../../../core/widgets/buttons/back_button.dart';
// import '../../auth/view/screens/login_screens/login_screen.dart';

// class MyProfile extends StatefulWidget {
//   const MyProfile({Key? key}) : super(key: key);

//   @override
//   State<MyProfile> createState() => _MyProfileState();
// }

// class _MyProfileState extends State<MyProfile> {
//   List<UserProperties> contents = [
//     UserProperties(
//       name: 'End Of The Line For Uber',
//       topic: 'Why Uber Is Gone?',
//       image: 'assets/images/Rectangle 10 (1).png',
//     ),
//     UserProperties(
//       name: 'Building Community....',
//       topic: 'Why Need Better Community?',
//       image: 'assets/images/Rectangle 10 (2).png',
//     ),
//     UserProperties(
//       name: 'Why UX Is More.....',
//       topic: 'Why You Need UX In Design?',
//       image: 'assets/images/Rectangle 10 (1).png',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const CustomBackButton()),
//         title: Text(
//           'riyad007',
//           style: KTextStyle.subtitle1.copyWith(
//             fontWeight: FontWeight.w600,
//             color: const Color(0xff17131B),
//             fontSize: 16,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: screenWidth * 0.05,
//           vertical: screenHeight * 0.02,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   child: Image.asset(
//                     'assets/images/Profile.png',
//                     height: screenHeight * 0.09,
//                     width: screenHeight * 0.09,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Under Development!'),
//                         backgroundColor: Colors.orange,
//                       ),
//                     );
//                   },
//                   child: Column(
//                     children: [
//                       Text(
//                         '20k',
//                         style: KTextStyle.subtitle1.copyWith(
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xff17131B),
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         'Followers',
//                         style: KTextStyle.subtitle1.copyWith(
//                           fontWeight: FontWeight.w400,
//                           color: const Color(0xff5C5D67),
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Under Development!'),
//                         backgroundColor: Colors.orange,
//                       ),
//                     );
//                   },
//                   child: Column(
//                     children: [
//                       Text(
//                         '10',
//                         style: KTextStyle.subtitle1.copyWith(
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xff17131B),
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         'Following',
//                         style: KTextStyle.subtitle1.copyWith(
//                           fontWeight: FontWeight.w400,
//                           color: const Color(0xff5C5D67),
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Under Development!'),
//                         backgroundColor: Colors.orange,
//                       ),
//                     );
//                   },
//                   child: Column(
//                     children: [
//                       Text(
//                         '03',
//                         style: KTextStyle.subtitle1.copyWith(
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xff17131B),
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         'posts',
//                         style: KTextStyle.subtitle1.copyWith(
//                           fontWeight: FontWeight.w400,
//                           color: const Color(0xff5C5D67),
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Riyad Ahmed',
//                         style: KTextStyle.subtitle1.copyWith(
//                           fontWeight: FontWeight.w700,
//                           color: const Color(0xff17131B),
//                           fontSize: 18,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         'App Designer at UI Hut',
//                         style: KTextStyle.subtitle1.copyWith(
//                           fontWeight: FontWeight.w400,
//                           color: const Color(0xff5C5D67),
//                           fontSize: 14,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Under Development!'),
//                           backgroundColor: Colors.orange,
//                         ),
//                       );
//                     },
//                     child: Container(
//                       height: screenHeight * 0.04,
//                       width: screenWidth * 0.25,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(40),
//                         color: const Color(0xffE1E1E1),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'Edit',
//                           style: KTextStyle.subtitle1.copyWith(
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xff17131B),
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: screenWidth * 0.02),
//                 InkWell(
//                   onTap: () async {
//                     await FirebaseAuth.instance.signOut();

//                     // Navigate to login screen and remove all previous routes from the stack
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginScreen()),
//                       (route) => false, // Removes all previous routes
//                     );

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Logged Out!'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   },
//                   child: Container(
//                     height: 34,
//                     width: 104,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(40),
//                       color: Colors.red,
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Log out',
//                         style: KTextStyle.subtitle1.copyWith(
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xff17131B),
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Container(height: 1, color: const Color(0xffEAEAEA)),
//             const SizedBox(height: 20),
//             Text(
//               'POST FROM ADOM',
//               style: KTextStyle.subtitle1.copyWith(
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xff17131B),
//                 fontSize: 16,
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: contents.length,
//                 itemBuilder: (context, index) {
//                   return Dismissible(
//                     key: Key(contents[index].name),
//                     onDismissed: (direction) {
//                       setState(() {
//                         contents.removeAt(index);
//                       });
//                     },
//                     background: Container(
//                         color: Colors.white,
//                         alignment: Alignment.centerRight,
//                         padding: const EdgeInsets.only(right: 20),
//                         child: Image.asset('assets/images/Delete.png')),
//                     child: buildListItem(contents[index]),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildListItem(UserProperties property) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Image.asset(
//                 property.image,
//                 height: 100,
//                 width: 100,
//                 fit: BoxFit.cover,
//               ),
//               const SizedBox(width: 15),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     property.name,
//                     style: KTextStyle.subtitle1.copyWith(
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xff17131B),
//                       fontSize: 18,
//                     ),
//                   ),
//                   Text(
//                     property.topic,
//                     style: KTextStyle.subtitle1.copyWith(
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xff5C5D67),
//                       fontSize: 16,
//                     ),
//                   ),
//                   Text(
//                     'Read Time : 7 min',
//                     style: KTextStyle.subtitle1.copyWith(
//                       fontWeight: FontWeight.w500,
//                       color: const Color(0xff00C922),
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Container(height: 1, color: const Color(0xffEAEAEA)),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// class UserProperties {
//   String name;
//   String topic;
//   String image;

//   UserProperties({
//     required this.name,
//     required this.topic,
//     required this.image,
//   });
// }
