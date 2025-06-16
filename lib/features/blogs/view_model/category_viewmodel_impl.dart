import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryService {
  final _firestore = FirebaseFirestore.instance;
  final _defaultCategories = [
    'Tech',
    'Health',
    'Science',
    'Travel',
    'Education',
    'Lifestyle',
    'Business',
    'Art',
    'Food',
    'Sports'
  ];

  Future<void> initializeCategories() async {
    final categoriesRef = _firestore.collection('categories');
    final categories = await categoriesRef.get();

    if (categories.docs.isEmpty) {
      final batch = _firestore.batch();
      
      for (final category in _defaultCategories) {
        final docRef = categoriesRef.doc(category);
        batch.set(docRef, {
          'name': category,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    }
  }
}

final categoryServiceProvider = Provider((ref) => CategoryService());

// Initialize categories when app starts
final categoryInitializerProvider = FutureProvider<void>((ref) async {
  final categoryService = ref.read(categoryServiceProvider);
  await categoryService.initializeCategories();
});
