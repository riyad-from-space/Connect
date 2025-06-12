import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/category_chip.dart';
import '../../providers/blog_provider.dart';


class CategorySelectionScreen extends ConsumerStatefulWidget {
  const CategorySelectionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState
    extends ConsumerState<CategorySelectionScreen> {
  final Set<String> _selectedCategories = {};
  bool _isLoading = false;

  Future<void> _saveCategories() async {
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one category')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception('User not authenticated');

      // Update to use your AuthController's updateUserCategories method
      await ref.read(authControllerProvider.notifier).updateUserCategories(
            user.uid, // Changed from id to uid to match your UserModel
            _selectedCategories.toList(),
          );

      // Update the selected categories in your blog provider
      ref.read(selectedCategoriesProvider.notifier).state =
          _selectedCategories.toList();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/feed');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save categories: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize selected categories from user's existing selections
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authStateProvider).value;
      if (user != null) {
        setState(() {
          _selectedCategories.addAll(user.selectedTopics);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Your Interests',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose categories that interest you to personalize your feed',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: categories.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                  data: (categories) => SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        final isSelected =
                            _selectedCategories.contains(category.id);
                        return CategoryChip(
                          label: category.name,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedCategories.remove(category.id);
                              } else {
                                _selectedCategories.add(category.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Continue',
                onPressed: _saveCategories,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}