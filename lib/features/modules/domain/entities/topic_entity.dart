class Topic {
  final String id;
  final String moduleCode;
  final String title;
  final int order;
  final Subtopic subTopics;

  Topic({
    required this.id,
    required this.moduleCode,
    required this.title,
    required this.order,
    Subtopic? subTopics, // Make parameter optional
  }) : subTopics = subTopics ?? Subtopic( // Default empty subtopic
    id: '',
    topicId: '',
    title: 'No content available',
    order: 0,
    contentSections: 'Content will be added soon',
    exercises: [],
  );
}

class Subtopic {
  final String id;
  final String topicId;
  final String title;
  final int order;
  final String contentSections;
  final List<Exercise> exercises;

  Subtopic({
    required this.id,
    required this.topicId,
    required this.title,
    required this.order,
    required this.contentSections,
    required this.exercises,
  });
}

class Exercise {
  final String id;
  final String question;
  final String? codeTemplate;
  final List<String> options; // For multiple choice
  final int correctAnswerIndex; // For multiple choice
  final String? explanation;

  Exercise({
    required this.id,
    required this.question,
    this.codeTemplate,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });
}