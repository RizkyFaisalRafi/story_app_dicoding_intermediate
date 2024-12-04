import 'package:story_app_dicoding_intermediate/domain/repositories/token_repository.dart';

class IsAuthUsecase {
  final TokenRepository repository;

  IsAuthUsecase(this.repository);

  Future<bool> execute() async {
    return await repository.isAuth();
  }
}
