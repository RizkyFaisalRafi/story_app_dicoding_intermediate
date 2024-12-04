import '../repositories/token_repository.dart';

class DeleteTokenUseCase {
  final TokenRepository repository;

  DeleteTokenUseCase(this.repository);

  Future<void> execute() async {
    await repository.deleteToken();
  }
}
