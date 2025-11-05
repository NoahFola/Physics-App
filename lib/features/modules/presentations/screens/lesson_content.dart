import 'package:flutter/material.dart';
import '../../domain/entities/topic_entity.dart';

class LessonScreen extends StatelessWidget {
  final Topic topic;

  const LessonScreen({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    // Direct access - guaranteed non-null due to default value
    final Subtopic subtopic = topic.subTopics;

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              topic.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8.0),
            
            // Lesson Chip
            Chip(
              label: Text('Lesson ${topic.order}'),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              labelStyle: Theme.of(context).chipTheme.labelStyle,
            ),
            const SizedBox(height: 24.0),
            
            // Image Placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Icon(
                Icons.image_outlined,
                size: 60.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24.0),

            // Content Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  subtopic.contentSections.replaceAll('**', ''), // Simple "markdown"
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: subtopic.exercises.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/quiz',
                  arguments: subtopic.exercises,
                );
              },
              icon: const Icon(Icons.quiz_outlined),
              label: const Text('Start Quiz'),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }
}