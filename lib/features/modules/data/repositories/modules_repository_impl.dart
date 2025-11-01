// lib/features/modules/data/repositories/modules_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../domain/entities/module_entity.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/repositories/module_repository.dart';
import '../../../../core/error/failures.dart';
import '../data_sources/local/module_local_data_source.dart';

class ModulesRepositoryImpl implements AbstractModuleRepository {
  final ModuleLocalDataSource localDataSource;

  const ModulesRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<ModuleEntity>>> getModules() async {
    try {
      final modules = await localDataSource.getModules();
      return Right(modules);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to get modules: $e'));
    }
  }

  @override
  Future<Either<Failure, ModuleEntity>> getModuleById(String id) async {
    try {
      final module = await localDataSource.getModuleById(id);
      if (module != null) {
        return Right(module);
      } else {
        return Left(ModuleNotFoundFailure());
      }
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to get module: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Topic>>> getModuleTopics(String moduleId) async {
    try {
      final topics = await localDataSource.getModuleTopics(moduleId);
      return Right(topics);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to get module topics: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Subtopic>>> getTopicSubtopics(String topicId) async {
    try {
      final subtopics = await localDataSource.getTopicSubtopics(topicId);
      return Right(subtopics);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to get topic subtopics: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateModuleProgress({
    required String moduleId,
    required double progress,
  }) async {
    try {
      if (progress < 0.0 || progress > 1.0) {
        return Left(InvalidProgressValueFailure());
      }

      await localDataSource.updateModuleProgress(moduleId, progress);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to update module progress: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTopicProgress({
    required String topicId,
    required double progress,
  }) async {
    try {
      if (progress < 0.0 || progress > 1.0) {
        return Left(InvalidProgressValueFailure());
      }

      await localDataSource.updateTopicProgress(topicId, progress);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to update topic progress: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> completeSubtopic(String subtopicId) async {
    try {
      await localDataSource.completeSubtopic(subtopicId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to complete subtopic: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> submitExerciseAnswer({
    required String exerciseId,
    required int selectedAnswerIndex,
  }) async {
    try {
      final isCorrect = await localDataSource.submitExerciseAnswer(
        exerciseId: exerciseId,
        selectedAnswerIndex: selectedAnswerIndex,
      );
      return Right(isCorrect);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to submit exercise: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> completeModule(String moduleId) async {
    try {
      await localDataSource.updateModuleProgress(moduleId, 1.0);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to complete module: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetModuleProgress(String moduleId) async {
    try {
      await localDataSource.updateModuleProgress(moduleId, 0.0);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to reset module progress: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ModuleEntity>>> getCompletedModules() async {
    try {
      final allModules = await localDataSource.getModules();
      final completedModules = allModules.where((module) => module.progress == 1.0).toList();
      return Right(completedModules);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to get completed modules: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ModuleEntity>>> getInProgressModules() async {
    try {
      final allModules = await localDataSource.getModules();
      final inProgressModules = allModules.where((module) => 
        module.progress > 0.0 && module.progress < 1.0
      ).toList();
      return Right(inProgressModules);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to get in-progress modules: $e'));
    }
  }

  @override
  Future<Either<Failure, ModuleEntity?>> getNextRecommendedModule() async {
    try {
      final allModules = await localDataSource.getModules();
      
      // Find first module that's not completed
      for (final module in allModules) {
        if (module.progress < 1.0) {
          return Right(module);
        }
      }
      
      // If all modules are completed, return null
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to get recommended module: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserProgressStats() async {
    try {
      final stats = await localDataSource.getUserProgressStats();
      return Right(stats);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to get user progress stats: $e'));
    }
  }
}