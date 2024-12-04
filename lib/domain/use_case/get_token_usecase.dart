import '../repositories/token_repository.dart';

class GetTokenUseCase {
  final TokenRepository repository;

  GetTokenUseCase(this.repository);

  Future<String?> execute() async {
    return await repository.getToken();
  }
}
