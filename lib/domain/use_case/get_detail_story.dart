import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/list_story.dart';
import 'package:story_app_dicoding_intermediate/domain/repositories/story_repository.dart';

class GetDetailStory {
  final StoryRepository storyRepository;

  GetDetailStory({required this.storyRepository});

  // Menjalankan proses GetDetailStory
  Future<Either<Failure, ListStory>> execute(String id, String token) async {
    return await storyRepository.getDetailStory(
      id: id,
      token: token,
    );
  }
}
