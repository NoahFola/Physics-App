import 'package:flutter/material.dart';
import '../../domain/entities/module_entity.dart';
import '../../domain/entities/topic_entity.dart';

// Screen from Screenshot: ...164741.jpg
// Displays the content for a lesson (from a Subtopic)

class LessonScreen extends StatelessWidget {
  final Topic topic;

  const LessonScreen({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    // We assume the lesson content is in the *first* subtopic
    // This could be expanded later if a Topic has multiple subtopics (parts)
    final Subtopic? subtopic = topic.subTopics.isNotEmpty ? topic.subTopics.first : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
      body: subtopic == null
          ? const Center(child: Text('No content available.'))
          : SingleChildScrollView(
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
      floatingActionButton: subtopic != null && subtopic.exercises.isNotEmpty
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
