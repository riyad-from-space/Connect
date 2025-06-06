import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/blog_model.dart';
import '../data/repositories/blog_repository.dart';
import '../data/model/category_model.dart';

final blogRepositoryProvider = Provider((_) => BlogRepository());

final blogPostViewModelProvider =
    StateNotifierProvider<BlogPostViewModel, List<BlogPost>>((ref) {
  return BlogPostViewModel(ref.read(blogRepositoryProvider));
});

class BlogPostViewModel extends StateNotifier<List<BlogPost>> {
  final BlogRepository _blogRepository;
  BlogPostViewModel(this._blogRepository) : super([]);

  Future<void> load() async {
    _blogRepository.getPostsByCategories([]).listen((blogPosts) {
      state = blogPosts;
    });
  }

  Future<void> addBlogPost(BlogPost blogPost) async {
    try {
      await _blogRepository.createPost(blogPost);
      state = [...state, blogPost];
      print("Blog post added: ${blogPost.toMap()}");
    } catch (e) {
      print("Error adding blog post: $e");
    }
  }

  Future<void> updateBlogPost(BlogPost blogPost) async {
    try {
      await _blogRepository.createPost(blogPost);
      state = state.map((bp) => bp.id == blogPost.id ? blogPost : bp).toList();
      print("Blog post updated: ${blogPost.title}");
    } catch (e) {
      print("Error updating blog post: $e");
    }
  }

  Future<void> deleteBlogPost(String id) async {
    try {
      await _blogRepository.deletePost(id);
      state = state.where((blogPost) => blogPost.id != id).toList();
      print("Blog post deleted: $id");
    } catch (e) {
      print("Error deleting blog post: $e");
    }
  }

  Future<void> createPost(BlogPost post) async {
    await _blogRepository.createPost(post);
  }

  Stream<List<BlogPost>> getPostsByCategories(List<String> categories) {
    return _blogRepository.getPostsByCategories(categories);
  }

  Future<BlogPost> getPostById(String postId) async {
    return await _blogRepository.getPostById(postId);
  }

  Future<void> createCategory(Category category) async {
    await _blogRepository.createCategory(category);
  }

  Stream<List<Category>> getAllCategories() {
    return _blogRepository.getAllCategories();
  }

  Future<List<Category>> getCategoriesByIds(List<String> categoryIds) async {
    return await _blogRepository.getCategoriesByIds(categoryIds);
  }
}
