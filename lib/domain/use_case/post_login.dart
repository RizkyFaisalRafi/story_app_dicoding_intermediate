import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/domain/repositories/auth_repository.dart';
import '../../common/error/failure.dart';
import '../entities/login_result.dart';

class PostLogin {
  final AuthRepository authRepository;

  PostLogin(
    this.authRepository,
  );

  // Menjalankan proses login
  Future<Either<Failure, LoginResult>> execute(String email, String password) {
    return authRepository.login(
      email: email,
      password: password,
    );
  }
}
