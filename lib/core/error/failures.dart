// lib/core/error/failures.dart

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace];

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

// Data-related failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure({
    required String message,
    String? code,
    this.statusCode,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);

  @override
  List<Object?> get props => [message, code, statusCode, stackTrace];
}

// Authentication & Authorization failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

// Module-specific failures
class ModuleNotFoundFailure extends Failure {
  const ModuleNotFoundFailure({
    String? message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
          message: message ?? 'Module not found',
          code: code,
          stackTrace: stackTrace,
        );
}

class ModuleProgressUpdateFailure extends Failure {
  const ModuleProgressUpdateFailure({
    String? message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
          message: message ?? 'Failed to update module progress',
          code: code,
          stackTrace: stackTrace,
        );
}

class ModuleCompletionFailure extends Failure {
  const ModuleCompletionFailure({
    String? message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
          message: message ?? 'Failed to complete module',
          code: code,
          stackTrace: stackTrace,
        );
}

class ModuleDependencyFailure extends Failure {
  const ModuleDependencyFailure({
    String? message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
          message: message ?? 'Module dependencies not satisfied',
          code: code,
          stackTrace: stackTrace,
        );
}

// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

class InvalidProgressValueFailure extends Failure {
  const InvalidProgressValueFailure({
    String? message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
          message: message ?? 'Progress value must be between 0.0 and 1.0',
          code: code,
          stackTrace: stackTrace,
        );
}

// Platform-specific failures
class PlatformFailure extends Failure {
  const PlatformFailure({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

// Unknown/generic failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    String? message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
          message: message ?? 'An unknown error occurred',
          code: code,
          stackTrace: stackTrace,
        );
}

// No data failures
class NoDataFailure extends Failure {
  const NoDataFailure({
    String? message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
          message: message ?? 'No data available',
          code: code,
          stackTrace: stackTrace,
        );
}

// Connection failures
class ConnectionFailure extends Failure {
  const ConnectionFailure({
    String? message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
          message: message ?? 'No internet connection',
          code: code,
          stackTrace: stackTrace,
        );
}

// Timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String? message,
    String? code,
    StackTrace? stackTrace,
  }) : super(
          message: message ?? 'Request timed out',
          code: code,
          stackTrace: stackTrace,
        );
}