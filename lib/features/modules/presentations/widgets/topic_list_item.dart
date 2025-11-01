import 'package:flutter/material.dart';
import '../../domain/entities/module_entity.dart';
import '../../domain/entities/topic_entity.dart';

// Enum to manage lesson status
enum TopicStatus { locked, inProgress, completed }

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

    // This variable is no longer needed but safe to keep
    // as `status` will never be `TopicStatus.locked`
    final bool isLocked = status == TopicStatus.locked;

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
        iconData = Icons.play_circle_outline;
        iconColor = Colors.white;
        break;
      case TopicStatus.locked: // This case will no longer be hit
      default:
        iconData = Icons.lock;
        iconColor = Colors.grey[600]!;
        break;
    }

    return Card(
      child: InkWell(
        // --- UPDATED LOGIC ---
        // onTap is now always active because `isLocked` will be false
        onTap: isLocked
            ? null
            : () {
                // Navigate to the lesson content screen
                Navigator.pushNamed(
                  context,
                  '/lesson',
                  arguments: {'topic': topic},
                );
              },
        // --- END UPDATED LOGIC ---
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

              // --- UPDATED LOGIC ---
              // "333" Button (always visible)
              // The `if (!isLocked)` check has been removed.
              const SizedBox(height: 20.0),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 12.0),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.quiz_outlined, size: 20.0),
                  label: const Text('Start quiz'),
                  onPressed: () {
                    // Navigate to the quiz, passing the exercises
                    // from the *first* subtopic of this topic.
                    if (topic.subTopics.isNotEmpty) {
                      Navigator.pushNamed(
                        context,
                        '/quiz',
                        arguments: topic.subTopics.first.exercises,
                      );
                    }
                  },
                  style: Theme.of(context).outlinedButtonTheme.style,
                ),
              ),
              // --- END UPDATED LOGIC ---
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