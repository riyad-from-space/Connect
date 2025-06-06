import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/blog_repository.dart';
import '../data/model/blog_model.dart';
import '../data/model/category_model.dart';

final blogRepositoryProvider = Provider<BlogRepository>((ref) {
  return BlogRepository();
});

final selectedCategoriesProvider = StateProvider<List<String>>((ref) => []);

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(blogRepositoryProvider).getAllCategories();
});

final filteredBlogsProvider = StreamProvider<List<BlogPost>>((ref) {
  final selectedCategories = ref.watch(selectedCategoriesProvider);
  if (selectedCategories.isEmpty) {
    return Stream.value([]);
  }
  return ref
      .watch(blogRepositoryProvider)
      .getPostsByCategories(selectedCategories);
});

final blogControllerProvider = Provider((ref) {
  return BlogController(ref.watch(blogRepositoryProvider));
});

class BlogController {
  final BlogRepository _blogRepository;

  BlogController(this._blogRepository);

  Future<void> createPost(BlogPost post) async {
    await _blogRepository.createPost(post);
  }

  Future<BlogPost> getPostById(String postId) async {
    return await _blogRepository.getPostById(postId);
  }

  Future<void> createCategory(Category category) async {
    await _blogRepository.createCategory(category);
  }

  Future<List<Category>> getCategoriesByIds(List<String> categoryIds) async {
    return await _blogRepository.getCategoriesByIds(categoryIds);
  }
}
