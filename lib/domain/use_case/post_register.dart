import 'package:dartz/dartz.dart';
import '../../common/error/failure.dart';
import '../entities/register.dart';
import '../repositories/auth_repository.dart';

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
