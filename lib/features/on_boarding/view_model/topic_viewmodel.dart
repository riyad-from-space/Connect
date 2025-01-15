import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/topic_model.dart';
import '../data/repositories/topic_repository.dart';

final topicViewModelProvider = StateNotifierProvider<TopicViewModel, List<Topic>>((ref) {
  return TopicViewModel(TopicRepository());
});

class TopicViewModel extends StateNotifier<List<Topic>> {
  final TopicRepository repository;

  TopicViewModel(this.repository) : super([]) {
    loadTopics();
  }

  Future<void> loadTopics() async {
    final topics = await repository.fetchTopics();
    state = topics;
  }

  void toggleTopicSelection(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) Topic(name: state[i].name, isSelected: !state[i].isSelected) else state[i]
    ];
  }
}
