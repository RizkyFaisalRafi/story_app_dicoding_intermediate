import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:story_app_dicoding_intermediate/data/models/list_story_model.dart';
import 'package:story_app_dicoding_intermediate/data/models/story_response.dart';

import '../../../common/error/exception.dart';

abstract class StoryRemoteDatasource {
  // Fungsi untuk Get All Story
  Future<List<ListStoryModel>> getAllStory({
    required String token,
  });

  // Fungsi untuk detail story
  Future<ListStoryModel> getDetailStory({
    required String token,
    required String id,
  });
}

class StoryRemoteDatasourceImpl implements StoryRemoteDatasource {
  final http.Client client;

  // URL Endpoint
  final String baseUrl = 'https://story-api.dicoding.dev/v1';

  StoryRemoteDatasourceImpl({required this.client});

  @override
  Future<List<ListStoryModel>> getAllStory({required String token}) async {
    final url = Uri.parse('$baseUrl/stories');

    try {
      final response = await client.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // final data = json.decode(response.body) as Map<String, dynamic>;
        return StoryResponse.fromJson(jsonDecode(response.body)).storyList;
      } else if (response.statusCode == 401) {
        throw const StatusCodeException(message: 'Missing authentication');
      } else {
        // Status kode lain dianggap sebagai error server
        log('Response status: ${response.statusCode}, body: ${response.body}');
        throw StatusCodeException(
            message: 'Failed to Fetch Data ${response.statusCode}');
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
  Future<ListStoryModel> getDetailStory(
      {required String token, required String id}) async {
    final url = Uri.parse('$baseUrl/stories/$id');

    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        log('Response status: ${response.statusCode}, body: ${response.body}');
        // return ListStoryModel.fromJson(jsonDecode(response.body));
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseData['story'] == null) {
          throw ServerException; // Jika data story null
        }
        return ListStoryModel.fromJson(responseData['story']);
      } else if (response.statusCode == 401) {
        log('Response status: ${response.statusCode}, body: ${response.body}');
        throw const StatusCodeException(message: 'Missing authentication');
      } else {
        // Status kode lain dianggap sebagai error server
        log('Response status: ${response.statusCode}, body: ${response.body}');
        throw StatusCodeException(
            message: 'Failed to Fetch Data ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException("No Internet connection");
    }
    // catch (e) {
    //   final response = await client.get(
    //     url,
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Authorization': 'Bearer $token',
    //     },
    //   );
    //   log('Error caught during fetch: $e');
    //   if (e is StatusCodeException) {
    //     rethrow; // Tetap lempar StatusCodeException
    //   } else {
    //     log('Unexpected error details: ${response.body}');
    //     throw ServerException;
    //   }
    // }
  }
}
