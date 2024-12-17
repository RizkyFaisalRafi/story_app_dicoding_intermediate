import 'package:story_app_dicoding_intermediate/data/data_sources/local/auth_local_datasource.dart';

import '../../domain/repositories/name_local_repository.dart';

class NameLocalReporitoryImpl implements NameLocalRepository {
  final AuthLocalDatasource authLocalDatasource;

  NameLocalReporitoryImpl({required this.authLocalDatasource});

  @override
  Future<void> saveName(String name) async {
    await authLocalDatasource.saveName(name);
  }

  @override
  Future<String?> getName() async {
    return await authLocalDatasource.getName();
  }

  @override
  Future<void> deleteName() async {
    await authLocalDatasource.deleteName();
  }
}
