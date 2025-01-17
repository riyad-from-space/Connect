
import 'package:connect/features/auth/view/screens/login_screens/login_screen.dart';
import 'package:connect/features/auth/view/screens/signup_type_screen.dart';
import 'package:connect/features/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/text_style.dart';
import '../../../../core/widgets/buttons/submit_button.dart';
import '../../view_model/topic_viewmodel.dart';

class TopicSelectionScreen extends ConsumerWidget {
  const TopicSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicViewModelProvider);
    final isAnyTopicSelected = topics.any((topic) => topic.isSelected);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/Ellipse 1.png',
                  height: 40,
                  width: 40,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Log In',
                    style: KTextStyle.subtitle1.copyWith(
                      fontFamily: GoogleFonts.openSans().fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: const Color(0xffA76FFF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Pick Topic to Start Reading.....',
              style: KTextStyle.subtitle1.copyWith(
                fontFamily: GoogleFonts.openSans().fontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 30,
                color: const Color(0xff17131B),
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 10,
              runSpacing: 20,
              children: [
                ...List.generate(topics.length, (index) {
                  final topic = topics[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: topic.isSelected
                          ? const Color(0xffF4E300)
                          : const Color(0xffF2F9FB),
                      border: Border.all(width: 1, color: const Color(0xffD6E5EA)),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: InkWell(
                      onTap: () {
                        ref.read(topicViewModelProvider.notifier).toggleTopicSelection(index);
                      },
                      child: Text(
                        topic.name,
                        style: KTextStyle.subtitle1.copyWith(
                          fontFamily: GoogleFonts.openSans().fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xff17131B),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 40),
            SubmitButton(
              isEnabled: isAnyTopicSelected, // Ensures the button is enabled only when a topic is selected
              onSubmit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>SignupTypeScreen(),
                  ),
                );
              },
              buttonText: 'Continue', // Optional: you can set this to customize the button text
            ),
          ],
        ),
      ),
    );
  }
}
