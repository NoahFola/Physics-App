import 'package:newtonium/features/past_questions/domain/entities/pq_entties.dart';

/// The abstract contract for the local database worker.
///
/// This file defines the methods that the [PastQuestionRepositoryImpl]
/// will call. The concrete implementation of this class
/// (e.g., `PastQuestionLocalDataSourceImpl`) will contain all the
/// actual `sqflite` database query code.
abstract class PastQuestionLocalDataSource {
  /// Fetches questions from the local database based on optional filters.
  ///
  /// Throws a [CacheException] if no data is found or a DB error occurs.
  Future<List<Question>> getQuestions({
    int? year,
    String? topic,
    QuestionType? questionType,
  });

  /// Fetches a list of all unique topic names from the local database.
  ///
  /// Throws a [CacheException] if no data is found or a DB error occurs.
  Future<List<String>> getAvailableTopics();

  /// Fetches a list of all unique years from the local database.
  ///
  /// Throws a [CacheException] if no data is found or a DB error occurs.
  Future<List<int>> getAvailableYears();

  /// Saves a completed practice attempt and its associated wrong answers
  /// to the local SQLite database.
  ///
  /// Throws a [CacheException] if the database insertion fails.
  Future<void> savePracticeAttempt({
    required PracticeAttempt attempt,
    required List<AttemptWrongAnswer> wrongAnswers,
  });

  /// Retrieves all saved practice attempts from the local database.
  ///
  /// Throws a [CacheException] if no data is found or a DB error occurs.
  Future<List<PracticeAttempt>> getPracticeAttempts();

  /// Retrieves the full [Question] objects for all wrong answers
  /// associated with a specific [attemptId] from the local database.
  ///
  /// Throws a [CacheException] if no data is found or a DB error occurs.
  Future<List<Question>> getWrongAnswerQuestions(int attemptId);
}