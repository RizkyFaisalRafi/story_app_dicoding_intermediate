import 'package:dartz/dartz.dart';

import '../../common/error/failure.dart';
import '../entities/list_story.dart';

abstract class StoryRepository {
  // Get All Story
  Future<Either<Failure, List<ListStory>>> getAllStory({
    required String token,
  });

  // Detail Story
}
