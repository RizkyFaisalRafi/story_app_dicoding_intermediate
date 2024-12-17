import 'package:story_app_dicoding_intermediate/domain/repositories/email_local_repository.dart';

import '../data_sources/local/auth_local_datasource.dart';

class EmailLocalReporitoryImpl implements EmailLocalRepository {
  final AuthLocalDatasource authLocalDatasource;

  EmailLocalReporitoryImpl({required this.authLocalDatasource});

  @override
  Future<void> saveEmail(String email) async {
    await authLocalDatasource.saveEmail(email);
  }

  @override
  Future<String?> getEmail() async {
    return await authLocalDatasource.getEmail();
  }

  @override
  Future<void> deleteEmail() async {
    await authLocalDatasource.deleteEmail();
  }
}
