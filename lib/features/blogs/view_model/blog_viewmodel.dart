import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../data/model/blog_model.dart';
import '../data/repositories/blog_repository.dart';

final blogPostRepositoryProvider = Provider((_) => BlogPostRepository());

final blogPostViewModelProvider = StateNotifierProvider<BlogPostViewModel, List<BlogPost>>((ref) {
  return BlogPostViewModel(ref.read(blogPostRepositoryProvider));
});

class BlogPostViewModel extends StateNotifier<List<BlogPost>> {
  final BlogPostRepository _blogPostRepository;
  BlogPostViewModel(this._blogPostRepository) : super([]);

  Future<void> load() async {
    await _blogPostRepository.getBlogPosts().listen((blogPosts) {
      state = blogPosts;
    });
  }

  Future<void> addBlogPost(BlogPost blogPost) async {
    try {
      await _blogPostRepository.addBlogPost(blogPost);
      state = [...state, blogPost];
      print("Blog post added: ${blogPost.toMap()}");
    } catch (e) {
      print("Error adding blog post: $e");
    }
  }

  Future<void> updateBlogPost(BlogPost blogPost) async {
    try {
      await _blogPostRepository.updateBlogPost(blogPost);
      state = state.map((bp) => bp.id == blogPost.id ? blogPost : bp).toList();
      print("Blog post updated: ${blogPost.title}");
    } catch (e) {
      print("Error updating blog post: $e");
    }
  }

  Future<void> deleteBlogPost(String id) async {
    try {
      await _blogPostRepository.deleteBlogPost(id);
      state = state.where((blogPost) => blogPost.id != id).toList();
      print("Blog post deleted: $id");
    } catch (e) {
      print("Error deleting blog post: $e");
    }
  }
}
