import 'package:sqflite/sqflite.dart';
import 'package:newtonium/features/past_questions/domain/entities/pq_entties.dart';
import 'package:newtonium/features/past_questions/data/data_sources/local/pq_abstract_local_data_source.dart';
import 'package:newtonium/features/past_questions/data/models/pq_data_models.dart';
import 'package:newtonium/core/constants/db_constants.dart';
import 'package:newtonium/core/error/exceptions.dart';

/// This is the concrete implementation of the [PastQuestionLocalDataSource].
///
/// This is the "worker" file that contains all the raw `sqflite` query
/// logic. It depends on the `Database` instance provided by `sqflite`
/// (which will be injected via GetIt).
///
/// It throws a [CacheException] if any database operation fails,
/// which the [PastQuestionRepositoryImpl] will catch.
class PastQuestionLocalDataSourceImpl implements PastQuestionLocalDataSource {
  final Database db;

  PastQuestionLocalDataSourceImpl({required this.db});

  @override
  Future<List<Question>> getQuestions({
    int? year,
    String? topic,
    QuestionType? questionType,
  }) async {
    try {
      // 1. Build the filter query
      List<String> whereClauses = [];
      List<dynamic> whereArgs = [];

      if (year != null) {
        whereClauses.add('${DbConstants.kColumnYear} = ?');
        whereArgs.add(year);
      }
      if (topic != null) {
        whereClauses.add('${DbConstants.kColumnTopic} = ?');
        whereArgs.add(topic);
      }
      if (questionType != null) {
        whereClauses.add('${DbConstants.kColumnQuestionType} = ?');
        whereArgs.add(questionType.name);
      }

      final String whereString =
          whereClauses.isNotEmpty ? whereClauses.join(' AND ') : '';

      // 2. Fetch the questions
      final List<Map<String, dynamic>> questionMaps = await db.query(
        DbConstants.kQuestionsTable,
        where: whereString.isNotEmpty ? whereString : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      );

      // 3. Fetch options for each question (N+1 query pattern)
      final List<QuestionModel> questions = [];
      for (final questionMap in questionMaps) {
        List<McqOptionModel>? options;
        if (questionMap[DbConstants.kColumnQuestionType] == 'mcq') {
          final List<Map<String, dynamic>> optionMaps = await db.query(
            DbConstants.kMcqOptionsTable,
            where: '${DbConstants.kColumnQuestionId} = ?',
            whereArgs: [questionMap[DbConstants.kColumnId]],
          );
          options =
              optionMaps.map((map) => McqOptionModel.fromMap(map)).toList();
        }
        questions.add(QuestionModel.fromMap(questionMap, options));
      }

      return questions;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<String>> getAvailableTopics() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DbConstants.kQuestionsTable,
        distinct: true,
        columns: [DbConstants.kColumnTopic],
        orderBy: DbConstants.kColumnTopic,
      );
      return maps
          .map((map) => map[DbConstants.kColumnTopic] as String)
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<int>> getAvailableYears() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DbConstants.kQuestionsTable,
        distinct: true,
        columns: [DbConstants.kColumnYear],
        orderBy: '${DbConstants.kColumnYear} DESC',
      );
      return maps.map((map) => map[DbConstants.kColumnYear] as int).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<PracticeAttempt>> getPracticeAttempts() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DbConstants.kPracticeAttemptsTable,
        orderBy: '${DbConstants.kColumnDateCompleted} DESC',
      );
      return maps.map((map) => PracticeAttemptModel.fromMap(map)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> savePracticeAttempt({
    required PracticeAttempt attempt,
    required List<AttemptWrongAnswer> wrongAnswers,
  }) async {
    try {
      await db.transaction((txn) async {
        // 1. Insert the main attempt and get its new ID
        final attemptModel = PracticeAttemptModel(
          dateCompleted: attempt.dateCompleted,
          scoreCorrect: attempt.scoreCorrect,
          scoreTotal: attempt.scoreTotal,
          quizTypeLabel: attempt.quizTypeLabel,
          timeTakenSeconds: attempt.timeTakenSeconds,
        );
        final int newAttemptId = await txn.insert(
          DbConstants.kPracticeAttemptsTable,
          attemptModel.toMap(),
        );

        // 2. Insert all wrong answers linked to that new ID
        final batch = txn.batch();
        for (final wrongAnswer in wrongAnswers) {
          final wrongAnswerModel = AttemptWrongAnswerModel(
            attemptId: newAttemptId, // Link to the new attempt
            questionId: wrongAnswer.questionId,
          );
          batch.insert(
            DbConstants.kAttemptWrongAnswersTable,
            wrongAnswerModel.toMap(),
          );
        }
        await batch.commit(noResult: true);
      });
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<Question>> getWrongAnswerQuestions(int attemptId) async {
    try {
      // 1. Get all wrong question IDs for this attempt
      final List<Map<String, dynamic>> wrongAnswerMaps = await db.query(
        DbConstants.kAttemptWrongAnswersTable,
        where: '${DbConstants.kColumnAttemptId} = ?',
        whereArgs: [attemptId],
      );
      final List<String> questionIds = wrongAnswerMaps
          .map((map) => map[DbConstants.kColumnQuestionId] as String)
          .toList();

      if (questionIds.isEmpty) {
        return [];
      }

      // 2. Fetch all questions matching those IDs
      // Using 'WHERE IN' is more efficient than many separate queries
      final String placeholders = ('?' * questionIds.length).split('').join(',');
      final List<Map<String, dynamic>> questionMaps = await db.query(
        DbConstants.kQuestionsTable,
        where: '${DbConstants.kColumnId} IN ($placeholders)',
        whereArgs: questionIds,
      );

      // 3. Fetch options for each question (same as getQuestions)
      final List<QuestionModel> questions = [];
      for (final questionMap in questionMaps) {
        List<McqOptionModel>? options;
        if (questionMap[DbConstants.kColumnQuestionType] == 'mcq') {
          final List<Map<String, dynamic>> optionMaps = await db.query(
            DbConstants.kMcqOptionsTable,
            where: '${DbConstants.kColumnQuestionId} = ?',
            whereArgs: [questionMap[DbConstants.kColumnId]],
          );
          options =
              optionMaps.map((map) => McqOptionModel.fromMap(map)).toList();
        }
        questions.add(QuestionModel.fromMap(questionMap, options));
      }

      return questions;
    } catch (e) {
      throw CacheException();
    }
  }
}