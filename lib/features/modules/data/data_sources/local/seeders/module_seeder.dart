import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

class ModuleSeeder {
  static Future<void> seed(Database db) async {
    // 1. Load the JSON string from the asset file
    final String jsonString = await rootBundle.loadString('assets/data/seeder_data.json');

    // 2. Decode the JSON string into a Dart Map
    final Map<String, dynamic> data = json.decode(jsonString);

    // 3. Get the list of modules
    final List<dynamic> moduleList = data['modules'] ?? [];

    // 4. Iterate over each module and insert it into the database
    for (final moduleData in moduleList) {
      // --- Insert Module ---
      final int moduleId = await db.insert('modules', {
        'title': moduleData['title'],
        'description': moduleData['description'],
        'progress': moduleData['progress'],
      });

      // --- Insert Topics for this Module ---
      final List<dynamic> topicList = moduleData['topics'] ?? [];
      for (final topicData in topicList) {
        final int topicId = await db.insert('topics', {
          'module_id': moduleId,
          'title': topicData['title'],
          'order_index': topicData['order_index'],
        });

        // --- Insert SINGLE Subtopic for this Topic ---
        // Get the single subtopic object (it's no longer a list)
        final Map<String, dynamic>? subtopicData = topicData['subtopic'];

        if (subtopicData != null) {
          final int subtopicId = await db.insert('subtopics', {
            'topic_id': topicId,
            'module_id': moduleId, // Retaining this as it was in your original code
            'title': subtopicData['title'],
            'order_index': subtopicData['order_index'],
            'content': subtopicData['content'],
          });

          // --- Insert Exercises for this Subtopic ---
          final List<dynamic> exerciseList = subtopicData['exercises'] ?? [];
          for (final exerciseData in exerciseList) {
            await db.insert('exercises', {
              'topic_id': topicId, // Retaining this as it was in your original code
              'subtopic_id': subtopicId,
              'question': exerciseData['question'],
              // Convert the list of options back into a JSON string for the DB
              'options': json.encode(exerciseData['options']),
              'correct_answer_index': exerciseData['correct_answer_index'],
              'explanation': exerciseData['explanation'],
            });
          }
        }
      }
    }
  }
}

