// lib/features/modules/presentation/bloc/module_state.dart


part of 'module_bloc.dart';



@immutable
abstract class ModuleState {}

class ModuleInitial extends ModuleState {}

class ModuleLoading extends ModuleState {}

class ModulesLoaded extends ModuleState {
  final List<ModuleEntity> modules;

  ModulesLoaded(this.modules);
}

class ModuleLoaded extends ModuleState {
  final ModuleEntity module;

  ModuleLoaded(this.module);
}

class ModuleTopicsLoaded extends ModuleState {
  final List<Topic> topics;

  ModuleTopicsLoaded(this.topics);
}

class ModuleProgressUpdated extends ModuleState {}

class ExerciseSubmitted extends ModuleState {
  final bool isCorrect;

  ExerciseSubmitted(this.isCorrect);
}

class ModuleError extends ModuleState {
  final String message;

  ModuleError(this.message);
}