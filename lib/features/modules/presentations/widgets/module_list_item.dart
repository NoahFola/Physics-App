import 'package:flutter/material.dart';
import '../../domain/entities/module_entity.dart';

// Widget for one card on the ModulesListScreen

class ModuleListItem extends StatelessWidget {
  final ModuleEntity module;

  const ModuleListItem({
    super.key,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // --- UPDATED LOGIC ---
    // Determine status based on progress, without a "locked" state
    final String statusText;
    final IconData statusIcon;

    if (module.progress == 1.0) {
      statusText = "Completed";
      statusIcon = Icons.check_circle_outline;
    } else if (module.progress > 0.0) {
      statusText = "In Progress";
      statusIcon = Icons.play_circle_outline;
    } else {
      statusText = "Not Started";
      statusIcon = Icons.play_circle_outline;
    }
    // --- END UPDATED LOGIC ---

    return Card(
      child: InkWell(
        // --- UPDATED LOGIC ---
        // The onTap is now always active, never null
        onTap: () {
          Navigator.pushNamed(
            context,
            '/module',
            arguments: module,
          );
        },
        // --- END UPDATED LOGIC ---
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Icon(
                  // --- UPDATED LOGIC ---
                  // Always show the module icon, never the lock icon
                  Icons.science_outlined, // Example icon
                  // --- END UPDATED LOGIC ---
                  color: Colors.white,
                  size: 28.0,
                ),
              ),
              const SizedBox(height: 16.0),

              // Title
              Text(
                module.title,
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),

              // Description
              Text(
                module.description,
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
              ),
              const SizedBox(height: 20.0),

              // Progress Bar & Percentage
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: LinearProgressIndicator(
                        value: module.progress,
                        minHeight: 10.0,
                        backgroundColor: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    '${(module.progress * 100).toInt()}%',
                    style:
                        textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Status
              Row(
                children: [
                  // --- UPDATED LOGIC ---
                  // Use the new statusIcon and statusText
                  Icon(statusIcon, color: Colors.grey[400], size: 18.0),
                  const SizedBox(width: 8.0),
                  Text(
                    statusText,
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
                  ),
                  // --- END UPDATED LOGIC ---
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}