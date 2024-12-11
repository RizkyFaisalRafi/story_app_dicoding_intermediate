import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/data/data_sources/remote/add_story_remote_datasource.dart';
import 'package:story_app_dicoding_intermediate/data/data_sources/remote/story_remote_datasource.dart';
import 'package:story_app_dicoding_intermediate/data/repository/add_new_story_repository_impl.dart';
import 'package:story_app_dicoding_intermediate/data/repository/story_repository_impl.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/post_add_guest_story.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/delete_token_usecase.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/get_all_story.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/get_token_usecase.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/is_auth_usecase.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/save_token_usecase.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/add_story_guest_provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/camera_provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/home_provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/splash_provider.dart';
import 'data/data_sources/local/auth_local_datasource.dart';
import 'data/data_sources/remote/auth_remote_datasource.dart';
import 'data/repository/token_repository_impl.dart';
import 'domain/use_case/post_login.dart';
import 'domain/use_case/post_register.dart';
import 'presentation/view/provider/login_provider.dart';
import 'presentation/view/provider/register_provider.dart';
import 'package:http/http.dart' as http;
import 'data/repository/auth_repository_impl.dart';
import 'presentation/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    final router = appRouter.router;
    final httpClient = http.Client();

    // Inisialisasi Data Sources
    final remoteDataSource = AuthRemoteDatasourceImpl(client: httpClient);
    final remoteDataSourceHome = StoryRemoteDatasourceImpl(client: httpClient);
    final localDataSource = AuthLocalDatasourceImpl();
    final remoteDataSourceAddStory =
        AddStoryRemoteDatasourceImpl(client: httpClient);

    final repository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);
    final repositoryHome =
        StoryRepositoryImpl(storyRemoteDatasource: remoteDataSourceHome);
    final tokenRepository = TokenRepositoryImpl(
      authLocalDatasource: localDataSource,
    );
    final tokenGuestStory = AddNewStoryRepositoryImpl(
        addStoryRemoteDatasource: remoteDataSourceAddStory);

    return MultiProvider(
      providers: [
        // Tidak menggunakan Dependency Injection
        // Login Provider
        ChangeNotifierProvider(
          create: (_) => LoginProvider(
            saveTokenUseCase: SaveTokenUseCase(tokenRepository),
            tokenRepository: tokenRepository,
            postLogin: PostLogin(repository),
            authRepository: AuthRepositoryImpl(
              remoteDataSource: remoteDataSource,
            ),
          ),
        ),

        // Register Provider
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(
            postRegister: PostRegister(repository),
            authRepository: AuthRepositoryImpl(
              remoteDataSource: remoteDataSource,
            ),
          ),
        ),

        // Home Provider
        ChangeNotifierProvider(
          create: (context) => HomeProvider(
            DeleteTokenUseCase(tokenRepository),
            GetTokenUseCase(tokenRepository),
            getAllStory: GetAllStory(storyRepository: repositoryHome),
          ),
        ),

        // Splash Provider
        ChangeNotifierProvider(
          create: (context) => SplashProvider(
            IsAuthUsecase(tokenRepository),
          ),
        ),

        // Add Story Guest Provider
        ChangeNotifierProvider(
          create: (context) => AddStoryGuestProvider(
            postAddGuestStory: PostAddGuestStory(tokenGuestStory),
          ),
        ),

        ChangeNotifierProvider(
          create: (context) => CameraProvider(),
        ),
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
