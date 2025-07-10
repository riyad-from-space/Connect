import 'package:connect/core/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/buttons/submit_button.dart';
import '../../../blogs/view_model/blog_viewmodel.dart';
import '../../../blogs/view_model/category_viewmodel.dart';
import '../../provider/onboarding_status_provider.dart';
import '../../provider/selected_categories_provider.dart';

class TopicSelectionScreen extends ConsumerWidget {
  const TopicSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategories = ref.watch(selectedCategoriesProvider);
    final onboardingState = ref.watch(onboardingViewModelProvider);
    final theme = Theme.of(context);

    ref.listen<OnboardingState>(onboardingViewModelProvider, (prev, next) {
      if (next.error != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(onboardingViewModelProvider.notifier).clearError();
      }
      if (next.complete && context.mounted) {
        ref.read(selectedCategoryProvider.notifier).state = 'Trending';
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text('Pick Topic to Start Reading.....',
                  style: theme.textTheme.headlineLarge),
              const SizedBox(height: 30),
              Builder(
                builder: (context) {
                  final categoriesAsync = ref.watch(categoriesProvider);
                  return categoriesAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Error loading categories: $e',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
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
                                ref
                                    .read(selectedCategoriesProvider.notifier)
                                    .toggleCategory(cat);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: selectedCategories.contains(cat)
                                      ? KColor.purpleGradient
                                      : null,
                                  color: selectedCategories.contains(cat)
                                      ? null
                                      : const Color(0xffF2F9FB),
                                  border: Border.all(
                                      width: 1, color: const Color(0xffD6E5EA)),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    color: selectedCategories.contains(cat)
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
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
              if (onboardingState.loading) const CircularProgressIndicator(),
              if (!onboardingState.loading)
                SubmitButton(
                  message: 'Please select at least one topic!',
                  isEnabled: selectedCategories.isNotEmpty,
                  onSubmit: () async {
                    ref
                        .read(onboardingViewModelProvider.notifier)
                        .completeOnboarding(selectedCategories);
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
