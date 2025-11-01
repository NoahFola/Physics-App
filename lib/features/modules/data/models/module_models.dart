// lib/features/modules/data/dtos/module_dto.dart

import '../../domain/entities/module_entity.dart';

class ModuleDto {
  final int id;
  final String title;
  final String description;
  final double progress;

  const ModuleDto({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
  });

  // Convert to Entity
  ModuleEntity toEntity() {
    return ModuleEntity(
      id: id,
      title: title,
      description: description,
      progress: progress,
    );
  }

  // Convert from Entity
  factory ModuleDto.fromEntity(ModuleEntity entity) {
    return ModuleDto(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      progress: entity.progress,
    );
  }

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'progress': progress,
    };
  }

  // Convert from SQLite Map
  factory ModuleDto.fromMap(Map<String, dynamic> map) {
    return ModuleDto(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      progress: map['progress'] as double,
    );
  }
}