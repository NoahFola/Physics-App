/// Contains all table and column names for the local SQLite database.
/// Using constants prevents typos when writing queries.
class DbConstants {
  // --- Tables ---
  static const String kQuestionsTable = 'questions';
  static const String kMcqOptionsTable = 'mcq_options';
  static const String kPracticeAttemptsTable = 'practice_attempts';
  static const String kAttemptWrongAnswersTable = 'attempt_wrong_answers';

  // --- Common Columns ---
  static const String kColumnId = 'id';
  static const String kColumnContent = 'content';
  static const String kColumnImageAssetName = 'image_asset_name';
  static const String kColumnQuestionId = 'question_id'; // Foreign Key

  // --- Questions Table Columns ---
  static const String kColumnQuestionType = 'question_type';
  static const String kColumnTopic = 'topic';
  static const String kColumnYear = 'year';
  static const String kColumnExplanation = 'explanation';
  static const String kColumnExplanationImageAssetName =
      'explanation_image_asset_name';

  // --- McqOptions Table Columns ---
  static const String kColumnIsCorrect = 'is_correct'; // Stored as 0 or 1

  // --- PracticeAttempts Table Columns ---
  static const String kColumnDateCompleted = 'date_completed'; // ISO 8601 String
  static const String kColumnScoreCorrect = 'score_correct';
  static const String kColumnScoreTotal = 'score_total';
  static const String kColumnQuizTypeLabel = 'quiz_type_label';
  static const String kColumnTimeTakenSeconds = 'time_taken_seconds';

  // --- AttemptWrongAnswers Table Columns ---
  static const String kColumnAttemptId = 'attempt_id'; // Foreign Key
}