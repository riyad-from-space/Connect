import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/topic_model.dart';

class TopicRepository {
  Future<List<Topic>> fetchTopics() async {
    final String response = await rootBundle.loadString('assets/demo_jsons/demo_topics.json');
    final data = json.decode(response);
    return (data['topics'] as List).map((name) => Topic.fromJson(name)).toList();
  }
}
