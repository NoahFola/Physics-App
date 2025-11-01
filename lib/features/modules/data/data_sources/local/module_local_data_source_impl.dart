// lib/features/modules/data/datasources/module_local_data_source_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../domain/entities/module_entity.dart';
import './module_local_data_source.dart';
import '../../../../../core/database/database_service.dart';
import 'package:newtonium/features/modules/domain/entities/topic_entity.dart';

class ModuleLocalDataSourceImpl implements ModuleLocalDataSource {
  static const String _modulesTable = 'modules';
  static const String _topicsTable = 'topics';
  static const String _subtopicsTable = 'subtopics';
  static const String _exercisesTable = 'exercises';
  static const String _userProgressTable = 'user_progress';
  
  static Database? _database;

  Future<Database> get _db async {
    _database ??= await DatabaseService().database;
    return _database!;
  }

  @override
  Future<List<ModuleEntity>> getModules() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(_modulesTable);
    
    return maps.map((map) => ModuleEntity(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      progress: map['progress'],
    )).toList();
  }

  @override
  Future<ModuleEntity?> getModuleById(String id) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      _modulesTable,
      where: 'id = ?',
      whereArgs: [int.parse(id)],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return ModuleEntity(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        progress: map['progress'],
      );
    }
    return null;
  }

  @override
  Future<void> updateModuleProgress(String moduleId, double progress) async {
    final db = await _db;
    
    await db.update(
      _modulesTable,
      {'progress': progress},
      where: 'id = ?',
      whereArgs: [int.parse(moduleId)],
    );
  }

  @override
  Future<List<Topic>> getModuleTopics(String moduleId) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      _topicsTable,
      where: 'module_id = ?',
      whereArgs: [int.parse(moduleId)],
      orderBy: 'order_index ASC',
    );

    return maps.map((map) => Topic(
      id: map['id'].toString(),
      moduleCode: moduleId,
      title: map['title'],
      order: map['order_index'],
      subTopics: null, // Will be loaded separately if needed
    )).toList();
  }

  @override
  Future<void> updateTopicProgress(String topicId, double progress) async {
    final db = await _db;
    
    await db.update(
      _userProgressTable,
      {
        'progress': progress,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'topic_id = ?',
      whereArgs: [int.parse(topicId)],
    );
  }

  @override
  Future<List<Subtopic>> getTopicSubtopics(String topicId) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      _subtopicsTable,
      where: 'topic_id = ?',
      whereArgs: [int.parse(topicId)],
      orderBy: 'order_index ASC',
    );

    // Get exercises for each subtopic
    final subtopics = <Subtopic>[];
    for (final map in maps) {
      final exercises = await _getExercisesForSubtopic(map['id'].toString());
      
      subtopics.add(Subtopic(
        id: map['id'].toString(),
        topicId: topicId,
        title: map['title'],
        order: map['order_index'],
        contentSections: map['content'],
        exercises: exercises,
      ));
    }

    return subtopics;
  }

  @override
  Future<void> completeSubtopic(String subtopicId) async {
    final db = await _db;
    
    await db.insert(
      _userProgressTable,
      {
        'subtopic_id': int.parse(subtopicId),
        'completed': true,
        'completed_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<bool> submitExerciseAnswer({
    required String exerciseId,
    required int selectedAnswerIndex,
  }) async {
    final db = await _db;
    
    // Get the exercise to check the correct answer
    final List<Map<String, dynamic>> exerciseMaps = await db.query(
      _exercisesTable,
      where: 'id = ?',
      whereArgs: [int.parse(exerciseId)],
    );

    if (exerciseMaps.isEmpty) {
      return false;
    }

    final exercise = exerciseMaps.first;
    final isCorrect = selectedAnswerIndex == exercise['correct_answer_index'];
    
    // Record the attempt
    await db.insert(
      'exercise_attempts',
      {
        'exercise_id': int.parse(exerciseId),
        'selected_answer_index': selectedAnswerIndex,
        'is_correct': isCorrect ? 1 : 0,
        'attempted_at': DateTime.now().millisecondsSinceEpoch,
      },
    );

    return isCorrect;
  }

  @override
  Future<Map<String, dynamic>> getUserProgressStats() async {
    final db = await _db;
    
    // Get total modules count
    final modulesCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_modulesTable')
    ) ?? 0;

    // Get completed modules count
    final completedModulesCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_modulesTable WHERE progress = 1.0')
    ) ?? 0;

    // Get total topics count
    final topicsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_topicsTable')
    ) ?? 0;

    // Get completed subtopics count
    final completedSubtopicsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_userProgressTable WHERE subtopic_id IS NOT NULL AND completed = 1')
    ) ?? 0;

    // Get total exercise attempts and correct answers
    final exerciseStats = Sqflite.firstIntValue(
      await db.rawQuery('''
        SELECT 
          COUNT(*) as total_attempts,
          SUM(is_correct) as correct_attempts 
        FROM exercise_attempts
      ''')
    );

    return {
      'total_modules': modulesCount,
      'completed_modules': completedModulesCount,
      'total_topics': topicsCount,
      'completed_subtopics': completedSubtopicsCount,
      'total_exercise_attempts': exerciseStats ?? 0,
      'overall_progress': modulesCount > 0 ? completedModulesCount / modulesCount : 0.0,
    };
  }

  // Helper method to get exercises for a subtopic
  Future<List<Exercise>> _getExercisesForSubtopic(String subtopicId) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      _exercisesTable,
      where: 'subtopic_id = ?',
      whereArgs: [int.parse(subtopicId)],
      orderBy: 'order_index ASC',
    );

    return maps.map((map) {
      // Parse options from JSON string or split by delimiter
      final optionsString = map['options'] as String? ?? '';
      final options = optionsString.split('|');
      
      return Exercise(
        id: map['id'].toString(),
        question: map['question'],
        codeTemplate: map['code_template'],
        options: options,
        correctAnswerIndex: map['correct_answer_index'],
        explanation: map['explanation'],
      );
    }).toList();
  }
}
//   const String _tableName = 'modules';
//   Database? _database;

//   Future<Database> get _db async {
//     _database ??= await DatabaseService().database;
//     return _database!;
//   }

//   @override
//   Future<List<ModuleEntity>> getModules() async {
//     final db = await _db;
//     final List<Map<String, dynamic>> maps = await db.query(_tableName);
    
//     return maps.map((map) => ModuleEntity(
//       id: map['id'], // Convert to String
//       title: map['title'],
//       description: map['description'],
//       progress: map['progress'],
//     )).toList();
//   }

//   @override
//   Future<ModuleEntity?> getModuleById(String id) async { // Changed to String
//     final db = await _db;
//     final List<Map<String, dynamic>> maps = await db.query(
//       _tableName,
//       where: 'id = ?',
//       whereArgs: [int.parse(id)], // Parse to int for database query
//     );

//     if (maps.isNotEmpty) {
//       final map = maps.first;
//       return ModuleEntity(
//         id: map['id'], // Convert to String
//         title: map['title'],
//         description: map['description'],
//         progress: map['progress'],
//       );
//     }
//     return null;
//   }

//   @override
//   Future<void> updateModuleProgress(String moduleId, double progress) async { // Changed to String
//     final db = await _db;
    
//     await db.update(
//       _tableName,
//       {'progress': progress},
//       where: 'id = ?',
//       whereArgs: [int.parse(moduleId)], // Parse to int for database query
//     );
//   }

//   // Stub implementations for new methods
//   @override
//   Future<List<Topic>> getModuleTopics(String moduleId) async {
//     // TODO: Implement getModuleTopics
//     return [];
//   }

//   @override
//   Future<void> updateTopicProgress(String topicId, double progress) async {
//     // TODO: Implement updateTopicProgress
//   }

//   @override
//   Future<List<Subtopic>> getTopicSubtopics(String topicId) async {
//     // TODO: Implement getTopicSubtopics
//     return [];
//   }

//   @override
//   Future<void> completeSubtopic(String subtopicId) async {
//     // TODO: Implement completeSubtopic
//   }

//   @override
//   Future<bool> submitExerciseAnswer({
//     required String exerciseId,
//     required int selectedAnswerIndex,
//   }) async {
//     // TODO: Implement submitExerciseAnswer
//     return false;
//   }

//   @override
//   Future<Map<String, dynamic>> getUserProgressStats() async {
//     // TODO: Implement getUserProgressStats
//     return {};
//   }
// }