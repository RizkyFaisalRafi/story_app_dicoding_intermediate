import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/list_story.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/get_detail_story.dart';
import '../../../common/state_enum.dart';
import '../../../domain/use_case/get_token_usecase.dart';

class DetailProvider extends ChangeNotifier {
  final GetDetailStory getDetailStory;
  final GetTokenUseCase getTokenUseCase;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  String _errorMessage = '';
  String? get errorMessage => _errorMessage;

  ListStory? _listStory;
  ListStory? get listStory => _listStory;

  DetailProvider(this.getTokenUseCase, {required this.getDetailStory});

  Future<void> fetchDetail(BuildContext context, String id) async {
    try {
      final token = await getTokenUseCase.execute();

      if (token == null || token.isEmpty) {
        throw const ServerFailure('Token tidak valid atau kosong.');
      }

      final response = await getDetailStory.execute(id, token);
      _state = RequestState.loading;
      notifyListeners();
      log('Test Woy: $id');

      response.fold(
        (failure) {
          _state = RequestState.error;
          _errorMessage = failure.message;
          // log('Detail Provider: $_errorMessage');
          log('Failure: ${failure.message}');

          if (failure is ServerFailure) {
            if (failure.message.contains('Failed to Fetch Data')) {
              _errorMessage = 'Gagal mengambil data detail story dari server';
            } else {
              _errorMessage = 'Kesalahan server: ${failure.message}';
            }
          } else if (failure is ConnectionFailure) {
            _errorMessage =
                'Tidak dapat terhubung ke server. Periksa koneksi internet Anda! $failure';
          } else {
            _errorMessage =
                'Terjadi kesalahan tidak terduga: ${failure.message}';
          }
          notifyListeners();
          // Tampilkan pesan error ke pengguna
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_errorMessage),
            backgroundColor: Colors.red,
          ));
        },
        (data) {
          log('Success: ${data.toString()}');
          _state = RequestState.loaded;
          _listStory = data;
          notifyListeners();

          // Tampilkan pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sukses Get Data'),
            backgroundColor: Colors.green,
          ));
        },
      );
    } catch (e) {
      _state = RequestState.error;
      _errorMessage = "Kesalahan tidak terduga Detail Prov: $e";
      log('Detail Provider Catch: $_errorMessage');
      notifyListeners();

      // Pesan default untuk error yang tidak diketahui
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Terjadi kesalahan tidak terduga detail prov: $e"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
