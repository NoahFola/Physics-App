import 'package:newtonium/features/past_questions/domain/entities/pq_entties.dart'; // <-- Make sure to fix this import path

/// The abstract contract for the Past Question feature.
/// The Data layer will create a concrete implementation of this class.
abstract class PastQuestionRepository {
  /// Fetches questions based on optional filters.
  ///
  /// - [year]: Filters by a specific exam year.
  /// - [topic]: Filters by a specific topic.
  /// - [questionType]: Filters by MCQ or THEORY.
  Future<List<Question>> getQuestions({
    int? year,
    String? topic,
    QuestionType? questionType,
  });

  /// Fetches a list of all unique topic names available.
  /// (Used to populate the 'Topic' filter dropdown)
  Future<List<String>> getAvailableTopics();

  /// Fetches a list of all unique years available.
  /// (Used to populate the 'Year' filter dropdown)
  Future<List<int>> getAvailableYears();

  /// Saves a completed practice attempt and its associated wrong answers
  /// to the local SQLite database.
  Future<void> savePracticeAttempt({
    required PracticeAttempt attempt,
    required List<AttemptWrongAnswer> wrongAnswers,
  });

  /// Retrieves all saved practice attempts from local storage.
  /// (Used to build the 'History' screen)
  Future<List<PracticeAttempt>> getPracticeAttempts();

  /// Retrieves the full [Question] objects for all wrong answers
  /// associated with a specific [attemptId].
  /// (Used for the 'Review Wrong Answers' feature)
  Future<List<Question>> getWrongAnswerQuestions(int attemptId);
}