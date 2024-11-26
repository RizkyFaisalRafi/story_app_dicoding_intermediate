import '../../domain/entities/login_result.dart';

class LoginResultModel extends LoginResult {
  const LoginResultModel({
    required super.userId,
    required super.name,
    required super.token,
  });

  /// Fungsi untuk memetakan JSON menjadi LoginResultModel
  factory LoginResultModel.fromJson(Map<String, dynamic> json) {
    return LoginResultModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
    );
  }

  /// Fungsi untuk memetakan LoginResultModel menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'token': token,
    };
  }
}
