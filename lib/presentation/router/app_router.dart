import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/list_story.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/add_story_guest_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/add_story_user_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/contact_us_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/detail_story_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/settings_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/splash_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/wrapper/login_page_wrapper.dart';
import '../view/ui/home_page.dart';
import '../view/ui/register_page.dart';
part 'route_constants.dart';

class AppRouter {
  final router = GoRouter(
    debugLogDiagnostics: true, // Log Route
    initialLocation: RouteConstants.splashPath, // First Screen

    routes: [
      // *Splash Page
      GoRoute(
        name: RouteConstants.splash,
        path: RouteConstants.splashPath,
        builder: (context, state) => const SplashPage(),
      ),

      // *Add Story Guest
      GoRoute(
        name: RouteConstants.addStoryGuest,
        path: RouteConstants.addStoryGuestPath,
        builder: (context, state) => const AddStoryGuestPage(),
      ),

      // *Login Page
      GoRoute(
        name: RouteConstants.login,
        path: RouteConstants.loginPath,
        builder: (context, state) => const LoginPageWrapper(),
        routes: [
          // *Register Page
          GoRoute(
            name: RouteConstants.register,
            path: RouteConstants.registerPath,
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),

      /// Bottom Navigation Bar [root]
      GoRoute(
        name: RouteConstants.bottomNavBar,
        path: RouteConstants.bottomNavBarPath,
        builder: (context, state) => const BottomNavBar(),
        routes: [
          // *Detail Story Page
          GoRoute(
            name: RouteConstants.detailStory,
            path: RouteConstants.detailStoryPath,
            builder: (context, state) {
              final listStory = state.extra as ListStory;
              return DetailStoryPage(
                listStory: listStory,
              );
            },
          ),

          // *Add Story User
          GoRoute(
            name: RouteConstants.addStoryUser,
            path: RouteConstants.addStoryUserPath,
            builder: (context, state) => const AddStoryUserPage(),
          ),

          // *Settings Page
          GoRoute(
            name: RouteConstants.settings,
            path: RouteConstants.settingsPath,
            builder: (context, state) => const SettingsPage(),
          ),

          // *Contact Us Page
          GoRoute(
            name: RouteConstants.contactUs,
            path: RouteConstants.contactUsPath,
            builder: (context, state) => const ContactUsPage(),
          ),
        ],
      ),
    ],

    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    },
  );
}
