import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../view/ui/home_page.dart';
import '../view/ui/login_page.dart';
import '../view/ui/register_page.dart';
import 'route_constants.dart';

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
          routes: [
            // Register Page
            GoRoute(
              name: RouteConstants.register,
              path: RouteConstants.registerPath,
              builder: (context, state) => const RegisterPage(),
            ),
          ]),

      // Home Page
      GoRoute(
        name: RouteConstants.home,
        path: RouteConstants.homePath,
        builder: (context, state) {
          final token = state.extra as String?;
          log('Received token in HomePage: $token');

          if (token == null || token.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text('Error: Token is not found!'),
              ),
            );
          }
          return HomePage(
            queryToken: token,
          );
        },
      ),
    ],
  );
}
