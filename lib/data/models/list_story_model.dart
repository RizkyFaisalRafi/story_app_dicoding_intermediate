import 'package:equatable/equatable.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/list_story.dart';

class ListStoryModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime? createdAt;
  final double? lat;
  final double? lon;

  const ListStoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  /// Fungsi untuk memetakan JSON menjadi ListStoryModel
  factory ListStoryModel.fromJson(Map<String, dynamic> json) {
    return ListStoryModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      photoUrl: json["photoUrl"],
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      lat: json["lat"]?.toDouble(),
      lon: json["lon"]?.toDouble(),
    );
  }

  /// Fungsi untuk memetakan ListStoryModel menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "photoUrl": photoUrl,
      "createdAt": createdAt?.toIso8601String(),
      "lat": lat,
      "lon": lon,
    };
  }

  // Mapping dari model ke entity
  ListStory toEntity() {
    return ListStory(
      id: id,
      name: name,
      description: description,
      photoUrl: photoUrl,
      createdAt: createdAt,
      lat: lat,
      lon: lon,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      photoUrl,
      createdAt,
      lat,
      lon,
    ];
  }
}
