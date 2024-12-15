import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/domain/repositories/add_new_story_repository.dart';
import '../entities/add_new_story_entity.dart';

class PostAddUserStory {
  final AddNewStoryRepository addNewStoryRepository;

  PostAddUserStory(this.addNewStoryRepository);

  // *Fungsi untuk menjalankan use case
  Future<Either<Failure, AddNewStoryEntity>> execute(
    String description,
    List<int> bytes,
    double lat,
    double lon,
    String fileName,
    String token,
  ) async {
    // *Memanggil fungsi dari repository untuk menambahkan cerita
    return await addNewStoryRepository.addNewStoryUser(
      description,
      bytes,
      lat,
      lon,
      fileName,
      token,
    );
  }
}
