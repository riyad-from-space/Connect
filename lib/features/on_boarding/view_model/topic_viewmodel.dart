import 'package:connect/features/on_boarding/data/models/topic_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final onboardingProvider = StateNotifierProvider<OnboardingViewModel, List<TopicModel>>((ref) {
  return OnboardingViewModel();
});

class OnboardingViewModel extends StateNotifier<List<TopicModel>> {
  OnboardingViewModel() : super([
    TopicModel(name: "Tech"),
    TopicModel(name: "Health"),
    TopicModel(name: "Science"),
    TopicModel(name: "Travel"),
    TopicModel(name: "Education"),
  ]);

  void toggleTopic(String topicName) {
    state = [
      for (final topic in state)
        if (topic.name == topicName)
          TopicModel(name: topic.name, isSelected: !topic.isSelected)
        else
          topic
    ];
  }

  List<String> getSelectedTopics() {
    return state.where((t) => t.isSelected).map((t) => t.name).toList();
  }
}


