import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/common/error/exception.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/data/data_sources/remote/auth_remote_datasource.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/login_result.dart';
import 'package:story_app_dicoding_intermediate/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result =
          await remoteDataSource.login(email: email, password: password);
      if (result.error) {
        return Left(ServerFailure('Login failed: ${result.message}'));
      } else {
        return Right(result.loginResult!);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure("Server error: ${e.message}"));
    } on SocketException {
      // Menangani No Internet atau Network Issue
      return const Left(ConnectionFailure("Failed to connect to the network"));
    }
  }
  
  @override
  Future<Either<Failure, LoginResult>> register({required String name, required String email, required String password}) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
