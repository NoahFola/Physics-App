import 'package:flutter/material.dart';
import '../../domain/entities/module_entity.dart';
import '../widgets/topic_list_item.dart';

// Screen from Screenshot: ...164737.jpg
// Displays the list of "Topics" (lessons) for a module

class ModuleDetailScreen extends StatelessWidget {
  final ModuleEntity module;

  const ModuleDetailScreen({
    super.key,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(module.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: (module.topics?.length ?? 0) + 1, // +1 for the "About" card
        itemBuilder: (context, index) {
          print('Building item $index, topics length: ${module.topics?.length}'); // ← ADD THIS
          if (index == 0) {
            return _buildAboutCard(context, module);
          }
          final topic = module.topics?[index - 1];
          print('Topic at index ${index - 1}: $topic'); // ← ADD THIS
          if (topic == null) return const SizedBox.shrink(); // or some fallback
          print('Topic is null, returning empty SizedBox'); // ← ADD THIS

          // --- UPDATED LOGIC ---
          // Determine status based on progress. No more "Locked" state.
          // All lessons are either "Completed" or "In Progress" (and accessible).
          final TopicStatus status;
          if (topic.order <= 2) { // Keeping your demo logic for "completed"
            status = TopicStatus.completed;
          } else {
            // All other topics are now "In Progress" by default
            status = TopicStatus.inProgress;
          }
          // --- END UPDATED LOGIC ---
          
          return TopicListItem(
            topic: topic,
            lessonNumber: index,
            status: status, // Pass the new unlocked status
          );
        },
      ),
    );
  }

  // The "About this module" card
  Widget _buildAboutCard(BuildContext context, ModuleEntity module) {
    return Card(
      color: const Color(0xFF1B3A5E), // Dark blue from screenshot
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.school_outlined,
                size: 28.0, color: Colors.white.withOpacity(0.8)),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About this module",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    module.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}