// lib/features/modules/domain/usecases/modules_usecases.dart

import 'package:dartz/dartz.dart';
import '../entities/module_entity.dart';
import '../entities/topic_entity.dart';
import '../../../../core/error/failures.dart';

abstract class GetModulesUseCase {
  Future<Either<Failure, List<ModuleEntity>>> call();
}

abstract class GetModuleByIdUseCase {
  Future<Either<Failure, ModuleEntity>> call(String id);
}

abstract class GetModuleTopicsUseCase {
  Future<Either<Failure, List<Topic>>> call(String moduleId);
}

abstract class UpdateModuleProgressUseCase {
  Future<Either<Failure, void>> call({
    required String moduleId,
    required double progress,
  });
}

abstract class CompleteModuleUseCase {
  Future<Either<Failure, void>> call(String moduleId);
}

abstract class SubmitExerciseAnswerUseCase {
  Future<Either<Failure, bool>> call({
    required String exerciseId,
    required int selectedAnswerIndex,
  });
}