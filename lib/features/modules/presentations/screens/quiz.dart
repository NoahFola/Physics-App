import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/topic_entity.dart';
import '../bloc/module_bloc.dart';
import '../widgets/quiz_widgets.dart';

// Screen from Screenshots: ...164747.jpg, ...164757.jpg
// This is a stateful widget to manage the PageController and local answer selection

class QuizScreen extends StatefulWidget {
  final List<Exercise> exercises;

  const QuizScreen({
    super.key,
    required this.exercises,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late PageController _pageController;
  // Locally stores the selected option index for the *current* page
  int? _selectedOptionIndex;
  // Stores the final answers for submission
  late Map<String, int> _answers;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _answers = {};
    _pageController.addListener(() {
      setState(() {
         _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  void _onOptionSelected(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
  }
  
  void _nextPage(Exercise currentExercise) {
    if (_selectedOptionIndex == null) {
      // Show error: must select an answer
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an answer.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Store the answer
    _answers[currentExercise.id] = _selectedOptionIndex!;
    
    // Clear selection for next page
    setState(() {
       _selectedOptionIndex = null;
    });
    
    // Move to next page
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
  
  void _previousPage() {
    // Clear selection
     setState(() {
       _selectedOptionIndex = null;
    });
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _submitQuiz(BuildContext blocContext) {
     final Exercise currentExercise = widget.exercises[_currentPage];
     if (_selectedOptionIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an answer before submitting.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
     }
     
     // Store the last answer
    _answers[currentExercise.id] = _selectedOptionIndex!;
    
    // Dispatch all answers to the BLoC
    // Your BLoC is designed to submit one by one.
    // A better design might be a `SubmitQuizEvent(Map<String, int> answers)`
    // But working with your current BLoC:
    int correctCount = 0;
    for (var entry in _answers.entries) {
      final exercise = widget.exercises.firstWhere((e) => e.id == entry.key);
      if (exercise.correctAnswerIndex == entry.value) {
        correctCount++;
      }
      // We dispatch this, but the UI won't listen to each one.
      // We just care about the *final* result.
      blocContext.read<ModuleBloc>().add(SubmitExerciseAnswerEvent(
            exerciseId: entry.key,
            selectedAnswerIndex: entry.value,
          ));
    }

    // Show a results dialog
    _showResultDialog(correctCount, widget.exercises.length);
  }
  
  void _showResultDialog(int correct, int total) {
     showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Quiz Complete!', style: Theme.of(context).textTheme.titleLarge),
        content: Text('You scored $correct out of $total.', style: Theme.of(context).textTheme.bodyLarge),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back from quiz screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFirstPage = _currentPage == 0;
    final bool isLastPage = _currentPage == widget.exercises.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                '${_currentPage + 1}/${widget.exercises.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Linear progress
          QuizProgressIndicator(
            currentPage: _currentPage,
            totalQuestions: widget.exercises.length,
          ),
          
          // PageView for questions
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swiping
              itemCount: widget.exercises.length,
              itemBuilder: (context, index) {
                final exercise = widget.exercises[index];
                final optionText = exercise.options[index];
  
                // ADD THESE DEBUG PRINTS:
                print('=== OPTION DEBUG ===');
                print('Index: $index');
                print('Option text: "$optionText"');
                print('Options list: ${exercise.options}');
                print('Options length: ${exercise.options.length}');
                print('Options type: ${exercise.options.runtimeType}');
                print('===================');   
                return QuizQuestionWidget(
                  exercise: exercise,
                  selectedOptionIndex: _selectedOptionIndex,
                  onOptionSelected: _onOptionSelected,
                );
              },
            ),
          ),
          
          // Page indicators (circles)
          QuizPageIndicator(
             currentPage: _currentPage,
             totalQuestions: widget.exercises.length,
          ),
          
          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                // Previous Button
                if (!isFirstPage)
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      onPressed: _previousPage,
                    ),
                  ),
                if (!isFirstPage) const SizedBox(width: 16.0),
                
                // Next / Submit Button
                Expanded(
                  child: BlocBuilder<ModuleBloc, ModuleState>(
                    builder: (blocContext, state) {
                      return ElevatedButton.icon(
                        icon: Icon(isLastPage ? Icons.send_outlined : Icons.arrow_forward),
                        label: Text(isLastPage ? 'Submit Quiz' : 'Next'),
                        onPressed: () {
                          if (isLastPage) {
                            _submitQuiz(blocContext);
                          } else {
                             _nextPage(widget.exercises[_currentPage]);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
