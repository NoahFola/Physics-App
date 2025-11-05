import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/module_entity.dart';
import './module_local_data_source.dart';
import '../../../../../core/database/database_service.dart';
import 'package:newtonium/features/modules/domain/entities/topic_entity.dart';
import 'dart:convert'; // Add this at the top

class ModuleLocalDataSourceImpl implements ModuleLocalDataSource {
  static const String _modulesTable = 'modules';
  static const String _topicsTable = 'topics';
  static const String _subtopicsTable = 'subtopics';
  static const String _exercisesTable = 'exercises';
  static const String _userProgressTable = 'user_progress';
  
  static Database? _database;
  static ModuleLocalDataSourceImpl? _instance;
  
  // Private constructor
  ModuleLocalDataSourceImpl._internal();
  
  // Factory constructor for singleton
  factory ModuleLocalDataSourceImpl() {
    _instance ??= ModuleLocalDataSourceImpl._internal();
    return _instance!;
  }

  Future<Database> get _db async {
    _database ??= await DatabaseService().database;
    return _database!;
  }

  @override
  Future<List<ModuleEntity>> getModules() async {
    final db = await _db;
    final List<Map<String, dynamic>> moduleMaps = await db.query(_modulesTable);
    print('Found ${moduleMaps.length} modules in database');

    // Convert to entities with topics
    final List<ModuleEntity> modules = [];
    for (final moduleMap in moduleMaps) {
      // Get topics for this module
      final topicMaps = await db.query(
        _topicsTable,
        where: 'module_id = ?',
        whereArgs: [moduleMap['id']],
      );

      // Convert topics to entities WITH subtopics
      final topics = <Topic>[];
      for (final topicMap in topicMaps) {
        // Get subtopic for this topic (single subtopic now)
        final subtopicMaps = await db.query(
          _subtopicsTable,
          where: 'topic_id = ?',
          whereArgs: [topicMap['id']],
          orderBy: 'order_index ASC',
          limit: 1, // Only get first subtopic since we have single subtopic now
        );

        // Convert subtopic to entity
        Subtopic subtopic;
        if (subtopicMaps.isNotEmpty) {
          final subtopicMap = subtopicMaps.first;
          final exercises = await _getExercisesForSubtopic(subtopicMap['id'].toString());
          
          subtopic = Subtopic(
            id: subtopicMap['id'].toString(),
            topicId: topicMap['id'].toString(),
            title: subtopicMap['title'] as String,
            order: subtopicMap['order_index'] as int,
            contentSections: subtopicMap['content'] as String,
            exercises: exercises,
          );
        } else {
          // Create default subtopic if none exists
          subtopic = Subtopic(
            id: 'default',
            topicId: topicMap['id'].toString(),
            title: 'Content coming soon',
            order: 0,
            contentSections: 'Lesson content will be available soon.',
            exercises: [],
          );
        }

        topics.add(Topic(
          id: topicMap['id'].toString(),
          moduleCode: 'M${moduleMap['id']}',
          title: topicMap['title'] as String,
          order: topicMap['order_index'] as int,
          subTopics: subtopic, // Single subtopic now
        ));
      }

      modules.add(ModuleEntity(
        id: moduleMap['id'] as int,
        title: moduleMap['title'] as String,
        description: moduleMap['description'] as String,
        progress: moduleMap['progress'] as double,
        topics: topics,
      ));
    }

    print('Returning ${modules.length} modules with topics');
    return modules;
  }

  @override
  Future<ModuleEntity?> getModuleById(String id) async {
    final db = await _db;
    final List<Map<String, dynamic>> moduleMaps = await db.query(
      _modulesTable,
      where: 'id = ?',
      whereArgs: [int.parse(id)],
    );

    if (moduleMaps.isNotEmpty) {
      final moduleMap = moduleMaps.first;
      
      // Get topics for this module
      final topicMaps = await db.query(
        _topicsTable,
        where: 'module_id = ?',
        whereArgs: [moduleMap['id']],
      );

      // Convert topics to entities WITH subtopics
      final topics = <Topic>[];
      for (final topicMap in topicMaps) {
        // Get subtopic for this topic
        final subtopicMaps = await db.query(
          _subtopicsTable,
          where: 'topic_id = ?',
          whereArgs: [topicMap['id']],
          limit: 1,
        );

        Subtopic subtopic;
        if (subtopicMaps.isNotEmpty) {
          final subtopicMap = subtopicMaps.first;
          final exercises = await _getExercisesForSubtopic(subtopicMap['id'].toString());
          
          subtopic = Subtopic(
            id: subtopicMap['id'].toString(),
            topicId: topicMap['id'].toString(),
            title: subtopicMap['title'] as String,
            order: subtopicMap['order_index'] as int,
            contentSections: subtopicMap['content'] as String,
            exercises: exercises,
          );
        } else {
          subtopic = Subtopic(
            id: 'default',
            topicId: topicMap['id'].toString(),
            title: 'Content coming soon',
            order: 0,
            contentSections: 'Lesson content will be available soon.',
            exercises: [],
          );
        }

        topics.add(Topic(
          id: topicMap['id'].toString(),
          moduleCode: 'M${moduleMap['id']}',
          title: topicMap['title'] as String,
          order: topicMap['order_index'] as int,
          subTopics: subtopic,
        ));
      }

      return ModuleEntity(
        id: moduleMap['id'] as int,
        title: moduleMap['title'] as String,
        description: moduleMap['description'] as String,
        progress: moduleMap['progress'] as double,
        topics: topics,
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

    final topics = <Topic>[];
    for (final map in maps) {
      final subtopic = await getTopicSubtopic(map['id'].toString());
      
      topics.add(Topic(
        id: map['id'].toString(),
        moduleCode: moduleId,
        title: map['title'] as String,
        order: map['order_index'] as int,
        subTopics: subtopic, // Single subtopic
      ));
    }
    return topics;
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
    // This method is deprecated since we now have single subtopic per topic
    // But keeping it for backward compatibility
    final subtopic = await getTopicSubtopic(topicId);
    return [subtopic];
  }

  // New method for single subtopic
  Future<Subtopic> getTopicSubtopic(String topicId) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      _subtopicsTable,
      where: 'topic_id = ?',
      whereArgs: [int.parse(topicId)],
      orderBy: 'order_index ASC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      final exercises = await _getExercisesForSubtopic(map['id'].toString());
      
      return Subtopic(
        id: map['id'].toString(),
        topicId: topicId,
        title: map['title'] as String,
        order: map['order_index'] as int,
        contentSections: map['content'] as String,
        exercises: exercises,
      );
    }

    // Return default subtopic if none exists
    return Subtopic(
      id: 'default',
      topicId: topicId,
      title: 'Content coming soon',
      order: 0,
      contentSections: 'Lesson content will be available soon.',
      exercises: [],
    );
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
    );

    return maps.map((map) {
      // Parse options from JSON string
      final optionsString = map['options'] as String? ?? '[]';
      List<String> options;
      
      try {
        // Parse as JSON array
        final decoded = jsonDecode(optionsString) as List<dynamic>;
        options = decoded.map((e) => e.toString()).toList();
      } catch (e) {
        // Fallback to pipe separation if JSON fails
        options = optionsString.split('|');
      }
      
      return Exercise(
        id: map['id'].toString(),
        question: map['question'] as String,
        codeTemplate: map['code_template'] as String?,
        options: options,
        correctAnswerIndex: map['correct_answer_index'] as int,
        explanation: map['explanation'] as String?,
      );
    }).toList();
  }
}
 
