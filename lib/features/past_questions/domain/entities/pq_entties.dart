import 'package:flutter/foundation.dart';

/// Enum to safely represent the two types of questions.
enum QuestionType {
  mcq,
  theory;
}

// --- STATIC CONTENT MODELS (From JSON) ---

/// Represents a single multiple-choice option.
/// This is nested inside a Question.
@immutable
class McqOption {
  final String content;
  final String? imageAssetName;
  final bool isCorrect;

  const McqOption({
    required this.content,
    this.imageAssetName,
    required this.isCorrect,
  });
}

/// Represents a single question, either MCQ or Theory.
/// This is the main model for your bundled JSON data.
@immutable
class Question {
  final String id;
  final QuestionType questionType;
  final String content;
  final String? imageAssetName;
  final String topic;
  final int year;
  final String explanation;
  final String? explanationImageAssetName;
  final List<McqOption>? mcqOptions; // Null if paperType is 'THEORY'

  const Question({
    required this.id,
    required this.questionType,
    required this.content,
    this.imageAssetName,
    required this.topic,
    required this.year,
    required this.explanation,
    this.explanationImageAssetName,
    this.mcqOptions,
  });
}

// --- USER DATA MODELS (For SQLite) ---

/// Represents a completed quiz session to be stored in the local DB.
@immutable
class PracticeAttempt {
  final int? id; // Nullable, as it will be auto-incremented by SQLite
  final DateTime dateCompleted;
  final int scoreCorrect;
  final int scoreTotal;
  final String quizTypeLabel;
  final int timeTakenSeconds;

  const PracticeAttempt({
    this.id,
    required this.dateCompleted,
    required this.scoreCorrect,
    required this.scoreTotal,
    required this.quizTypeLabel,
    required this.timeTakenSeconds,
  });
}

/// Represents a single wrong answer for a specific attempt.
/// Used for the "Review Wrong Answers" feature.
@immutable
class AttemptWrongAnswer {
  final int? id; // Nullable, as it will be auto-incremented by SQLite
  final int attemptId; // Foreign key to PracticeAttempt.id
  final String questionId; // Foreign key to Question.id

  const AttemptWrongAnswer({
    this.id,
    required this.attemptId,
    required this.questionId,
  });
}