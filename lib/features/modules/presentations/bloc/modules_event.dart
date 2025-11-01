// lib/features/modules/presentation/bloc/module_event.dart

part of 'module_bloc.dart';

@immutable
abstract class ModuleEvent {}

class LoadModulesEvent extends ModuleEvent {}

class LoadModuleByIdEvent extends ModuleEvent {
  final String id;

  LoadModuleByIdEvent(this.id);
}

class LoadModuleTopicsEvent extends ModuleEvent {
  final String moduleId;

  LoadModuleTopicsEvent(this.moduleId);
}

class UpdateModuleProgressEvent extends ModuleEvent {
  final String moduleId;
  final double progress;

  UpdateModuleProgressEvent({
    required this.moduleId,
    required this.progress,
  });
}

class CompleteModuleEvent extends ModuleEvent {
  final String moduleId;

  CompleteModuleEvent(this.moduleId);
}

class SubmitExerciseAnswerEvent extends ModuleEvent {
  final String exerciseId;
  final int selectedAnswerIndex;

  SubmitExerciseAnswerEvent({
    required this.exerciseId,
    required this.selectedAnswerIndex,
  });
}