import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/blog_model.dart';
import '../view_model/blog_viewmodel.dart';

class AddEditBlogPostScreen extends ConsumerStatefulWidget {
  final BlogPost? blogPost;

  const AddEditBlogPostScreen({Key? key, this.blogPost}) : super(key: key);

  @override
  ConsumerState<AddEditBlogPostScreen> createState() => _AddEditBlogPostScreenState();
}

class _AddEditBlogPostScreenState extends ConsumerState<AddEditBlogPostScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final Color primaryColor = Color(0xffA76FFF).withOpacity(.8);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blogPost?.title ?? '');
    _contentController = TextEditingController(text: widget.blogPost?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveBlogPost() {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Title or Content cannot be empty!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return; // Stop execution
    }

    final newBlogPost = BlogPost(
      id: widget.blogPost?.id ?? DateTime.now().toString(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      createdAt: widget.blogPost?.createdAt ?? DateTime.now(),
    );

    if (widget.blogPost == null) {
      ref.read(blogPostViewModelProvider.notifier).addBlogPost(newBlogPost);
    } else {
      ref.read(blogPostViewModelProvider.notifier).updateBlogPost(newBlogPost);
    }

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Connect',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: primaryColor,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                widget.blogPost == null ? 'Create a New Blog Post' : 'Edit Your Blog Post',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildTextField(_titleController, 'Title'),
              const SizedBox(height: 20),
              _buildTextField(_contentController, 'Content', maxLines: 10),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveBlogPost,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  widget.blogPost == null ? 'Add Blog Post' : 'Update Blog Post',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,  {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
