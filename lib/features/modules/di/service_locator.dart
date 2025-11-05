import 'package:get_it/get_it.dart';
import '../domain/usecases/modules_usecases.dart';
import '../presentations/bloc/module_bloc.dart';
import '../data/data_sources/local/usecases/local_usecases.dart'; // We will create this
import '../data/data_sources/local/module_local_data_source_impl.dart';

final sl = GetIt.instance; // sl = Service Locator

final localDataSource = ModuleLocalDataSourceImpl();

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
  sl.registerLazySingleton<GetModulesUseCase>(() => GetModulesUseCaseImpl(localDataSource));
  sl.registerLazySingleton<GetModuleByIdUseCase>(() => GetModuleByIdUseCaseImpl(localDataSource));
  sl.registerLazySingleton<GetModuleTopicsUseCase>(() => GetModuleTopicsUseCaseImpl(localDataSource));
  sl.registerLazySingleton<UpdateModuleProgressUseCase>(() => UpdateModuleProgressUseCaseImpl(localDataSource));
  sl.registerLazySingleton<CompleteModuleUseCase>(() => CompleteModuleUseCaseImpl(localDataSource));
  sl.registerLazySingleton<SubmitExerciseAnswerUseCase>(() => SubmitExerciseAnswerUseCaseImpl(localDataSource));
  
  // --- Repository ---
  // Not needed for this mock setup
  
  // --- Data Sources ---
  // Not needed for this mock setup
}
