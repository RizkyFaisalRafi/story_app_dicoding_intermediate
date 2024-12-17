import 'package:story_app_dicoding_intermediate/domain/repositories/email_local_repository.dart';

class GetEmailLocalUsecase {
  final EmailLocalRepository emailLocalRepository;

  GetEmailLocalUsecase({required this.emailLocalRepository});

  Future<String?> execute() async {
    return await emailLocalRepository.getEmail();
  }
}
