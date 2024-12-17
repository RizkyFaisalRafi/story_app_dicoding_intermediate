import 'package:story_app_dicoding_intermediate/domain/repositories/email_local_repository.dart';

class DeleteEmailLocalUsecase {
  final EmailLocalRepository emailLocalRepository;

  DeleteEmailLocalUsecase({required this.emailLocalRepository});

  Future<void> execute() async {
    await emailLocalRepository.deleteEmail();
  }
}
