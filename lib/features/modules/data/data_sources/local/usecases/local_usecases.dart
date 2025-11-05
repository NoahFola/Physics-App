import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../domain/entities/module_entity.dart';
import '../../../../domain/entities/topic_entity.dart';
import '../../../../domain/usecases/modules_usecases.dart';
import '../module_local_data_source.dart';

class GetModulesUseCaseImpl implements GetModulesUseCase {
  final ModuleLocalDataSource localDataSource;

  GetModulesUseCaseImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<ModuleEntity>>> call() async {
    try {
      final modules = await localDataSource.getModules();
      return Right(modules);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch modules: $e'));
    }
  }
}

class GetModuleByIdUseCaseImpl implements GetModuleByIdUseCase {
  final ModuleLocalDataSource localDataSource;

  GetModuleByIdUseCaseImpl(this.localDataSource);

  @override
  Future<Either<Failure, ModuleEntity>> call(String id) async {
    try {
      final module = await localDataSource.getModuleById(id);
      if (module != null) {
        return Right(module);
      } else {
        return Left(ModuleNotFoundFailure());
      }
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch module: $e'));
    }
  }
}

class GetModuleTopicsUseCaseImpl implements GetModuleTopicsUseCase {
  final ModuleLocalDataSource localDataSource;

  GetModuleTopicsUseCaseImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Topic>>> call(String moduleId) async {
    try {
      final topics = await localDataSource.getModuleTopics(moduleId);
      return Right(topics);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch topics: $e'));
    }
  }
}

class UpdateModuleProgressUseCaseImpl implements UpdateModuleProgressUseCase {
  final ModuleLocalDataSource localDataSource;

  UpdateModuleProgressUseCaseImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> call({
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
      return Left(ModuleProgressUpdateFailure(message: 'Failed to update progress: $e'));
    }
  }
}

class CompleteModuleUseCaseImpl implements CompleteModuleUseCase {
  final ModuleLocalDataSource localDataSource;

  CompleteModuleUseCaseImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> call(String moduleId) async {
    try {
      await localDataSource.updateModuleProgress(moduleId, 1.0);
      return const Right(null);
    } catch (e) {
      return Left(ModuleCompletionFailure(message: 'Failed to complete module: $e'));
    }
  }
}

class SubmitExerciseAnswerUseCaseImpl implements SubmitExerciseAnswerUseCase {
  final ModuleLocalDataSource localDataSource;

  SubmitExerciseAnswerUseCaseImpl(this.localDataSource);

  @override
  Future<Either<Failure, bool>> call({
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
      return Left(DatabaseFailure(message: 'Failed to submit answer: $e'));
    }
  }
}