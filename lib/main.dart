import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/data/data_sources/remote/story_remote_datasource.dart';
import 'package:story_app_dicoding_intermediate/data/repository/story_repository_impl.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/get_all_story.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/home_provider.dart';
import 'data/data_sources/remote/auth_remote_datasource.dart';
import 'domain/use_case/post_login.dart';
import 'domain/use_case/post_register.dart';
import 'presentation/view/provider/login_provider.dart';
import 'presentation/view/provider/register_provider.dart';
import 'package:http/http.dart' as http;
import 'data/repository/auth_repository_impl.dart';
import 'presentation/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    final router = appRouter.router;
    final httpClient = http.Client();
    final remoteDataSource = AuthRemoteDatasourceImpl(client: httpClient);
    final remoteDataSourceHome = StoryRemoteDatasourceImpl(client: httpClient);
    final repository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);
    final repositoryHome =
        StoryRepositoryImpl(storyRemoteDatasource: remoteDataSourceHome);

    return MultiProvider(
      providers: [
        // Tidak menggunakan Dependency Injection
        ChangeNotifierProvider(
          create: (_) => LoginProvider(
            postLogin: PostLogin(repository),
            authRepository: AuthRepositoryImpl(
              remoteDataSource: remoteDataSource,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(
            postRegister: PostRegister(repository),
            authRepository: AuthRepositoryImpl(
              remoteDataSource: remoteDataSource,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(
            getAllStory: GetAllStory(storyRepository: repositoryHome),
          ),
        )
      ],
      child: MaterialApp.router(
        title: 'Story App Dicoding Intermidiate',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        debugShowCheckedModeBanner: false,
        // home: const LoginPage(),
      ),
    );
  }
}
