import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/add_new_story_entity.dart';

// *Model untuk respons saat menambahkan cerita baru
class AddNewStoryResponseModel extends Equatable {
  final bool error;
  final String message;

  const AddNewStoryResponseModel({required this.error, required this.message});

  // *Factory constructor untuk membuat model dari Map (decoded JSON)
  factory AddNewStoryResponseModel.fromMap(Map<String, dynamic> map) {
    return AddNewStoryResponseModel(
      error: map['error'] ?? false,
      message: map['message'] ?? '',
    );
  }

  // *Factory constructor untuk membuat model dari JSON string
  factory AddNewStoryResponseModel.fromJson(String source) =>
      AddNewStoryResponseModel.fromMap(json.decode(source));

  // *Fungsi untuk memetakan Objek Map menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
    };
  }

  // *Mapping dari model ke Entity Domain
  AddNewStoryEntity toEntity() {
    return AddNewStoryEntity(
      error: error,
      message: message,
    );
  }

  // *Override `props` dari Equatable untuk mendukung perbandingan objek
  @override
  List<Object> get props => [error, message];
}
