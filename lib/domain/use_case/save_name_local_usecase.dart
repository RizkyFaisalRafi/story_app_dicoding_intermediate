import 'package:story_app_dicoding_intermediate/domain/repositories/name_local_repository.dart';

class SaveNameLocalUsecase {
  final NameLocalRepository nameLocalRepository;

  SaveNameLocalUsecase({required this.nameLocalRepository});

  Future<void> execute(String name) async {
    await nameLocalRepository.saveName(name);
  }
}
