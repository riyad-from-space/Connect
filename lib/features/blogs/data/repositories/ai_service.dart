import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

import '../model/ai_response_model.dart';

class AiService {
  late final String apiKey;
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  late final FlutterTts flutterTts;
  bool _isInitialized = false;
  bool _apiKeyLoaded = false;

  AiService() {
    _initTts();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    try {
      final configString = await rootBundle.loadString('assets/config.json');
      final config = jsonDecode(configString);
      apiKey = config['GEMINI_API_KEY'] ?? '';
      _apiKeyLoaded = true;
    } catch (e) {
      print('Error loading Gemini API key: $e');
      apiKey = '';
      _apiKeyLoaded = false;
    }
  }

  Future<void> _initTts() async {
    try {
      flutterTts = FlutterTts();

      if (Platform.isAndroid) {
        // Set Android TTS engine
        var engines = await flutterTts.getEngines;
        print('Available TTS engines: $engines');

        // Try to use Google TTS engine if available
        if (engines.contains('com.google.android.tts')) {
          await flutterTts.setEngine('com.google.android.tts');
          print('Set Google TTS engine');
        }
      }

      // Get available languages
      final languages = await flutterTts.getLanguages;
      print('Available languages: $languages');

      // Set language
      await flutterTts.setLanguage("en-US");

      // Configure TTS
      await flutterTts.setPitch(1.0);
      await flutterTts.setVolume(1.0);
      await flutterTts.setSpeechRate(0.5);

      // Set handlers for Android
      if (Platform.isAndroid) {
        await flutterTts.awaitSpeakCompletion(true);

        // Set quality
        await flutterTts.setQueueMode(1); // 1 for queued, 0 for flush
        await flutterTts.setSilence(0); // No delay between sentences
      }

      _isInitialized = true;
      print('TTS initialization completed successfully');
    } catch (e) {
      print('Error initializing TTS: $e');
      _isInitialized = false;
    }
  }

  Future<AiResponse> summarizeText(String text) async {
    try {
      if (!_apiKeyLoaded) {
        await _loadApiKey();
      }
      if (apiKey.isEmpty) {
        return AiResponse(error: 'Gemini API key not found.');
      }
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "Please provide a concise summary of this text: $text"}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        return AiResponse.fromJson(jsonDecode(response.body));
      } else {
        return AiResponse(
            error: 'Failed to get summary: ${response.statusCode}');
      }
    } catch (e) {
      return AiResponse(error: 'Error getting summary: $e');
    }
  }

  Future<bool> speak(String text) async {
    if (text.isEmpty) {
      print('Text is empty');
      return false;
    }

    try {
      if (!_isInitialized) {
        await _initTts();
      }

      // Stop any ongoing speech
      await stop();

      // Check if the engine is available
      var isAvailable = await flutterTts.isLanguageAvailable("en-US");
      if (!isAvailable) {
        print('Language not available');
        return false;
      }

      // Set up completion handler
      flutterTts.setCompletionHandler(() {
        print('TTS Completed');
      });

      // Set up error handler
      flutterTts.setErrorHandler((msg) {
        print('TTS Error: $msg');
      });

      // Set up start handler
      flutterTts.setStartHandler(() {
        print('TTS Started');
      });

      print(
          'Starting TTS with text: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');
      var result = await flutterTts.speak(text);
      print('TTS speak result: $result');
      return result == 1;
    } catch (e) {
      print('Error with text to speech: $e');
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await flutterTts.stop();
    } catch (e) {
      print('Error stopping TTS: \\${e.toString()}');
      throw Exception('Failed to stop text-to-speech');
    }
  }
}
