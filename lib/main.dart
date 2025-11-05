import 'package:flutter/material.dart';
import './features/modules/di/service_locator.dart' as di;
import './presentations/main_screen.dart'; // Your MainShell
import './features/modules/presentations/screens/module_details.dart';
import './features/modules/presentations/screens/lesson_content.dart';
import './features/modules/presentations/screens/quiz.dart';
import './features/modules/domain/entities/module_entity.dart';
import './features/modules/domain/entities/topic_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/modules/presentations/bloc/module_bloc.dart';
import 'core/database/database_service.dart';
import 'features/modules/data/data_sources/local/seeders/module_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Show loading screen immediately
  runApp(const LoadingApp());
  
  // Initialize in background
  await _initializeApp();
}

class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Loading...')),
      ),
    );
  }
}

Future<void> _initializeApp() async {
  final dbService = DatabaseService();
  // Delete old database
  await dbService.deleteSqlDatabase();
  final db = await dbService.database;
  await ModuleSeeder.seed(db);
  await di.init();
  
  // Switch to main app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ModuleBloc>()..add(LoadModulesEvent()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // Using a dark theme to match your screenshots
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: Colors.blueAccent, // Example primary color
          cardColor: const Color(0xFF1E1E1E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1E1E1E),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        
        // We use `initialRoute` instead of `home` when using `onGenerateRoute`
        initialRoute: '/',
        onGenerateRoute: (settings) {
          // This function handles all your `Navigator.pushNamed` calls
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const MainShell());
      
            case '/module':
              // Get the module passed from ModuleListItem
              final module = settings.arguments as ModuleEntity;
              return MaterialPageRoute(
                builder: (_) => ModuleDetailScreen(module: module),
              );
      
            case '/lesson':
              // Get the topic passed from TopicListItem
              // Note: It's passed as a Map in your code
              final args = settings.arguments as Map<String, dynamic>;
              final topic = args['topic'] as Topic;
              return MaterialPageRoute(
                builder: (_) => LessonScreen(topic: topic),
              );
      
            case '/quiz':
              // Get the exercises passed from LessonScreen or TopicListItem
              final exercises = settings.arguments as List<Exercise>;
              return MaterialPageRoute(
                builder: (_) => QuizScreen(exercises: exercises),
              );
      
            default:
              // Fallback for unknown routes
              return MaterialPageRoute(builder: (_) => const MainShell());
          }
        },
      ),
    );
  }
}