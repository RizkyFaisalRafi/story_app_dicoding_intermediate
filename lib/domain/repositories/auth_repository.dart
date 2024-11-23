import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/login_result.dart';

abstract class AuthRepository {
  // Login
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
  });

  // Register
}
