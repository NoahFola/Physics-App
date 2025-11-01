// lib/features/modules/domain/repositories/abstract_module_repository.dart

import 'package:dartz/dartz.dart';
import '../entities/module_entity.dart';
import '../../../../core/error/failures.dart';
import '../entities/topic_entity.dart';

abstract class AbstractModuleRepository {
  // Get all modules
  Future<Either<Failure, List<ModuleEntity>>> getModules();
  
  // Get a specific module by ID
  Future<Either<Failure, ModuleEntity>> getModuleById(String id);
  
  // Get topics for a specific module
  Future<Either<Failure, List<Topic>>> getModuleTopics(String moduleId);
  
  // Get subtopics for a specific topic
  Future<Either<Failure, List<Subtopic>>> getTopicSubtopics(String topicId);
  
  // Update module progress
  Future<Either<Failure, void>> updateModuleProgress({
    required String moduleId,
    required double progress, // 0.0–1.0
  });
  
  // Update topic progress
  Future<Either<Failure, void>> updateTopicProgress({
    required String topicId,
    required double progress, // 0.0–1.0
  });
  
  // Update subtopic completion status
  Future<Either<Failure, void>> completeSubtopic(String subtopicId);
  
  // Submit exercise answer
  Future<Either<Failure, bool>> submitExerciseAnswer({
    required String exerciseId,
    required int selectedAnswerIndex,
  });
  
  // Mark module as completed (progress = 1.0)
  Future<Either<Failure, void>> completeModule(String moduleId);
  
  // Reset module progress (progress = 0.0)
  Future<Either<Failure, void>> resetModuleProgress(String moduleId);
  
  // Get completed modules
  Future<Either<Failure, List<ModuleEntity>>> getCompletedModules();
  
  // Get modules in progress (progress > 0.0 && < 1.0)
  Future<Either<Failure, List<ModuleEntity>>> getInProgressModules();
  
  // Get next recommended module (based on progress/dependencies)
  Future<Either<Failure, ModuleEntity?>> getNextRecommendedModule();
  
  // Get user's progress statistics
  Future<Either<Failure, Map<String, dynamic>>> getUserProgressStats();
}