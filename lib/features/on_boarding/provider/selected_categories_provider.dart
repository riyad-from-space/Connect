import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCategoriesProvider =
    StateNotifierProvider<SelectedCategoriesNotifier, List<String>>((ref) {
  return SelectedCategoriesNotifier();
});

class SelectedCategoriesNotifier extends StateNotifier<List<String>> {
  SelectedCategoriesNotifier() : super([]);

  void toggleCategory(String category) {
    if (state.contains(category)) {
      state = state.where((cat) => cat != category).toList();
    } else {
      state = [...state, category];
    }
  }

  void selectOnly(String category) {
    state = [category];
  }

  List<String> getSelectedCategories() {
    return state;
  }
}
