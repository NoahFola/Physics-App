// lib/features/modules/data/datasources/abstract_module_local_data_source.dart

import '../../../domain/entities/module_entity.dart';
import '../../../domain/entities/topic_entity.dart';

abstract class ModuleLocalDataSource {
  // Module operations
  Future<List<ModuleEntity>> getModules();
  Future<ModuleEntity?> getModuleById(String id);
  Future<void> updateModuleProgress(String moduleId, double progress);
  
  // Topic operations
  Future<List<Topic>> getModuleTopics(String moduleId);
  Future<void> updateTopicProgress(String topicId, double progress);
  
  // Subtopic operations
  Future<List<Subtopic>> getTopicSubtopics(String topicId);
  Future<void> completeSubtopic(String subtopicId);
  
  // Exercise operations
  Future<bool> submitExerciseAnswer({
    required String exerciseId,
    required int selectedAnswerIndex,
  });
  
  // Progress and statistics
  Future<Map<String, dynamic>> getUserProgressStats();
}