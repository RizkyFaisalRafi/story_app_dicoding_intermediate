import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/register.dart';
import 'package:story_app_dicoding_intermediate/domain/repositories/auth_repository.dart';

class PostRegister {
  final AuthRepository authRepository;

  PostRegister(this.authRepository);

  // Menjalankan proses register
  Future<Either<Failure, Register>> execute(
    String name,
    String email,
    String password,
  ) {
    return authRepository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
