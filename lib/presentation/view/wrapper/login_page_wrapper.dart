import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/data/repository/email_local_reporitory_impl.dart';
import 'package:story_app_dicoding_intermediate/data/repository/name_local_reporitory_impl.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/post_login.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/save_email_local_usecase.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/save_name_local_usecase.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/save_token_usecase.dart';
import '../../../data/data_sources/local/auth_local_datasource.dart';
import '../../../data/data_sources/remote/auth_remote_datasource.dart';
import '../../../data/repository/auth_repository_impl.dart';
import '../../../data/repository/token_repository_impl.dart';
import '../provider/login_provider.dart';
import '../ui/login_page.dart';
import 'package:http/http.dart' as http;

/*
 * LoginPageWrapper berfungsi sebagai pembungkus (wrapper) yang menghubungkan UI halaman login (LoginPage) dengan Provider yang menyuplai data dan logika bisnisnya (LoginProvider).
 * Ini berguna untuk menjaga modularitas dan memisahkan logika inisialisasi dari tampilan (separation of concerns). Dengan pendekatan ini, Anda dapat dengan mudah:
    *- Mengatur dependensi LoginProvider di satu tempat tanpa mencampurnya dengan logika UI di LoginPage.
    *- Mengurangi potensi kebingungan antara komponen UI dan logika bisnis.
    *- Memudahkan pengujian unit karena Anda bisa memisahkan kode logika dari UI.
*/

class LoginPageWrapper extends StatelessWidget {
  const LoginPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    // *Inisialisasi Data Sources
    final remoteDataSource = AuthRemoteDatasourceImpl(client: httpClient);
    final localDataSource = AuthLocalDatasourceImpl();

    // *Inisialisasi Repository
    final tokenRepository = TokenRepositoryImpl(
      authLocalDatasource: localDataSource,
    );
    final repository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);

    final nameRepository = NameLocalReporitoryImpl(
      authLocalDatasource: localDataSource,
    );

    final emailRepository = EmailLocalReporitoryImpl(
      authLocalDatasource: localDataSource,
    );

    // *Login Provider
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(
        postLogin: PostLogin(repository),
        authRepository: AuthRepositoryImpl(remoteDataSource: remoteDataSource),
        tokenRepository: tokenRepository,
        saveTokenUseCase: SaveTokenUseCase(tokenRepository),
        saveNameLocalUsecase:
            SaveNameLocalUsecase(nameLocalRepository: nameRepository),
        saveEmailLocalUsecase:
            SaveEmailLocalUsecase(emailLocalRepository: emailRepository),
      ),
      child: const LoginPage(),
    );
  }
}
