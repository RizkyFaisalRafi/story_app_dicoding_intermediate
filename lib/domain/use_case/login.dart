import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:story_app_dicoding_intermediate/domain/repositories/auth_repository.dart';

import '../../common/error/failure.dart';
import '../entities/login_result.dart';

class Login {
  final AuthRepository authRepository;

  Login(this.authRepository);

  // Menjalankan proses login
  Future<Either<Failure, LoginResult>> execute(LoginParams params) {
    return authRepository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameter untuk login
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
