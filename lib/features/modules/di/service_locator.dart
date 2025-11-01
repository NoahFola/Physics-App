import 'package:get_it/get_it.dart';
import '../domain/usecases/modules_usecases.dart';
import '../presentations/bloc/module_bloc.dart';
import '../data/data_sources/mocks/mock_usecases.dart'; // We will create this

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // --- BLoC ---
  // The BLoC itself
  sl.registerFactory(
    () => ModuleBloc(
      getModulesUseCase: sl<GetModulesUseCase>(),
      getModuleByIdUseCase: sl(),
      getModuleTopicsUseCase: sl(),
      updateModuleProgressUseCase: sl(),
      completeModuleUseCase: sl(),
      submitExerciseAnswerUseCase: sl(),
    ),
  );

  // --- Use Cases ---
  // Registering the MOCK implementations
  sl.registerLazySingleton<GetModulesUseCase>(() => MockGetModulesUseCase());
  sl.registerLazySingleton<GetModuleByIdUseCase>(() => MockGetModuleByIdUseCase());
  sl.registerLazySingleton<GetModuleTopicsUseCase>(() => MockGetModuleTopicsUseCase());
  sl.registerLazySingleton<UpdateModuleProgressUseCase>(() => MockUpdateModuleProgressUseCase());
  sl.registerLazySingleton<CompleteModuleUseCase>(() => MockCompleteModuleUseCase());
  sl.registerLazySingleton<SubmitExerciseAnswerUseCase>(() => MockSubmitExerciseAnswerUseCase());
  
  // --- Repository ---
  // Not needed for this mock setup
  
  // --- Data Sources ---
  // Not needed for this mock setup
}
