import 'package:newtonium/features/past_questions/domain/entities/pq_entties.dart';
import 'package:newtonium/core/constants/db_constants.dart';

/// Data models for the Data layer.
/// These classes `extend` the immutable domain entities and add
/// `fromMap`/`toMap` methods for serializing data with the
/// SQLite database.

// --- McqOption Model ---
class McqOptionModel extends McqOption {
  const McqOptionModel({
    required super.content,
    super.imageAssetName,
    required super.isCorrect,
  });

  factory McqOptionModel.fromMap(Map<String, dynamic> map) {
    return McqOptionModel(
      content: map[DbConstants.kColumnContent],
      imageAssetName: map[DbConstants.kColumnImageAssetName],
      isCorrect: map[DbConstants.kColumnIsCorrect] == 1,
    );
  }

  Map<String, dynamic> toMap(String questionId) {
    return {
      DbConstants.kColumnQuestionId: questionId,
      DbConstants.kColumnContent: content,
      DbConstants.kColumnImageAssetName: imageAssetName,
      DbConstants.kColumnIsCorrect: isCorrect ? 1 : 0,
    };
  }
}

// --- Question Model ---
class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.questionType,
    required super.content,
    super.imageAssetName,
    required super.topic,
    required super.year,
    required super.explanation,
    super.explanationImageAssetName,
    super.mcqOptions,
  });

  factory QuestionModel.fromMap(
      Map<String, dynamic> map, List<McqOptionModel>? options) {
    return QuestionModel(
      id: map[DbConstants.kColumnId],
      questionType: map[DbConstants.kColumnQuestionType] == 'mcq'
          ? QuestionType.mcq
          : QuestionType.theory,
      content: map[DbConstants.kColumnContent],
      imageAssetName: map[DbConstants.kColumnImageAssetName],
      topic: map[DbConstants.kColumnTopic],
      year: map[DbConstants.kColumnYear],
      explanation: map[DbConstants.kColumnExplanation],
      explanationImageAssetName: map[DbConstants.kColumnExplanationImageAssetName],
      mcqOptions: options,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DbConstants.kColumnId: id,
      DbConstants.kColumnQuestionType: questionType.name,
      DbConstants.kColumnContent: content,
      DbConstants.kColumnImageAssetName: imageAssetName,
      DbConstants.kColumnTopic: topic,
      DbConstants.kColumnYear: year,
      DbConstants.kColumnExplanation: explanation,
      DbConstants.kColumnExplanationImageAssetName: explanationImageAssetName,
    };
  }
}

// --- PracticeAttempt Model ---
class PracticeAttemptModel extends PracticeAttempt {
  const PracticeAttemptModel({
    super.id,
    required super.dateCompleted,
    required super.scoreCorrect,
    required super.scoreTotal,
    required super.quizTypeLabel,
    required super.timeTakenSeconds,
  });

  factory PracticeAttemptModel.fromMap(Map<String, dynamic> map) {
    return PracticeAttemptModel(
      id: map[DbConstants.kColumnId],
      dateCompleted: DateTime.parse(map[DbConstants.kColumnDateCompleted]),
      scoreCorrect: map[DbConstants.kColumnScoreCorrect],
      scoreTotal: map[DbConstants.kColumnScoreTotal],
      quizTypeLabel: map[DbConstants.kColumnQuizTypeLabel],
      timeTakenSeconds: map[DbConstants.kColumnTimeTakenSeconds],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id' is omitted, as SQLite will auto-increment it.
      DbConstants.kColumnDateCompleted: dateCompleted.toIso8601String(),
      DbConstants.kColumnScoreCorrect: scoreCorrect,
      DbConstants.kColumnScoreTotal: scoreTotal,
      DbConstants.kColumnQuizTypeLabel: quizTypeLabel,
      DbConstants.kColumnTimeTakenSeconds: timeTakenSeconds,
    };
  }
}

// --- AttemptWrongAnswer Model ---
class AttemptWrongAnswerModel extends AttemptWrongAnswer {
  const AttemptWrongAnswerModel({
    super.id,
    required super.attemptId,
    required super.questionId,
  });

  factory AttemptWrongAnswerModel.fromMap(Map<String, dynamic> map) {
    return AttemptWrongAnswerModel(
      id: map[DbConstants.kColumnId],
      attemptId: map[DbConstants.kColumnAttemptId],
      questionId: map[DbConstants.kColumnQuestionId],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id' is omitted, as SQLite will auto-increment it.
      DbConstants.kColumnAttemptId: attemptId,
      DbConstants.kColumnQuestionId: questionId,
    };
  }
}