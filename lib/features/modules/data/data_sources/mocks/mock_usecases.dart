  // import 'package:dartz/dartz.dart';
  // import '../../../../../core/error/failures.dart';
  // import '../../../domain/entities/module_entity.dart';
  // import '../../../domain/entities/topic_entity.dart';
  // import '../../../domain/usecases/modules_usecases.dart';

  // // --- MOCK DATA ---
  // // This is the data that will be fed into the BLoC

  // final _exercises1 = [
  //   Exercise(
  //     id: 'ex1-1',
  //     question: 'What is the difference between displacement and distance?',
  //     options: [
  //       'Displacement is always greater than distance',
  //       'Distance is always greater than displacement',
  //       'Displacement is a vector, distance is a scalar',
  //       'There is no difference between them',
  //     ],
  //     correctAnswerIndex: 2,
  //     explanation: 'Displacement is a vector quantity (magnitude and direction), while distance is a scalar quantity (magnitude only).',
  //   ),
  //   Exercise(
  //     id: 'ex1-2',
  //     question: 'In physics, what does the term "position" refer to?',
  //     options: [
  //       'The speed of an object',
  //       'Where an object is located',
  //       'The direction of motion',
  //       'The acceleration of an object',
  //     ],
  //     correctAnswerIndex: 1,
  //     explanation: 'Position refers to the specific location of an object in a coordinate system.',
  //   ),
  //   Exercise(
  //     id: 'ex1-3',
  //     question: 'What is a scalar quantity?',
  //     options: [
  //       'A quantity with magnitude only',
  //       'A quantity with direction only',
  //       'A quantity with both magnitude and direction',
  //       'A quantity that never changes',
  //     ],
  //     correctAnswerIndex: 0,
  //     explanation: 'A scalar quantity is defined by its magnitude alone (e.g., distance, speed, mass).',
  //   ),
  // ];

  // final _subtopic1 = Subtopic(
  //   id: 'st1',
  //   topicId: 't1',
  //   title: 'Introduction to Motion',
  //   order: 1,
  //   contentSections: """
  // Motion is the change in position of an object with respect to time. In physics, we study motion to understand how objects move and what causes them to move.

  // **Key Concepts:**
  // • **Position:** Where an object is located
  // • **Displacement:** Change in position (vector quantity)
  // • **Distance:** Total path length (scalar quantity)
  // • **Time:** Duration of motion

  // **Types of Motion:**
  // • **Uniform Motion:** Constant velocity (zero acceleration)
  // • **Non-uniform Motion:** Velocity changes over time (non-zero acceleration)
  // """,
  //   exercises: _exercises1,
  // );

  // final _subtopic2 = Subtopic(
  //   id: 'st2',
  //   topicId: 't2',
  //   title: 'Speed and Velocity',
  //   order: 1,
  //   contentSections: "...",
  //   exercises: [], // Assuming this quiz isn't built yet
  // );

  // final _subtopic3 = Subtopic(
  //   id: 'st3',
  //   topicId: 't3',
  //   title: 'Acceleration',
  //   order: 1,
  //   contentSections: "...",
  //   exercises: [],
  // );

  // final _subtopic4 = Subtopic(
  //   id: 'st4',
  //   topicId: 't4',
  //   title: 'Equations of Motion',
  //   order: 1,
  //   contentSections: "...",
  //   exercises: [],
  // );

  // final _topics1 = [
  //   Topic(
  //     id: 't1',
  //     moduleCode: 'M1',
  //     title: 'Introduction to Motion',
  //     order: 1,
  //     subTopics: [_subtopic1], // Each Topic holds its Subtopic content
  //   ),
  //   Topic(
  //     id: 't2',
  //     moduleCode: 'M1',
  //     title: 'Speed and Velocity',
  //     order: 2,
  //     subTopics: [_subtopic2],
  //   ),
  //   Topic(
  //     id: 't3',
  //     moduleCode: 'M1',
  //     title: 'Acceleration',
  //     order: 3,
  //     subTopics: [_subtopic3],
  //   ),
  //   Topic(
  //     id: 't4',
  //     moduleCode: 'M1',
  //     title: 'Equations of Motion',
  //     order: 4,
  //     subTopics: [_subtopic4],
  //   ),
  // ];

  // final _module1 = ModuleEntity(
  //   id: 1,
  //   title: 'Motion & Kinematics',
  //   description: 'Learn the fundamentals of motion, displacement, velocity, and acceleration',
  //   progress: 0.5, // 50%
  //   topics: _topics1,
  // );

  // final _module2 = ModuleEntity(
  //   id: 2,
  //   title: 'Forces & Dynamics',
  //   description: 'Understand Newton\'s laws and how forces affect motion',
  //   progress: 0.0, // 0%
  //   topics: [], // Not yet populated
  // );

  // final List<ModuleEntity> _mockModules = [_module1, _module2];

  // // --- MOCK USE CASE IMPLEMENTATIONS ---
  // // These classes satisfy the BLoC's dependencies and return
  // // the mock data above, wrapped in `Either` and `Future`.

  // class MockGetModulesUseCase implements GetModulesUseCase {
  //   @override
  //   Future<Either<Failure, List<ModuleEntity>>> call() async {
  //     await Future.delayed(const Duration(milliseconds: 300)); // Simulate network
  //     return Right(_mockModules);
  //   }
  // }

  // class MockGetModuleByIdUseCase implements GetModuleByIdUseCase {
  //   @override
  //   Future<Either<Failure, ModuleEntity>> call(String id) async {
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     final module = _mockModules.firstWhere((m) => m.id.toString() == id);
  //     return Right(module);
  //   }
  // }

  // class MockGetModuleTopicsUseCase implements GetModuleTopicsUseCase {
  //   @override
  //   Future<Either<Failure, List<Topic>>> call(String moduleId) async {
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     if (moduleId == '1') {
  //       return Right(_topics1);
  //     }
  //     return const Right([]);
  //   }
  // }

  // class MockUpdateModuleProgressUseCase implements UpdateModuleProgressUseCase {
  //   @override
  //   Future<Either<Failure, void>> call({String? moduleId, double? progress}) async {
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     return const Right(null); // Simulate success
  //   } 
  // }

  // class MockCompleteModuleUseCase implements CompleteModuleUseCase {
  //   @override
  //   Future<Either<Failure, void>> call(String moduleId) async {
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     return const Right(null); // Simulate success
  //   }
  // }

  // class MockSubmitExerciseAnswerUseCase implements SubmitExerciseAnswerUseCase {
  //   @override
  //   Future<Either<Failure, bool>> call({String? exerciseId, int? selectedAnswerIndex}) async {
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     final exercise = _exercises1.firstWhere((e) => e.id == exerciseId);
  //     bool isCorrect = exercise.correctAnswerIndex == selectedAnswerIndex;
  //     return Right(isCorrect); // Return if the answer was correct
  //   }
  // }
