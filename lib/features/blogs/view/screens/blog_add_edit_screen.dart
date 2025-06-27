import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/core/widgets/buttons/back_button.dart';
import 'package:connect/core/widgets/buttons/submit_button.dart';
import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:connect/features/blogs/view_model/blog_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/model/blog_model.dart';

class BlogAddEditScreen extends ConsumerStatefulWidget {
  final Blog? post;

  const BlogAddEditScreen({super.key, this.post});

  @override
  ConsumerState<BlogAddEditScreen> createState() => _BlogAddEditScreenState();
}

class _BlogAddEditScreenState extends ConsumerState<BlogAddEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _contentController.text = widget.post!.content;
      selectedCategory = widget.post!.category;
    }
  }

  Future<void> _savePost() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final post = Blog(
        id: widget.post?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: selectedCategory!,
        authorId: user.uid,
        authorName: '${user.firstName} ${user.lastName}',
        createdAt: widget.post?.createdAt ?? Timestamp.now(),
      );

      if (widget.post == null) {
        await ref.read(blogControllerProvider).createBlog(post);
      } else {
        await ref.read(blogControllerProvider).updateBlog(post);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(widget.post == null ? 'Post created!' : 'Post updated!'),
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
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const CustomBackButton(),
        ),
        title: Text(widget.post == null ? 'Create Post' : 'Edit Post'),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (categories) => Form(
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
                'Select Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: categories.map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    selected: category == selectedCategory,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = selected ? category : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SubmitButton(
                buttonText: widget.post == null ? 'Create Post' : 'Update Post',
                onSubmit: _savePost,
                isEnabled: !_isLoading,
                message: '',
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
