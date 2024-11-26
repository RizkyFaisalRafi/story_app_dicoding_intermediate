import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/common/error/exception.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/data/data_sources/remote/auth_remote_datasource.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/login_result.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/register.dart';
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
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );

      if (result.error) {
        return Left(ServerFailure('Login failed: ${result.message}'));
      } else {
        return Right(result.loginResult as LoginResult);
      }
    } on StatusCodeException catch (e) {
      if (e.message.contains("user not found")) {
        return const Left(
            ServerFailure("Email atau password salah / user not found."));
      } else if (e.message.contains('Invalid request payload JSON format')) {
        return const Left(
            ServerFailure('Invalid request payload JSON format.'));
      } else {
        return Left(ServerFailure("Gagal login: ${e.message}"));
      }
    } on SocketException {
      // Menangani No Internet atau Network Issue
      return const Left(ConnectionFailure("failed to connect to the network"));
    } catch (e) {
      return Left(ServerFailure("Kesalahan tidak terduga: $e"));
    }
  }

  @override
  Future<Either<Failure, Register>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );

      if (result.error) {
        return Left(ServerFailure('Register failed: ${result.message}'));
      } else {
        // Mapping RegisterResponseModel ke Register
        // final register = Register(
        //   message: result.message,
        //   error: result.error,
        // );
        log(register.toString());
        // return Right(register);
        return Right(result.toEntity());
      }
    } on StatusCodeException catch (e) {
      if (e.message.contains("Email is already taken")) {
        return const Left(ServerFailure("Email is already taken"));
      } else if (e.message.contains('Invalid request payload JSON format')) {
        return const Left(ServerFailure('Invalid request payload JSON format'));
      } else {
        return Left(ServerFailure("Gagal register: ${e.message}"));
      }
    } on SocketException {
      // Menangani No Internet atau Network Issue
      return const Left(ConnectionFailure("failed to connect to the network"));
    } catch (e) {
      return Left(ServerFailure("Kesalahan tidak terduga: $e"));
    }
  }
}
