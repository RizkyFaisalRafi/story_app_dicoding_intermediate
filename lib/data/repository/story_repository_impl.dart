import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/common/error/exception.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/data/data_sources/remote/story_remote_datasource.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/list_story.dart';
import 'package:story_app_dicoding_intermediate/domain/repositories/story_repository.dart';

class StoryRepositoryImpl extends StoryRepository {
  final StoryRemoteDatasource storyRemoteDatasource;

  StoryRepositoryImpl({required this.storyRemoteDatasource});

  @override
  Future<Either<Failure, List<ListStory>>> getAllStory({
    required String token,
  }) async {
    try {
      final response = await storyRemoteDatasource.getAllStory(token: token);
      return Right(response.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure("Kesalahan tidak terduga: $e"));
    }
  }
}
