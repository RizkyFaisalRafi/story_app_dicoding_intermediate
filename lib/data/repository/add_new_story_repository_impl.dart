import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/data/data_sources/remote/add_story_remote_datasource.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/add_new_story_entity.dart';
import 'package:story_app_dicoding_intermediate/domain/repositories/add_new_story_repository.dart';

class AddNewStoryRepositoryImpl implements AddNewStoryRepository {
  final AddStoryRemoteDatasource addStoryRemoteDatasource;

  AddNewStoryRepositoryImpl({
    required this.addStoryRemoteDatasource,
  });

  // *Implementasi fungsi untuk menambahkan cerita dengan akun guest
  @override
  Future<Either<Failure, AddNewStoryEntity>> addNewStoryGuest(
    String description,
    List<int> bytes,
    double lat,
    double lon,
    String fileName,
  ) async {
    try {
      // *Memanggil data source untuk menambahkan cerita melalui API
      final response = await addStoryRemoteDatasource.addStoryGuestAccount(
        description,
        bytes,
        lat,
        lon,
        fileName,
      );

      // *Jika API mengembalikan error
      if (response.error == true) {
        return Left(
            ServerFailure('Add New Story Guest failed: ${response.message}'));
      } else {
        log(response.toString()); // *Log respons hasil dari data source

        // *Mengonversi model ke entitas dan mengembalikan hasil sukses
        return Right(response.toEntity());
      }
    } on SocketException {
      // *Menangani No Internet atau Network Issue
      return const Left(ConnectionFailure("failed to connect to the network"));
    } catch (e) {
      // *Menangani kesalahan lainnya yang tidak terduga
      return Left(
          ServerFailure("Kesalahan tidak terduga AddNewStoryRepoImpl: $e"));
    }
  }
}
