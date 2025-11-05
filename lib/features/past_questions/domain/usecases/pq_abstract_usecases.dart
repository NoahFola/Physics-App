import 'package:newtonium/features/past_questions/domain/entities/pq_entties.dart';

// --- PARAMETER OBJECTS ---
// Using parameter objects makes use case calls cleaner and more maintainable
// than passing many individual arguments.

/// Parameters for [GetFilteredQuestionsUseCase]
class QuestionFilterParams {
  final int? year;
  final String? topic;
  final QuestionType? questionType;

  QuestionFilterParams({this.year, this.topic, this.questionType});
}

/// Parameters for [SavePracticeAttemptUseCase]
class SaveAttemptParams {
  final PracticeAttempt attempt;
  final List<AttemptWrongAnswer> wrongAnswers;

  SaveAttemptParams({required this.attempt, required this.wrongAnswers});
}

/// Parameters for [GetWrongAnswerQuestionsUseCase]
class GetWrongAnswersParams {
  final int attemptId;

  GetWrongAnswersParams({required this.attemptId});
}

/// Used for use cases that do not require any parameters.
class NoParams {}

// --- ABSTRACT USE CASES ---
// Each class represents a single, specific business rule or user action.
// The Presentation layer (e.g., your BLoC or ViewModel) will call these.

/// Use Case: Get a filtered list of questions
abstract class GetFilteredQuestionsUseCase {
  Future<List<Question>> call(QuestionFilterParams params);
}

/// Use Case: Get list of all available topics
abstract class GetAvailableTopicsUseCase {
  Future<List<String>> call(NoParams params);
}

/// Use Case: Get list of all available years
abstract class GetAvailableYearsUseCase {
  Future<List<int>> call(NoParams params);
}

/// Use Case: Save a completed quiz attempt
abstract class SavePracticeAttemptUseCase {
  Future<void> call(SaveAttemptParams params);
}

/// Use Case: Get history of all past attempts
abstract class GetPracticeAttemptsUseCase {
  Future<List<PracticeAttempt>> call(NoParams params);
}

/// Use Case: Get the full questions for a specific attempt's wrong answers
abstract class GetWrongAnswerQuestionsUseCase {
  Future<List<Question>> call(GetWrongAnswersParams params);
}