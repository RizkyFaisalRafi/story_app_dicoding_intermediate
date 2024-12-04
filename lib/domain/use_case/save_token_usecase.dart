import '../repositories/token_repository.dart';

class SaveTokenUseCase {
  final TokenRepository repository;

  SaveTokenUseCase(this.repository);

  Future<void> execute(String token) async {
    await repository.saveToken(token);
  }
}
