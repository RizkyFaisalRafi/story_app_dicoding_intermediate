import 'dart:convert';
import 'dart:developer';

import 'package:story_app_dicoding_intermediate/common/error/exception.dart';
import 'package:story_app_dicoding_intermediate/data/models/login_response_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDatasource {
  /// Fungsi untuk login dengan email dan password
  Future<LoginResponseModel> login(
      {required String email, required String password});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final http.Client client;
  // URL endpoint login
  final String baseUrl = 'https://story-api.dicoding.dev/v1';

  AuthRemoteDatasourceImpl({
    required this.client,
  });

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await client.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        // Unauthorized (Email/Password salah)
        throw const StatusCodeException(message: 'unauthorized');
      } else {
        // Status kode lain dianggap sebagai error server
        log(response.statusCode.toString());
        throw const ServerException(message: 'Failed to login');
      }
    } on http.ClientException {
      // Network error, seperti no internet
      throw const ServerException(message: 'No internet connection');
    } catch (e) {
      // Error tak terduga
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}
