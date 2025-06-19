import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/ai_service.dart';
import '../data/model/ai_response_model.dart';

final aiServiceProvider = Provider((ref) => AiService());

final blogSummaryProvider = FutureProvider.family<AiResponse, String>((ref, text) async {
  final aiService = ref.read(aiServiceProvider);
  return aiService.summarizeText(text);
});

final textToSpeechControllerProvider = Provider((ref) => TextToSpeechController(ref));

class TextToSpeechController {
  final Ref _ref;
  bool isPlaying = false;

  TextToSpeechController(this._ref);

  Future<void> speak(String text) async {
    isPlaying = true;
    await _ref.read(aiServiceProvider).speak(text);
    isPlaying = false;
  }

  Future<void> stop() async {
    isPlaying = false;
    await _ref.read(aiServiceProvider).stop();
  }
}
