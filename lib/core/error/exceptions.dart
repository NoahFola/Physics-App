/// Represents errors that occur during local database operations.
///
/// The [PastQuestionRepositoryImpl] will catch `DatabaseException` from
/// `sqflite` and re-throw this custom [CacheException].
/// The Use Cases will then be responsible for catching this exception.
class CacheException implements Exception {}