import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/blog_model.dart';
import '../../view_model/ai_viewmodel.dart';

class BlogAiScreen extends ConsumerStatefulWidget {
  final Blog blog;

  const BlogAiScreen({Key? key, required this.blog}) : super(key: key);

  @override
  ConsumerState<BlogAiScreen> createState() => _BlogAiScreenState();
}

class _BlogAiScreenState extends ConsumerState<BlogAiScreen> {
  bool isSpeaking = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Features', style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blog Title
            Text(
              widget.blog.title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            
            // AI Features
            Text(
              'AI Features',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            
            // Summary Card
            Card(
              child: ListTile(
                leading: Icon(Icons.summarize, color: colorScheme.primary),
                title: const Text('Get Summary'),
                subtitle: const Text('AI-powered blog summary'),
                onTap: () => _showSummary(context),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Text to Speech Card
            Card(
              child: ListTile(
                leading: Icon(
                  isSpeaking ? Icons.stop_circle : Icons.record_voice_over,
                  color: colorScheme.primary,
                ),
                title: Text(isSpeaking ? 'Stop Reading' : 'Read Aloud'),
                subtitle: const Text('Convert blog to speech'),
                onTap: () => _toggleSpeech(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSummary(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Summary',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final summaryAsync = ref.watch(
                      blogSummaryProvider(widget.blog.content)
                    );
                    
                    return summaryAsync.when(
                      data: (response) {
                        if (response.error.isNotEmpty) {
                          return Center(
                            child: Text('Error: ${response.error}'),
                          );
                        }
                        return SingleChildScrollView(
                          controller: controller,
                          child: Text(
                            response.summary,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stack) => Center(
                        child: Text('Error: $error'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleSpeech(BuildContext context) async {
    final ttsController = ref.read(textToSpeechControllerProvider);
    
    setState(() {
      isSpeaking = !isSpeaking;
    });

    if (isSpeaking) {
      await ttsController.speak(widget.blog.content);
    } else {
      await ttsController.stop();
    }
  }

  @override
  void dispose() {
    ref.read(textToSpeechControllerProvider).stop();
    super.dispose();
  }
}
