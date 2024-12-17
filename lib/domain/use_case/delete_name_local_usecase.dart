import 'package:story_app_dicoding_intermediate/domain/repositories/name_local_repository.dart';

class DeleteNameLocalUsecase {
  final NameLocalRepository nameLocalRepository;

  DeleteNameLocalUsecase({required this.nameLocalRepository});

  Future<void> execute() async {
    await nameLocalRepository.deleteName();
  }
}
