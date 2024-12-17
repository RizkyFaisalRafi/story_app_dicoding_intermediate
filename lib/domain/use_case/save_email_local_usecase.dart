import 'package:story_app_dicoding_intermediate/domain/repositories/email_local_repository.dart';

class SaveEmailLocalUsecase {
  final EmailLocalRepository emailLocalRepository;

  SaveEmailLocalUsecase({required this.emailLocalRepository});

  Future<void> execute(String email) async {
    await emailLocalRepository.saveEmail(email);
  }
}
