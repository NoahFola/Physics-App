import 'package:flutter/material.dart';
import '../../domain/entities/topic_entity.dart';

// --- Linear Progress Bar ---
class QuizProgressIndicator extends StatelessWidget {
  final int currentPage;
  final int totalQuestions;

  const QuizProgressIndicator({
    super.key,
    required this.currentPage,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (currentPage + 1) / totalQuestions;
    return LinearProgressIndicator(
      value: progress,
      minHeight: 6.0,
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}

// --- Question Widget (Holder for question and options) ---
class QuizQuestionWidget extends StatelessWidget {
  final Exercise exercise;
  final int? selectedOptionIndex;
  final ValueChanged<int> onOptionSelected;

  const QuizQuestionWidget({
    super.key,
    required this.exercise,
    required this.selectedOptionIndex,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Text
          Text(
            exercise.question,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32.0),
          
          // Options
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: exercise.options.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              final optionText = exercise.options[index];
              return QuizOptionWidget(
                text: optionText,
                letter: String.fromCharCode(65 + index), // A, B, C, D
                isSelected: selectedOptionIndex == index,
                onTap: () {
                  onOptionSelected(index);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- Single Option Widget ---
class QuizOptionWidget extends StatelessWidget {
  final String text;
  final String letter;
  final bool isSelected;
  final VoidCallback onTap;

  const QuizOptionWidget({
    super.key,
    required this.text,
    required this.letter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color selectedColor = theme.primaryColor;
    final Color defaultColor = theme.cardColor;
    final Color borderColor = isSelected ? selectedColor : (Colors.grey[700]!);
    final Color letterColor = isSelected ? Colors.white : theme.primaryColor;
    final Color letterBgColor = isSelected ? selectedColor : defaultColor;

    return Card(
      elevation: 0,
      color: isSelected ? selectedColor.withOpacity(0.1) : defaultColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: borderColor,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Letter Circle
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: letterBgColor,
                  border: Border.all(color: letterColor, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: letterColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              
              // Option Text
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isSelected ? Colors.white : Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// --- Page Indicator Circles ---
class QuizPageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalQuestions;

  const QuizPageIndicator({
    super.key,
    required this.currentPage,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalQuestions,
        (index) {
          final bool isActive = index == currentPage;
          return Container(
            width: 10.0,
            height: 10.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? Theme.of(context).primaryColor
                  : Colors.grey[700],
            ),
          );
        },
      ),
    );
  }
}
