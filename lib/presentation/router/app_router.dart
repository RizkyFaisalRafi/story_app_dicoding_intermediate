import 'package:go_router/go_router.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/home_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/login_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/register_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/router/route_constants.dart';

class AppRouter {
  final router = GoRouter(
    debugLogDiagnostics: true, // Log Route
    initialLocation: RouteConstants.loginPath, // First Screen
    routes: [
      // Login Page
      GoRoute(
        name: RouteConstants.login,
        path: RouteConstants.loginPath,
        builder: (context, state) => const LoginPage(),
      ),

      // Register Page
      GoRoute(
        name: RouteConstants.register,
        path: RouteConstants.registerPath,
        builder: (context, state) => const RegisterPage(),
      ),

      // Home Page
      GoRoute(
        name: RouteConstants.home,
        path: RouteConstants.homePath,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
