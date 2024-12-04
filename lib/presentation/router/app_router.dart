import 'package:go_router/go_router.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/add_story_guest_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/splash_page.dart';
import '../view/ui/home_page.dart';
import '../view/ui/login_page.dart';
import '../view/ui/register_page.dart';
import 'route_constants.dart';

class AppRouter {
  final router = GoRouter(
    debugLogDiagnostics: true, // Log Route
    initialLocation: RouteConstants.splashPath, // First Screen
    routes: [
      // Splash Page
      GoRoute(
        name: RouteConstants.splash,
        path: RouteConstants.splashPath,
        builder: (context, state) => const SplashPage(),
      ),

      // Login Page
      GoRoute(
        name: RouteConstants.login,
        path: RouteConstants.loginPath,
        builder: (context, state) => const LoginPage(),
        routes: [
          // Register Page
          GoRoute(
            name: RouteConstants.register,
            path: RouteConstants.registerPath,
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),

      // Home Page
      GoRoute(
        name: RouteConstants.home,
        path: RouteConstants.homePath,
        builder: (context, state) {
          // final token = state.extra as String?;
          // log('Received token in HomePage: $token');

          // if (token == null || token.isEmpty) {
          //   return Scaffold(
          //     body: Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const Text('Error: Token is not found!'),
          //           ElevatedButton(
          //             onPressed: () {
          //               // Menghapus data otentikasi dari penyimpanan lokal
          //               AuthLocalDatasourceImpl().deleteToken();
          //             },
          //             child: const Text('Keluar Akun'),
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // }
          return const HomePage(
              // queryToken: token,
              );
        },
      ),

      GoRoute(
        name: RouteConstants.addStoryGuest,
        path: RouteConstants.addStoryGuestPath,
        builder: (context, state) => const AddStoryGuestPage(),
      ),
    ],
  );
}
