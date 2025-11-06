import 'package:newtonium/features/past_questions/domain/entities/pq_entties.dart';
import 'package:newtonium/features/past_questions/domain/repositories/pq_abstract_repository.dart';
import 'package:newtonium/features/past_questions/domain/usecases/pq_abstract_usecases.dart';

/// This file contains the concrete implementations of all the
/// use cases defined in [pq_abstract_usecases.dart].
///
/// Each class takes the [PastQuestionRepository] (the abstract contract)
/// in its constructor and simply "delegates" the call to the
/// corresponding repository method.

// --- GetFilteredQuestionsUseCase ---
class GetFilteredQuestionsUseCaseImpl implements GetFilteredQuestionsUseCase {
  final PastQuestionRepository repository;

  GetFilteredQuestionsUseCaseImpl({required this.repository});

  @override
  Future<List<Question>> call(QuestionFilterParams params) {
    return repository.getQuestions(
      year: params.year,
      topic: params.topic,
      questionType: params.questionType,
    );
  }
}

// --- GetAvailableTopicsUseCase ---
class GetAvailableTopicsUseCaseImpl implements GetAvailableTopicsUseCase {
  final PastQuestionRepository repository;

  GetAvailableTopicsUseCaseImpl({required this.repository});

  @override
  Future<List<String>> call(NoParams params) {
    return repository.getAvailableTopics();
  }
}

// --- GetAvailableYearsUseCase ---
class GetAvailableYearsUseCaseImpl implements GetAvailableYearsUseCase {
  final PastQuestionRepository repository;

  GetAvailableYearsUseCaseImpl({required this.repository});

  @override
  Future<List<int>> call(NoParams params) {
    return repository.getAvailableYears();
  }
}

// --- SavePracticeAttemptUseCase ---
class SavePracticeAttemptUseCaseImpl implements SavePracticeAttemptUseCase {
  final PastQuestionRepository repository;

  SavePracticeAttemptUseCaseImpl({required this.repository});

  @override
  Future<void> call(SaveAttemptParams params) {
    return repository.savePracticeAttempt(
      attempt: params.attempt,
      wrongAnswers: params.wrongAnswers,
    );
  }
}

// --- GetPracticeAttemptsUseCase ---
class GetPracticeAttemptsUseCaseImpl implements GetPracticeAttemptsUseCase {
  final PastQuestionRepository repository;

  GetPracticeAttemptsUseCaseImpl({required this.repository});

  @override
  Future<List<PracticeAttempt>> call(NoParams params) {
    return repository.getPracticeAttempts();
  }
}

// --- GetWrongAnswerQuestionsUseCase ---
class GetWrongAnswerQuestionsUseCaseImpl
    implements GetWrongAnswerQuestionsUseCase {
  final PastQuestionRepository repository;

  GetWrongAnswerQuestionsUseCaseImpl({required this.repository});

  @override
  Future<List<Question>> call(GetWrongAnswersParams params) {
    return repository.getWrongAnswerQuestions(params.attemptId);
  }
}