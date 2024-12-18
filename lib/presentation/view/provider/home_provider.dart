import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/list_story.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/delete_name_local_usecase.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/delete_token_usecase.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/get_all_story.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/get_token_usecase.dart';
import '../../../common/error/failure.dart';
import '../../../common/state_enum.dart';
import '../../../domain/use_case/delete_email_local_usecase.dart';

class HomeProvider extends ChangeNotifier {
  final GetAllStory getAllStory;
  var _listStory = <ListStory>[];
  List<ListStory> get listStory => _listStory;

  String _errorMessage = '';
  String? get errorMessage => _errorMessage;

  RequestState _state = RequestState.loading;
  RequestState get state => _state;

  final GetTokenUseCase getTokenUseCase;

  final DeleteTokenUseCase _deleteTokenUseCase;
  DeleteTokenUseCase get deleteTokenUseCase => _deleteTokenUseCase;

  final DeleteNameLocalUsecase _deleteNameLocalUsecase;
  DeleteNameLocalUsecase get deleteNameLocalUsecase => _deleteNameLocalUsecase;

  final DeleteEmailLocalUsecase _deleteEmailLocalUsecase;
  DeleteEmailLocalUsecase get deleteEmailLocalUsecase =>
      _deleteEmailLocalUsecase;

  RefreshController refreshC = RefreshController(initialRefresh: false);

  HomeProvider(
    this._deleteTokenUseCase,
    this.getTokenUseCase,
    this._deleteNameLocalUsecase,
    this._deleteEmailLocalUsecase, {
    required this.getAllStory,
  }) {
    loadStories();
  }

  void onRefresh() async {
    try {
      await loadStories();
      refreshC.refreshCompleted();
      notifyListeners();
    } catch (e) {
      notifyListeners();
      refreshC.refreshFailed();
    }
  }

  Future<void> fetchAllStory(String token) async {
    _state = RequestState.loading;
    final listStory = await getAllStory.execute(token);

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
          refreshC.refreshFailed();
          // Tampilkan pesan error ke developer di debug
          log('failure HomeProvider: $_errorMessage');
        },
        (data) {
          _state = RequestState.loaded;
          refreshC.refreshCompleted();
          _listStory = data;
          notifyListeners();
          // Tampilkan pesan sukses di debug
          log('success HomeProvider');
        },
      );
    } catch (e) {
      _state = RequestState.error;
      _errorMessage = "Kesalahan tidak terduga: $e";
      log('Unexpected error: $e');
      notifyListeners();
      refreshC.refreshFailed();
      //  Tampilkan pesan error ke developer di debug
      log('catch HomeProvider: $e');
    }
  }

  Future<void> loadStories() async {
    try {
      final token = await getTokenUseCase.execute();

      if (token != null) {
        log('Token != Null');
        fetchAllStory(token);
      } else {
        log('Token not found');
        throw Exception('Token not found');
      }
    } catch (e) {
      log('Error loading token: $e');
    }
  }
}
