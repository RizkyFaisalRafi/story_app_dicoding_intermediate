import 'package:equatable/equatable.dart';

class ListStory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime? createdAt;
  final double? lat;
  final double? lon;

  const ListStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

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
