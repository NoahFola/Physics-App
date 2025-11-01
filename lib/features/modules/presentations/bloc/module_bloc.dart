// lib/features/modules/presentation/bloc/module_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/module_entity.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/usecases/modules_usecases.dart';

part 'modules_event.dart';
part 'modules_state.dart';

class ModuleBloc extends Bloc<ModuleEvent, ModuleState> {
  final GetModulesUseCase getModulesUseCase;
  final GetModuleByIdUseCase getModuleByIdUseCase;
  final GetModuleTopicsUseCase getModuleTopicsUseCase;
  final UpdateModuleProgressUseCase updateModuleProgressUseCase;
  final CompleteModuleUseCase completeModuleUseCase;
  final SubmitExerciseAnswerUseCase submitExerciseAnswerUseCase;

  ModuleBloc({
    required this.getModulesUseCase,
    required this.getModuleByIdUseCase,
    required this.getModuleTopicsUseCase,
    required this.updateModuleProgressUseCase,
    required this.completeModuleUseCase,
    required this.submitExerciseAnswerUseCase,
  }) : super(ModuleInitial()) {
    on<LoadModulesEvent>(_onLoadModules);
    on<LoadModuleByIdEvent>(_onLoadModuleById);
    on<LoadModuleTopicsEvent>(_onLoadModuleTopics);
    on<UpdateModuleProgressEvent>(_onUpdateModuleProgress);
    on<CompleteModuleEvent>(_onCompleteModule);
    on<SubmitExerciseAnswerEvent>(_onSubmitExerciseAnswer);
  }

  Future<void> _onLoadModules(
    LoadModulesEvent event,
    Emitter<ModuleState> emit,
  ) async {
    emit(ModuleLoading());
    final result = await getModulesUseCase();
    result.fold(
      (failure) => emit(ModuleError(failure.toString())),
      (modules) => emit(ModulesLoaded(modules)),
    );
  }

  Future<void> _onLoadModuleById(
    LoadModuleByIdEvent event,
    Emitter<ModuleState> emit,
  ) async {
    emit(ModuleLoading());
    final result = await getModuleByIdUseCase(event.id);
    result.fold(
      (failure) => emit(ModuleError(failure.toString())),
      (module) => emit(ModuleLoaded(module)),
    );
  }

  Future<void> _onLoadModuleTopics(
    LoadModuleTopicsEvent event,
    Emitter<ModuleState> emit,
  ) async {
    emit(ModuleLoading());
    final result = await getModuleTopicsUseCase(event.moduleId);
    result.fold(
      (failure) => emit(ModuleError(failure.toString())),
      (topics) => emit(ModuleTopicsLoaded(topics)),
    );
  }

  Future<void> _onUpdateModuleProgress(
    UpdateModuleProgressEvent event,
    Emitter<ModuleState> emit,
  ) async {
    final result = await updateModuleProgressUseCase(
      moduleId: event.moduleId,
      progress: event.progress,
    );
    result.fold(
      (failure) => emit(ModuleError(failure.toString())),
      (_) => emit(ModuleProgressUpdated()),
    );
  }

  Future<void> _onCompleteModule(
    CompleteModuleEvent event,
    Emitter<ModuleState> emit,
  ) async {
    final result = await completeModuleUseCase(event.moduleId);
    result.fold(
      (failure) => emit(ModuleError(failure.toString())),
      (_) => emit(ModuleProgressUpdated()),
    );
  }

  Future<void> _onSubmitExerciseAnswer(
    SubmitExerciseAnswerEvent event,
    Emitter<ModuleState> emit,
  ) async {
    final result = await submitExerciseAnswerUseCase(
      exerciseId: event.exerciseId,
      selectedAnswerIndex: event.selectedAnswerIndex,
    );
    result.fold(
      (failure) => emit(ModuleError(failure.toString())),
      (isCorrect) => emit(ExerciseSubmitted(isCorrect)),
    );
  }
}