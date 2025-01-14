// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../../core/constants/text_style.dart';
//
//
// class TopicSelectionScreen extends StatefulWidget {
//   const TopicSelectionScreen({Key? key}) : super(key: key);
//
//   @override
//   State<TopicSelectionScreen> createState() => _TopicSelectionScreenState();
// }
//
// class _TopicSelectionScreenState extends State<TopicSelectionScreen> {
//   final List<String> topicsList = [
//     'UI Design',
//     'UX Design',
//     'Blog Design',
//     'Animation',
//     'Games',
//     'Visual Design',
//     'Motion',
//     'Graphic',
//     '3d',
//     'Icon',
//     'News',
//     'Business',
//     'Sports',
//     'Fashion',
//     'Technology',
//     'Health',
//     'Shoping',
//     'Music',
//     'Video',
//     'Recipe',
//     'Fun',
//     'Entertainment',
//     'Creative',
//   ];
//   List<int> selectedTopicsIndex = [];
//   bool istopic = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Image.asset(
//                   'assets/images/Ellipse 1.png',
//                   height: 40,
//                   width: 40,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const EmailUsername(),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     'Log In',
//                     style: KTextStyle.subtitle1.copyWith(
//                       fontFamily: GoogleFonts.openSans().fontFamily,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                       color: const Color(0xffA76FFF),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Text(
//               'Pick Topic to Start Reading.....',
//               style: KTextStyle.subtitle1.copyWith(
//                 fontFamily: GoogleFonts.openSans().fontFamily,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 30,
//                 color: const Color(0xff17131B),
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Wrap(
//               spacing: 10,
//               runSpacing: 20,
//               children: [
//                 ...List.generate(topicsList.length, (index) {
//                   return Container(
//                     padding: const EdgeInsets.only(
//                         left: 15, right: 15, top: 8, bottom: 8),
//                     decoration: BoxDecoration(
//                       color: selectedTopicsIndex.contains(index)
//                           ? const Color(0xffF4E300)
//                           : const Color(0xffF2F9FB),
//                       border:
//                       Border.all(width: 1, color: const Color(0xffD6E5EA)),
//                       borderRadius: BorderRadius.circular(40),
//                     ),
//                     child: InkWell(
//                       onTap: () {
//                         setState(() {
//                           if (selectedTopicsIndex.contains(index)) {
//                             selectedTopicsIndex.remove(index);
//                           } else {
//                             selectedTopicsIndex.add(index);
//                           }
//                           if (selectedTopicsIndex.isNotEmpty) {
//                             istopic = true;
//                           } else {
//                             istopic = false;
//                           }
//                         });
//                       },
//                       child: Text(
//                         topicsList[index],
//                         style: KTextStyle.subtitle1.copyWith(
//                           fontFamily: GoogleFonts.openSans().fontFamily,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                           color: const Color(0xff17131B),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ],
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             SubmitButton(
//               submit: istopic,
//               onsubmit: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const OnBoarding(),
//                   ),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
