import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../widgets/custom_button.dart';
import '../data/model/blog_model.dart';
import '../providers/blog_provider.dart';


class BlogAddEditScreen extends ConsumerStatefulWidget {
  final BlogPost? post;

  const BlogAddEditScreen({Key? key, this.post}) : super(key: key);

  @override
  ConsumerState<BlogAddEditScreen> createState() => _BlogAddEditScreenState();
}

class _BlogAddEditScreenState extends ConsumerState<BlogAddEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> selectedCategories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _contentController.text = widget.post!.content;
      selectedCategories = List.from(widget.post!.categories);
    }
  }

  Future<void> _savePost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final post = BlogPost(
        id: widget.post?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        authorId: user.uid, // Changed from id to uid to match UserModel
        authorName: '${user.firstName} ${user.lastName}', // Use full name from UserModel
        categories: selectedCategories,
        createdAt: widget.post?.createdAt ?? DateTime.now(),
      );

      // if (widget.post == null) {
      //   // Create new post
      //   await ref.read(blogControllerProvider.notifier).createPost(post);
      // } else {
      //   // Update existing post
      //   await ref.read(blogControllerProvider.notifier).updatePost(post);
      // }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.post == null ? 'Post created!' : 'Post updated!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Create Post' : 'Edit Post'),
      ),
      body: categories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (availableCategories) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: availableCategories.map((category) {
                  final isSelected = selectedCategories.contains(category.id);
                  return FilterChip(
                    label: Text(category.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedCategories.add(category.id);
                        } else {
                          selectedCategories.remove(category.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: widget.post == null ? 'Create Post' : 'Update Post',
                onPressed: _savePost,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}