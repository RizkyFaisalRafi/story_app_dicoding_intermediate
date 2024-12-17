import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/list_story.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/delete_name_local_usecase.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/delete_token_usecase.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/get_all_story.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/get_token_usecase.dart';
import '../../../common/error/failure.dart';
import '../../../common/state_enum.dart';

class HomeProvider extends ChangeNotifier {
  final GetAllStory getAllStory;
  var _listStory = <ListStory>[];
  List<ListStory> get listStory => _listStory;

  String _errorMessage = '';
  String? get errorMessage => _errorMessage;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  final GetTokenUseCase getTokenUseCase;

  final DeleteTokenUseCase _deleteTokenUseCase;
  DeleteTokenUseCase get deleteTokenUseCase => _deleteTokenUseCase;

  final DeleteNameLocalUsecase _deleteNameLocalUsecase;
  DeleteNameLocalUsecase get deleteNameLocalUsecase => _deleteNameLocalUsecase;

  HomeProvider(
    this._deleteTokenUseCase,
    this.getTokenUseCase,
    this._deleteNameLocalUsecase, {
    required this.getAllStory,
  });

  Future<void> fetchAllStory(BuildContext context, String token) async {
    final listStory = await getAllStory.execute(token);
    _state = RequestState.loading;
    notifyListeners();

    try {
      listStory.fold(
        (failure) {
          _state = RequestState.error;
          _errorMessage = failure.message;
          log('Home Provider: $_errorMessage');

          // Cek tipe kegagalan dan berikan pesan kesalahan yang lebih spesifik
          if (failure is ServerFailure) {
            if (failure.message.contains('Missing authentication')) {
              _errorMessage = 'Anda belun Log In';
            } else {
              log(failure.message);
              _errorMessage = 'Gagal mengambil data story';
            }
          } else if (failure is ConnectionFailure) {
            _errorMessage =
                'Tidak dapat terhubung ke server. Periksa koneksi internet Anda! $failure';
          } else {
            _errorMessage = 'Terjadi kesalahan saat mengambil data story';
          }
          notifyListeners();

          // Tampilkan pesan error ke pengguna
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_errorMessage),
            backgroundColor: Colors.red,
          ));
        },
        (data) {
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
      _errorMessage = "Kesalahan tidak terduga: $e";
      log('Unexpected error: $e');
      notifyListeners();

      // Pesan default untuk error yang tidak diketahui
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Terjadi kesalahan tidak terduga: $e"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> loadStories(BuildContext context) async {
    try {
      final token = await getTokenUseCase.execute();

      if (token != null) {
        log('Token != Null');
        if (context.mounted) {
          fetchAllStory(context, token);
        }
      } else {
        log('Token not found');
        throw Exception('Token not found');
      }
    } catch (e) {
      log('Error loading token: $e');
    }
  }
}
