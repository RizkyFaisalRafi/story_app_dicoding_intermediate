import 'package:equatable/equatable.dart';
import 'login_result_model.dart';

class LoginResponseModel extends Equatable {
  final bool error;
  final String message;
  final LoginResultModel? loginResult;

  const LoginResponseModel({
    required this.error,
    required this.message,
    this.loginResult,
  });

  /// Fungsi untuk memetakan JSON menjadi LoginResponseModel
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      error: json['error'] as bool,
      message: json['message'] as String,
      loginResult: json['loginResult'] != null
          ? LoginResultModel.fromJson(
              json['loginResult'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Fungsi untuk memetakan LoginResponseModel menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'loginResult': loginResult?.toJson(),
    };
  }

  @override
  List<Object?> get props => [error, message, loginResult];
}
