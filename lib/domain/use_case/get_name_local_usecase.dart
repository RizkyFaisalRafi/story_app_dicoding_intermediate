import 'package:story_app_dicoding_intermediate/domain/repositories/name_local_repository.dart';

class GetNameLocalUsecase {
  final NameLocalRepository nameLocalRepository;

  GetNameLocalUsecase({required this.nameLocalRepository});

  Future<String?> execute() async {
    return await nameLocalRepository.getName();
  }
}
