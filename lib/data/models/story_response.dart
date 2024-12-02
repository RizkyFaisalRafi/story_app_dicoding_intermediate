import 'package:equatable/equatable.dart';
import 'package:story_app_dicoding_intermediate/data/models/list_story_model.dart';

class StoryResponse extends Equatable {
  final List<ListStoryModel> storyList;

  const StoryResponse({
    required this.storyList,
  });

  factory StoryResponse.fromJson(Map<String, dynamic> json) => StoryResponse(
        storyList: List<ListStoryModel>.from((json["listStory"] as List)
            .map((x) => ListStoryModel.fromJson(x))
            .where((element) => element.createdAt != null)),
      );

  @override
  List<Object> get props => [storyList];
}
