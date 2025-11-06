import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:newtonium/core/constants/db_constants.dart';
import 'package:newtonium/features/past_questions/data/models/pq_data_models.dart';
import 'package:newtonium/features/past_questions/domain/entities/pq_entties.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

/// A dedicated helper class to manage table creation and data seeding
/// for the Past Questions feature.
///
/// Your global [DatabaseService] will call these methods.
class PqDatabaseHelper {
  /// A unique flag to ensure we only seed the database once.
  /// If you update your 'pq_data.json' file, you should change
  /// this flag (e.g., 'db_seeded_v2') to force a re-seed.
  static const String _kDbSeededFlag = 'pq_db_seeded_v1';

  /// Creates all tables required for the Past Questions feature.
  ///
  /// Call this from the `onCreate` callback of your
  /// global [DatabaseService.openDatabase] call.
  Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE ${DbConstants.kQuestionsTable} (
        ${DbConstants.kColumnId} TEXT PRIMARY KEY,
        ${DbConstants.kColumnQuestionType} TEXT NOT NULL,
        ${DbConstants.kColumnContent} TEXT NOT NULL,
        ${DbConstants.kColumnImageAssetName} TEXT,
        ${DbConstants.kColumnTopic} TEXT NOT NULL,
        ${DbConstants.kColumnYear} INTEGER NOT NULL,
        ${DbConstants.kColumnExplanation} TEXT NOT NULL,
        ${DbConstants.kColumnExplanationImageAssetName} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.kMcqOptionsTable} (
        ${DbConstants.kColumnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.kColumnQuestionId} TEXT NOT NULL,
        ${DbConstants.kColumnContent} TEXT NOT NULL,
        ${DbConstants.kColumnImageAssetName} TEXT,
        ${DbConstants.kColumnIsCorrect} INTEGER NOT NULL,
        FOREIGN KEY (${DbConstants.kColumnQuestionId}) 
          REFERENCES ${DbConstants.kQuestionsTable} (${DbConstants.kColumnId}) 
          ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.kPracticeAttemptsTable} (
        ${DbConstants.kColumnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.kColumnDateCompleted} TEXT NOT NULL,
        ${DbConstants.kColumnScoreCorrect} INTEGER NOT NULL,
        ${DbConstants.kColumnScoreTotal} INTEGER NOT NULL,
        ${DbConstants.kColumnQuizTypeLabel} TEXT NOT NULL,
        ${DbConstants.kColumnTimeTakenSeconds} INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.kAttemptWrongAnswersTable} (
        ${DbConstants.kColumnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.kColumnAttemptId} INTEGER NOT NULL,
        ${DbConstants.kColumnQuestionId} TEXT NOT NULL,
        FOREIGN KEY (${DbConstants.kColumnAttemptId}) 
          REFERENCES ${DbConstants.kPracticeAttemptsTable} (${DbConstants.kColumnId}) 
          ON DELETE CASCADE,
        FOREIGN KEY (${DbConstants.kColumnQuestionId}) 
          REFERENCES ${DbConstants.kQuestionsTable} (${DbConstants.kColumnId})
      )
    ''');
  }

  /// Seeds the database with data from the bundled JSON file.
  ///
  /// This only runs once (controlled by the [_kDbSeededFlag]).
  /// Call this from your global [DatabaseService] after the
  /// database has been successfully opened.
  Future<void> seedDatabase(Database db) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isSeeded = prefs.getBool(_kDbSeededFlag) ?? false;

    if (!isSeeded) {
      // 1. Load the JSON string from assets
      final String jsonString =
          await rootBundle.loadString('assets/data/pq_data.json');
      final List<dynamic> questionsJson = json.decode(jsonString);

      // 2. Use a transaction for efficiency
      await db.transaction((txn) async {
        final batch = txn.batch();

        for (final questionJson in questionsJson) {
          // 3. Parse the main question
          final questionMap = questionJson as Map<String, dynamic>;
          final question = QuestionModel.fromMap(questionMap, null);
          batch.insert(DbConstants.kQuestionsTable, question.toMap());

          // 4. Parse MCQ options, if they exist
          if (question.questionType == QuestionType.mcq &&
              questionJson['mcqOptions'] != null) {
            final List<dynamic> optionsJson = questionJson['mcqOptions'];
            for (final optionJson in optionsJson) {
              final optionMap = optionJson as Map<String, dynamic>;
              final option = McqOptionModel.fromMap(optionMap);
              batch.insert(
                DbConstants.kMcqOptionsTable,
                option.toMap(question.id), // Pass questionId to link
              );
            }
          }
        }
        await batch.commit(noResult: true);
      });

      // 5. Set the flag so we don't seed again
      await prefs.setBool(_kDbSeededFlag, true);
    }
  }
}