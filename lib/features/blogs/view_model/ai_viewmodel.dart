import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/ai_response_model.dart';
import '../data/repositories/ai_service.dart';

final aiServiceProvider = Provider((ref) => AiService());

final blogSummaryProvider =
    FutureProvider.family<AiResponse, String>((ref, text) async {
  final aiService = ref.read(aiServiceProvider);
  return aiService.summarizeText(text);
});

final textToSpeechControllerProvider =
    Provider((ref) => TextToSpeechController(ref));

class TextToSpeechController {
  final Ref _ref;
  bool isPlaying = false;

  TextToSpeechController(this._ref);

  Future<void> speak(String text) async {
    isPlaying = true;
    try {
      await _ref.read(aiServiceProvider).speak(text);
    } catch (e) {
      print('ERROR IN TTS SPEAK: \\${e.toString()}');
      throw Exception('Failed to speak text. Please try again.');
    } finally {
      isPlaying = false;
    }
  }

  Future<void> stop() async {
    isPlaying = false;
    try {
      await _ref.read(aiServiceProvider).stop();
    } catch (e) {
      print('ERROR IN TTS STOP: \\${e.toString()}');
      throw Exception('Failed to stop text-to-speech. Please try again.');
    }
  }
}

class BlogAiState {
  final bool loading;
  final String? error;
  final String? summary;
  final bool ttsPlaying;
  BlogAiState(
      {this.loading = false,
      this.error,
      this.summary,
      this.ttsPlaying = false});

  BlogAiState copyWith(
      {bool? loading, String? error, String? summary, bool? ttsPlaying}) {
    return BlogAiState(
      loading: loading ?? this.loading,
      error: error,
      summary: summary ?? this.summary,
      ttsPlaying: ttsPlaying ?? this.ttsPlaying,
    );
  }
}

final blogAiViewModelProvider =
    StateNotifierProvider<BlogAiViewModel, BlogAiState>((ref) {
  return BlogAiViewModel(ref);
});

class BlogAiViewModel extends StateNotifier<BlogAiState> {
  final Ref ref;
  BlogAiViewModel(this.ref) : super(BlogAiState());

  Future<void> summarize(String text) async {
    state = state.copyWith(loading: true, error: null, summary: null);
    try {
      final aiService = ref.read(aiServiceProvider);
      final response = await aiService.summarizeText(text);
      if (response.error.isNotEmpty) {
        state = state.copyWith(loading: false, error: response.error);
      } else {
        state = state.copyWith(loading: false, summary: response.summary);
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> speak(String text) async {
    state = state.copyWith(ttsPlaying: true, error: null);
    try {
      final aiService = ref.read(aiServiceProvider);
      await aiService.speak(text);
      state = state.copyWith(ttsPlaying: false);
    } catch (e) {
      state = state.copyWith(ttsPlaying: false, error: e.toString());
    }
  }

  Future<void> stopTts() async {
    try {
      final aiService = ref.read(aiServiceProvider);
      await aiService.stop();
      state = state.copyWith(ttsPlaying: false);
    } catch (e) {
      state = state.copyWith(ttsPlaying: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSummary() {
    state = state.copyWith(summary: null);
  }
}
