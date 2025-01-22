import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../data/model/blog_model.dart';




class MockService {
  Future<List<Properties>> fetchContent() async {
    final String response =
    await rootBundle.loadString('assets/demo_jsons/blogs.json');
    final data = json.decode(response) as List;
    return data.map((json) => Properties.fromJson(json)).toList();
  }
}
