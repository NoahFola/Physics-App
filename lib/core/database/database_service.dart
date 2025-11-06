// lib/core/database/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:newtonium/core/database/pq_database_helper.dart'; // Import the helper

class DatabaseService {
  // Singleton pattern
  final _databaseName = 'flutter_sqflite_database.db';  
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  final PqDatabaseHelper _pqHelper = PqDatabaseHelper();



  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, _databaseName);

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    final db = await openDatabase( // Store the db instance
      path,
      onCreate: _createTables,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );

    // Seed the Past Questions database (only runs if not seeded)
    // This runs *after* open, not just on create.
    
    await _pqHelper.seedDatabase(db);

    return db; // Return the instance
  }

  // Create tables
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE modules(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        progress REAL DEFAULT 0.0,
        created_at INTEGER DEFAULT (strftime('%s', 'now')),
        updated_at INTEGER DEFAULT (strftime('%s', 'now'))
      )
      
    ''');
    await db.execute('''
  CREATE TABLE topics(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    module_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    order_index INTEGER NOT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
  )
  ''');

  await db.execute('''
    CREATE TABLE subtopics(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      topic_id INTEGER NOT NULL,
      module_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      order_index INTEGER NOT NULL,
      content TEXT NOT NULL,
      FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE CASCADE
    )
  ''');

  await db.execute('''
    CREATE TABLE exercises(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      topic_id INTEGER NOT NULL,
      subtopic_id INTEGER NOT NULL,
      question TEXT NOT NULL,
      options TEXT NOT NULL, -- JSON array
      correct_answer_index INTEGER NOT NULL,
      explanation TEXT,
      FOREIGN KEY (subtopic_id) REFERENCES subtopics(id) ON DELETE CASCADE
    )
  ''');
  await db.execute('''
    CREATE TABLE user_progress(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      topic_id INTEGER,
      subtopic_id INTEGER,
      progress REAL DEFAULT 0.0,
      completed BOOLEAN DEFAULT 0,
      completed_at INTEGER,
      updated_at INTEGER DEFAULT (strftime('%s', 'now')),
      FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE CASCADE,
      FOREIGN KEY (subtopic_id) REFERENCES subtopics(id) ON DELETE CASCADE
    )
  ''');

  await db.execute('''
    CREATE TABLE exercise_attempts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      exercise_id INTEGER NOT NULL,
      selected_answer_index INTEGER NOT NULL,
      is_correct BOOLEAN NOT NULL,
      attempted_at INTEGER DEFAULT (strftime('%s', 'now')),
      FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE
    )
  ''');
    await _pqHelper.createTables(db);
    // Insert sample data
    // await _insertSampleData(db);
  }

  // Insert sample modules
  // Future<void> _insertSampleData(Database db) async {
  //   final sampleModules = [
  //     {
  //       'title': 'Introduction to Flutter',
  //       'description': 'Learn the basics of Flutter development',
  //       'progress': 0.0,
  //     },
  //     {
  //       'title': 'Dart Programming',
  //       'description': 'Master the Dart programming language',
  //       'progress': 0.5,
  //     },
  //     {
  //       'title': 'State Management',
  //       'description': 'Understand different state management approaches',
  //       'progress': 0.0,
  //     },
  //     {
  //       'title': 'API Integration',
  //       'description': 'Learn how to integrate with REST APIs',
  //       'progress': 1.0,
  //     },
  //     {
  //       'title': 'Database with SQLite',
  //       'description': 'Implement local storage using SQLite',
  //       'progress': 0.2,
  //     },
  //   ];

  //   for (final module in sampleModules) {
  //     await db.insert('modules', module);
  //   }
  // }

//   // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Delete database (for testing/reset)
  Future<void> deleteSqlDatabase() async {
    final String path = join(await getDatabasesPath(), _databaseName);
    await deleteDatabase(path);
  }
}