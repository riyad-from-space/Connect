import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/buttons/back_button.dart';
import '../../data/model/blog_model.dart';
import '../../view_model/ai_viewmodel.dart';

class BlogAiScreen extends ConsumerStatefulWidget {
  final Blog blog;

  const BlogAiScreen({super.key, required this.blog});

  @override
  ConsumerState<BlogAiScreen> createState() => _BlogAiScreenState();
}

class _BlogAiScreenState extends ConsumerState<BlogAiScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final blogAiState = ref.watch(blogAiViewModelProvider);

    ref.listen<BlogAiState>(blogAiViewModelProvider, (prev, next) {
      if (next.error != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('AI Error: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(blogAiViewModelProvider.notifier).clearError();
      }
    });

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
                  blogAiState.ttsPlaying
                      ? Icons.stop_circle
                      : Icons.record_voice_over,
                  color: Color(0xff9C27B0),
                ),
                title: Text(
                    blogAiState.ttsPlaying ? 'Stop Reading' : 'Read Aloud'),
                subtitle: const Text('Convert blog to speech'),
                onTap: () => _toggleSpeech(context),
              ),
            ),
            if (blogAiState.loading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  void _showSummary(BuildContext context) {
    ref.read(blogAiViewModelProvider.notifier).summarize(widget.blog.content);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Consumer(
          builder: (context, ref, child) {
            final blogAiState = ref.watch(blogAiViewModelProvider);
            if (blogAiState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (blogAiState.error != null) {
              return Center(child: Text('Error: ${blogAiState.error}'));
            }
            if (blogAiState.summary != null) {
              return SingleChildScrollView(
                controller: controller,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    blogAiState.summary!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 15,
                        ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _toggleSpeech(BuildContext context) async {
    final blogAiState = ref.read(blogAiViewModelProvider);
    if (blogAiState.ttsPlaying) {
      await ref.read(blogAiViewModelProvider.notifier).stopTts();
    } else {
      await ref
          .read(blogAiViewModelProvider.notifier)
          .speak(widget.blog.content);
    }
  }

  @override
  void dispose() {
    ref.read(blogAiViewModelProvider.notifier).stopTts();
    super.dispose();
  }
}
