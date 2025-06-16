import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/text_style.dart';
import '../../../../core/widgets/buttons/submit_button.dart';
import '../../provider/selected_categories_provider.dart';
import '../../../blogs/view_model/blog_viewmodel.dart';

class TopicSelectionScreen extends ConsumerWidget {
  const TopicSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategories = ref.watch(selectedCategoriesProvider);

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
              Builder(
                builder: (context) {
                  final categoriesAsync = ref.watch(categoriesProvider);
                  return categoriesAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Error loading categories: $e',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ),
                    data: (categories) {
                      if (categories.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('No categories available'),
                          ),
                        );
                      }
                      return Wrap(
                        spacing: 10,
                        runSpacing: 20,
                        children: [
                          for (final cat in categories)
                            InkWell(
                              onTap: () {
                                ref.read(selectedCategoriesProvider.notifier).toggleCategory(cat);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                decoration: BoxDecoration(
                                  color: selectedCategories.contains(cat)
                                      ? const Color(0xffF4E300)
                                      : const Color(0xffF2F9FB),
                                  border: Border.all(width: 1, color: const Color(0xffD6E5EA)),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Text(
                                  cat,
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
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
              SubmitButton(
                message: 'Please select at least one topic!',
                isEnabled: selectedCategories.isNotEmpty,
                onSubmit: () async {
                  if (selectedCategories.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Select at least one topic")),
                    );
                    return;
                  }

                  final uid = FirebaseAuth.instance.currentUser!.uid;

                  await FirebaseFirestore.instance.collection('users').doc(uid).update({
                    'selectedTopics': selectedCategories,
                  });

                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
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



