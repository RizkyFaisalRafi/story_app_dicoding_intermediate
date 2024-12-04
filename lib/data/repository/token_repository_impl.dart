import 'package:story_app_dicoding_intermediate/domain/repositories/token_repository.dart';

import '../data_sources/local/auth_local_datasource.dart';

class TokenRepositoryImpl implements TokenRepository {
  final AuthLocalDatasource authLocalDatasource;

  TokenRepositoryImpl({required this.authLocalDatasource});

  @override
  Future<void> saveToken(String token) async {
    await authLocalDatasource.saveToken(token);
  }

  @override
  Future<String?> getToken() async {
    return await authLocalDatasource.getToken();
  }

  @override
  Future<void> deleteToken() async {
    await authLocalDatasource.deleteToken();
  }

  @override
  Future<bool> isAuth() async {
    return await authLocalDatasource.isAuth();
  }
}
