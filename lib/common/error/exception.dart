import 'package:equatable/equatable.dart';

class GeneralException extends Equatable implements Exception {
  final String message;

  const GeneralException({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'GeneralException: $message';
}

class ServerException extends Equatable implements Exception {
  final String message;

  const ServerException({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'ServerException: $message';
}

class StatusCodeException extends Equatable implements Exception {
  final String message;

  const StatusCodeException({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'StatusCodeException: $message';
}

class EmptyException extends Equatable implements Exception {
  final String message;

  const EmptyException({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'EmptyException: $message';
}
