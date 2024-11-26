import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:story_app_dicoding_intermediate/common/error/exception.dart';
import 'package:story_app_dicoding_intermediate/data/models/login_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:story_app_dicoding_intermediate/data/models/register_response_model.dart';

abstract class AuthRemoteDatasource {
  /// Fungsi untuk login dengan email dan password
  Future<LoginResponseModel> login(
      {required String email, required String password});

  /// Fungsi untuk register dengan name, email dan password
  Future<RegisterResponseModel> register(
      {required String name, required String email, required String password});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final http.Client client;
  // URL endpoint
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
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await client.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      log('Request to $url with body: $body');

      if (response.statusCode == 200) {
        log('Response status: ${response.statusCode}, body: ${response.body}');
        return LoginResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        // Unauthorized (Email/Password salah)
        log('Response status: ${response.statusCode}, body: ${response.body}');
        throw const StatusCodeException(message: 'user not found');
      } else if (response.statusCode == 400) {
        // Invalid request payload JSON format
        log('Response status: ${response.statusCode}, body: ${response.body}');
        throw const StatusCodeException(
            message: 'Invalid request payload JSON format');
      } else {
        // Status kode lain dianggap sebagai error server
        log('Response status: ${response.statusCode}, body: ${response.body}');
        throw StatusCodeException(
            message: 'Failed to login ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException("No Internet connection");
    } catch (e) {
      if (e is StatusCodeException) {
        rethrow; // Tetap lempar StatusCodeException
      } else {
        throw ServerException;
      }
    }
  }

  @override
  Future<RegisterResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    });

    try {
      final response = await client.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        log('Response status: ${response.statusCode}, body: ${response.body}');
        return RegisterResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.body.contains('Email is already taken')) {
        // Email is already taken (400)
        log('Response status: ${response.statusCode}, body: ${response.body}');
        throw const StatusCodeException(message: 'Email is already taken');
      } else if (response.body
          .contains('Invalid request payload JSON format')) {
        // Invalid request payload JSON format (400)
        log('Response status: ${response.statusCode}, body: ${response.body}');
        throw const StatusCodeException(
            message: 'Invalid request payload JSON format');
      } else {
        // Status kode lain dianggap sebagai error server
        log('Response status: ${response.statusCode}, body: ${response.body}');
        throw StatusCodeException(
            message: 'Failed to register ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException("No Internet connection");
    } catch (e) {
      if (e is StatusCodeException) {
        rethrow; // Tetap lempar StatusCodeException
      } else {
        throw ServerException;
      }
    }
  }
}
