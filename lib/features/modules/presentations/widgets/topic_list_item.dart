import 'package:flutter/material.dart';
import '../../domain/entities/topic_entity.dart';

// Enum to manage lesson status
enum TopicStatus { inProgress, completed } // Removed "locked"

// Widget for one card on the ModuleDetailScreen

class TopicListItem extends StatelessWidget {
  final Topic topic;
  final int lessonNumber;
  final TopicStatus status;

  const TopicListItem({
    super.key,
    required this.topic,
    required this.lessonNumber,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    IconData iconData;
    Color iconColor;
    String statusText = "";

    switch (status) {
      case TopicStatus.completed:
        iconData = Icons.check_circle;
        iconColor = Theme.of(context).primaryColor;
        statusText = "Completed";
        break;
      case TopicStatus.inProgress:
      default:
        iconData = Icons.play_circle_outline;
        iconColor = Colors.white;
        break;
    }

    return Card(
      child: InkWell(
        // Always enabled since nothing is locked
        onTap: () {
          Navigator.pushNamed(
            context,
            '/lesson',
            arguments: {'topic': topic},
          );
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status Icon
                  Icon(iconData, color: iconColor, size: 28.0),
                  const SizedBox(width: 16.0),

                  // Title and Lesson info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.title,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            Text(
                              'Lesson $lessonNumber',
                              style: textTheme.bodySmall,
                            ),
                            if (status == TopicStatus.completed)
                              _buildCompletedChip(context, statusText),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Quiz Button (always visible)
              const SizedBox(height: 20.0),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 12.0),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.quiz_outlined, size: 20.0),
                  label: const Text('Start quiz'),
                  onPressed: () {
                    // Navigate to quiz with exercises from the subtopic
                    Navigator.pushNamed(
                      context,
                      '/quiz',
                      arguments: topic.subTopics.exercises, // Direct access to single subtopic
                    );
                  },
                  style: Theme.of(context).outlinedButtonTheme.style,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedChip(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Chip(
        label: Text(text),
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelStyle: Theme.of(context).chipTheme.labelStyle?.copyWith(
              fontSize: 10,
              color: const Color(0xFF69F0AE), // Greenish color
            ),
        backgroundColor: const Color(0xFF69F0AE).withOpacity(0.15),
      ),
    );
  }
}