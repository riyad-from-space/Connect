import 'dart:convert';

class AiResponse {
  final String summary;
  final String error;

  AiResponse({
    this.summary = '',
    this.error = '',
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    try {
      final candidates = json['candidates'] as List;
      if (candidates.isEmpty) {
        return AiResponse(error: 'No response from AI');
      }
      
      final content = candidates[0]['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List;
      final text = parts[0]['text'] as String;
      
      return AiResponse(summary: text);
    } catch (e) {
      return AiResponse(error: 'Error parsing AI response: $e');
    }
  }
}
