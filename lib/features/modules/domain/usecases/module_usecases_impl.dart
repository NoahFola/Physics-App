// lib/features/modules/data/usecases/modules_usecases_impl.dart

import 'package:dartz/dartz.dart';
import '../../domain/entities/module_entity.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/repositories/module_repository.dart';
import '../../domain/usecases/modules_usecases.dart';
import '../../../../core/error/failures.dart';

class GetModulesUseCaseImpl implements GetModulesUseCase {
  final AbstractModuleRepository repository;

  const GetModulesUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, List<ModuleEntity>>> call() {
    return repository.getModules();
  }
}

class GetModuleByIdUseCaseImpl implements GetModuleByIdUseCase {
  final AbstractModuleRepository repository;

  const GetModuleByIdUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, ModuleEntity>> call(String id) {
    return repository.getModuleById(id);
  }
}

class GetModuleTopicsUseCaseImpl implements GetModuleTopicsUseCase {
  final AbstractModuleRepository repository;

  const GetModuleTopicsUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, List<Topic>>> call(String moduleId) {
    return repository.getModuleTopics(moduleId);
  }
}

class UpdateModuleProgressUseCaseImpl implements UpdateModuleProgressUseCase {
  final AbstractModuleRepository repository;

  const UpdateModuleProgressUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, void>> call({
    required String moduleId,
    required double progress,
  }) {
    return repository.updateModuleProgress(
      moduleId: moduleId,
      progress: progress,
    );
  }
}

class CompleteModuleUseCaseImpl implements CompleteModuleUseCase {
  final AbstractModuleRepository repository;

  const CompleteModuleUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, void>> call(String moduleId) {
    return repository.completeModule(moduleId);
  }
}

class SubmitExerciseAnswerUseCaseImpl implements SubmitExerciseAnswerUseCase {
  final AbstractModuleRepository repository;

  const SubmitExerciseAnswerUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, bool>> call({
    required String exerciseId,
    required int selectedAnswerIndex,
  }) {
    return repository.submitExerciseAnswer(
      exerciseId: exerciseId,
      selectedAnswerIndex: selectedAnswerIndex,
    );
  }
}