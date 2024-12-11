import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/add_new_story_entity.dart';

// *Abstraksi Repository untuk Add New Story
abstract class AddNewStoryRepository {
  // *Add New Story Guest
  Future<Either<Failure, AddNewStoryEntity>> addNewStoryGuest(
    String description,
    List<int> bytes,
    double lat,
    double lon,
    String fileName,
  );

  // *Add New Story User
  // Future<Either<Failure, AddNewStory>> addNewStoryUser();
}
