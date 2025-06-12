import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../data/models/topic_model.dart';

final topicViewModelProvider = StateNotifierProvider<TopicViewModel, List<Topic>>((ref) {
  return TopicViewModel();
});

class TopicViewModel extends StateNotifier<List<Topic>> {
  TopicViewModel() : super([]) {
    loadTopics();
  }

  Future<void> loadTopics() async {
    final snapshot = await FirebaseFirestore.instance.collection('topics').get();
    final topics = snapshot.docs
        .map((doc) => Topic.fromMap(doc.data(), doc.id))
        .toList();
    state = topics;
  }

  void toggleTopicSelection(int index) {
    final updatedList = [...state];
    updatedList[index].isSelected = !updatedList[index].isSelected;
    state = updatedList;
  }
}
