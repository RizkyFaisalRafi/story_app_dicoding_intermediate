import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/add_new_story_entity.dart';
import 'package:story_app_dicoding_intermediate/domain/repositories/add_new_story_repository.dart';

// *Use case untuk menambahkan cerita menggunakan akun guest
class PostAddGuestStory {
  final AddNewStoryRepository addNewStoryRepository;

  PostAddGuestStory(this.addNewStoryRepository);

  // *Fungsi untuk menjalankan use case
  Future<Either<Failure, AddNewStoryEntity>> execute(
    String description,
    List<int> bytes,
    double lat,
    double lon,
    String fileName,
  ) async {
    // *Memanggil fungsi dari repository untuk menambahkan cerita
    return await addNewStoryRepository.addNewStoryGuest(
      description,
      bytes,
      lat,
      lon,
      fileName,
    );
  }
}
