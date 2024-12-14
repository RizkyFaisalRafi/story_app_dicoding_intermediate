import 'package:go_router/go_router.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/list_story.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/add_story_guest_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/detail_story_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/splash_page.dart';
import '../view/ui/home_page.dart';
import '../view/ui/login_page.dart';
import '../view/ui/register_page.dart';
// import 'route_constants.dart';
part 'route_constants.dart';

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

      // Home Page
      GoRoute(
        name: RouteConstants.home,
        path: RouteConstants.homePath,
        builder: (context, state) {
          return const HomePage(
              // queryToken: token,
              );
        },
        routes: [
          // Detail Story Page
          GoRoute(
              name: RouteConstants.detailStory,
              path: RouteConstants.detailStoryPath,
              builder: (context, state) {
                final listStory = state.extra as ListStory;
                return DetailStoryPage(
                  listStory: listStory,
                );
              }),
        ],
      ),

      GoRoute(
        name: RouteConstants.addStoryGuest,
        path: RouteConstants.addStoryGuestPath,
        builder: (context, state) => const AddStoryGuestPage(),
        routes: [
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
        ],
      ),
    ],
  );
}
