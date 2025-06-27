import 'package:connect/core/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/blog_model.dart';
import '../../view_model/ai_viewmodel.dart';
import '../../../../core/widgets/buttons/back_button.dart';

class BlogAiScreen extends ConsumerStatefulWidget {
  final Blog blog;

  const BlogAiScreen({super.key, required this.blog});

  @override
  ConsumerState<BlogAiScreen> createState() => _BlogAiScreenState();
}

class _BlogAiScreenState extends ConsumerState<BlogAiScreen> {
  bool isSpeaking = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const CustomBackButton(),
        ),
        title:
            const Text('AI Features', style: TextStyle(fontFamily: 'Poppins')),
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
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            // Summary Card
            Card(
              child: ListTile(
                leading: Icon(Icons.summarize, color: Color(0xff9C27B0)),
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
                  color: Color(0xff9C27B0),
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
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? KColor.white
                : KColor.darkSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Summary',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final summaryAsync =
                        ref.watch(blogSummaryProvider(widget.blog.content));

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
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  fontSize: 15,
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
