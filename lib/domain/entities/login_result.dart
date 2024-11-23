import 'package:equatable/equatable.dart';

class LoginResult extends Equatable {
  const LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  final String userId;
  final String name;
  final String token;

  @override
  List<Object> get props => [
        userId,
        name,
        token,
      ];
}
