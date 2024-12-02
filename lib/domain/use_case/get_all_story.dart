import 'package:dartz/dartz.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/list_story.dart';
import 'package:story_app_dicoding_intermediate/domain/repositories/story_repository.dart';

import '../../common/error/failure.dart';

class GetAllStory {
  final StoryRepository storyRepository;

  GetAllStory({required this.storyRepository});

  // Menjalankan proses Get Data All Story
  Future<Either<Failure, List<ListStory>>> execute(String token) async {
    return storyRepository.getAllStory(token: token);
  }
}
