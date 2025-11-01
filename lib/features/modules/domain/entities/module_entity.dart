// lib/features/modules/domain/entities/module_entity.dart

import 'package:newtonium/features/modules/domain/entities/topic_entity.dart';

class ModuleEntity {
  final int id;
  final String title;
  final String description;
  final double progress; // 0.0–1.0 for completion %
  final List<Topic>? topics;

  const ModuleEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    this.topics,
  });
}
