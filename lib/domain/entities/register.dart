import 'package:equatable/equatable.dart';

class Register extends Equatable {
  const Register({
    required this.error,
    required this.message,
  });

  final bool error;
  final String message;

  @override
  List<Object> get props => [
        error,
        message,
      ];
}
