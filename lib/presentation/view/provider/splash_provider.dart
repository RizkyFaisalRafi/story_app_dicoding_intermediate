import 'package:flutter/material.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/is_auth_usecase.dart';

class SplashProvider extends ChangeNotifier {
  final IsAuthUsecase _isAuthUsecase;

  SplashProvider(this._isAuthUsecase);

  // Getter
  IsAuthUsecase get isAuthUsecase => _isAuthUsecase;

}
