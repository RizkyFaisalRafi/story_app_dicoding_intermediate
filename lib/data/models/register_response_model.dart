import 'package:equatable/equatable.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/register.dart';

class RegisterResponseModel extends Equatable {
  final bool error;
  final String message;

  const RegisterResponseModel({
    required this.error,
    required this.message,
  });

  /// Konversi dari JSON ke Model
  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      error: json['error'],
      message: json['message'],
    );
  }

  /// Konversi dari Model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
    };
  }

  /// Mapping dari Model ke Entity
  Register toEntity() {
    return Register(
      error: error,
      message: message,
    );
  }

  @override
  List<Object> get props => [error, message];
}
