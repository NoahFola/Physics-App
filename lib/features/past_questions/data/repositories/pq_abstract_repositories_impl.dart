import 'package:newtonium/features/past_questions/domain/entities/pq_entties.dart';
import 'package:newtonium/features/past_questions/domain/repositories/pq_abstract_repository.dart';
import 'package:newtonium/features/past_questions/data/data_sources/local/pq_abstract_local_data_source.dart';
import 'package:newtonium/core/error/exceptions.dart';

/// This is the concrete implementation of the [PastQuestionRepository].
///
/// It acts as the "manager" that we discussed. It doesn't do any
/// database work itself. It "delegates" the call to the
/// [PastQuestionLocalDataSource] (the "worker").
///
/// Its primary job is to handle errors. It will `try` to get data
/// from the data source and `catch` any exceptions, re-throwing
/// them as a clean, custom [CacheException] that the domain layer
/// (Use Cases) can understand and handle.
class PastQuestionRepositoryImpl implements PastQuestionRepository {
  final PastQuestionLocalDataSource localDataSource;

  PastQuestionRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Question>> getQuestions({
    int? year,
    String? topic,
    QuestionType? questionType,
  }) async {
    try {
      return await localDataSource.getQuestions(
        year: year,
        topic: topic,
        questionType: questionType,
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<String>> getAvailableTopics() async {
    try {
      return await localDataSource.getAvailableTopics();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<int>> getAvailableYears() async {
    try {
      return await localDataSource.getAvailableYears();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> savePracticeAttempt({
    required PracticeAttempt attempt,
    required List<AttemptWrongAnswer> wrongAnswers,
  }) async {
    try {
      return await localDataSource.savePracticeAttempt(
        attempt: attempt,
        wrongAnswers: wrongAnswers,
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<PracticeAttempt>> getPracticeAttempts() async {
    try {
      return await localDataSource.getPracticeAttempts();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<Question>> getWrongAnswerQuestions(int attemptId) async {
    try {
      return await localDataSource.getWrongAnswerQuestions(attemptId);
    } catch (e) {
      throw CacheException();
    }
  }
}