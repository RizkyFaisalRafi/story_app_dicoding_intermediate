import 'package:dartz/dartz.dart';
import '../../common/error/failure.dart';
import '../entities/login_result.dart';
import '../entities/register.dart';

abstract class AuthRepository {
  // Login
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
  });

  // Register
  Future<Either<Failure, Register>> register({
    required String name,
    required String email,
    required String password,
  });
}
