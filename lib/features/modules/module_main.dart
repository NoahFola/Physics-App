import 'package:flutter/material.dart';
import './presentations/screens/module_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/di/service_locator.dart' as di;
import '../modules/presentations/bloc/module_bloc.dart';

// This widget holds the BottomNavigationBar and the main content pages.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 1; // Default to "Lessons" tab

  static const List<Widget> _widgetOptions = <Widget>[
    PlaceholderScreen(title: 'Home'),
    ModulesScreen(), // Our main screen
    PlaceholderScreen(title: 'Past Questions'),
    PlaceholderScreen(title: 'AI Tutor'),
    PlaceholderScreen(title: 'Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (context) => di.sl<ModuleBloc>()..add(LoadModulesEvent()),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Lessons',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer_outlined),
              label: 'Past Que...',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy_outlined),
              label: 'AI Tutor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// A placeholder widget for other tabs
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
