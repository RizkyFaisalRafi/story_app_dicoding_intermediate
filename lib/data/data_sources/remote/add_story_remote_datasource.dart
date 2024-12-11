import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:story_app_dicoding_intermediate/data/models/add_new_story_response_model.dart';
import '../../../common/error/exception.dart';

// *Abstraksi data source untuk menambahkan cerita melalui API
abstract class AddStoryRemoteDatasource {
  // *Fungsi untuk add story guest account
  Future<AddNewStoryResponseModel> addStoryGuestAccount(
    String description,
    List<int> bytes,
    double lat,
    double lon,
    String fileName,
  );

  // *Fungsi untuk add story user account
  Future<void> addStoryUserAccount(
    String description,
    String photo,
    double lat,
    double lon,
  );
}

// *Implementasi dari AddStoryRemoteDatasource
class AddStoryRemoteDatasourceImpl implements AddStoryRemoteDatasource {
  final http.Client client;
  final String baseUrl = 'https://story-api.dicoding.dev/v1';

  AddStoryRemoteDatasourceImpl({
    required this.client,
  });

  // *Implementasi fungsi untuk menambahkan cerita menggunakan akun guest
  @override
  Future<AddNewStoryResponseModel> addStoryGuestAccount(
    String description,
    List<int> bytes, // Data file gambar dalam bentuk byte array
    double lat, // Optional
    double lon, // Optional
    String fileName,
  ) async {
    // *URL endpoint untuk akun guest
    const String url = "https://story-api.dicoding.dev/v1/stories/guest";
    final uri = Uri.parse(url);

    // *Membuat permintaan HTTP multipart
    var request = http.MultipartRequest('POST', uri);

    // *Menambahkan file gambar sebagai multipart
    final multiPartFile = http.MultipartFile.fromBytes(
      'photo',
      bytes,
      filename: fileName,
    );

    // *Menambahkan deskripsi ke body permintaan
    final Map<String, String> fields = {
      "description": description,
    };

    // *Header untuk multipart request
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
    };

    // *Menambahkan file, field, dan header ke permintaan
    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    // *Mengirim permintaan ke server dan menunggu respons
    final http.StreamedResponse streamedResponse = await request.send();
    // *Membaca respons dalam bentuk lengkap
    final response = await http.Response.fromStream(streamedResponse);

    // *Jika status kode 201 (berhasil dibuat)
    if (response.statusCode == 201) {
      // *Log informasi respons
      log('Response status: ${response.statusCode}, body: ${response.body}');

      // *Parsing JSON respons ke dalam model
      final AddNewStoryResponseModel uploadResponse =
          AddNewStoryResponseModel.fromJson(
        response.body,
      );

      return uploadResponse; // *Mengembalikan model hasil respons
    } else {
      // *Jika status kode tidak sesuai, lemparkan exception
      log('Response status: ${response.statusCode}, body: ${response.body}');
      throw StatusCodeException(
          message: 'Failed to Upload Document ${response.statusCode}');
    }
  }

  // *Implementasi fungsi untuk menambahkan cerita menggunakan akun user
  @override
  Future<void> addStoryUserAccount(
      String description, String photo, double lat, double lon) {
    // TODO: implement addStoryUserAccount

    throw UnimplementedError();
  }
}
