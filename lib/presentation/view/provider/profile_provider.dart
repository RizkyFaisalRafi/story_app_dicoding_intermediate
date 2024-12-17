import 'package:flutter/foundation.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/get_email_local_usecase.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/get_name_local_usecase.dart';

class ProfileProvider extends ChangeNotifier {
  GetNameLocalUsecase getNameLocalUsecase;
  GetEmailLocalUsecase getEmailLocalUsecase;

  ProfileProvider(
    this.getNameLocalUsecase,
    this.getEmailLocalUsecase,
  );
}
