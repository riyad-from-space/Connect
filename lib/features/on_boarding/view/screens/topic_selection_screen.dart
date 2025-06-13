import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../view_model/topic_viewmodel.dart';
import '../../../../core/constants/text_style.dart';
import '../../../../core/widgets/buttons/submit_button.dart';


class TopicSelectionScreen extends ConsumerWidget {
  const TopicSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(onboardingProvider);

    if (topics.isEmpty) {

      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isAnyTopicSelected = topics.any((topic) => topic.isSelected);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
              
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
    for (int index = 0; index < topics.length; index++)
      InkWell(
        onTap: () {
          ref.read(onboardingProvider.notifier).toggleTopic(topics[index].name); 
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: topics[index].isSelected ? const Color(0xffF4E300) : const Color(0xffF2F9FB),
            border: Border.all(width: 1, color: const Color(0xffD6E5EA)),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Text(
            topics[index].name,
            style: KTextStyle.subtitle1.copyWith(
              fontFamily: GoogleFonts.openSans().fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: const Color(0xff17131B),
            ),
          ),
        ),
      ),
  ],
),

              const SizedBox(height: 40),
              SubmitButton(
                message: 'Please select at least one topic!',
                isEnabled: isAnyTopicSelected,
                onSubmit: () async {
              final selected = ref.read(onboardingProvider.notifier).getSelectedTopics();

              if (selected.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Select at least one topic")),
                );
                return;
              }

              final uid = FirebaseAuth.instance.currentUser!.uid;

              await FirebaseFirestore.instance.collection('users').doc(uid).update({
                'selectedTopics': selected,
              });

              Navigator.pushReplacementNamed(context, '/home'); 
            },
                buttonText: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}



