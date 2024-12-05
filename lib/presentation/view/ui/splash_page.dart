import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/splash_provider.dart';
import '../../router/route_constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SplashProvider>(context, listen: false);
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        final isAuth = await provider.isAuthUsecase.execute();

        // Jika tidak login ke add_story_guest
        if (!isAuth) {
          if (context.mounted) {
            context.goNamed(
              RouteConstants.addStoryGuest,
            );
          }
        } else {
          // Sudah Login
          if (context.mounted) {
            context.goNamed(
              RouteConstants.home,
            );
          }
        }
      },
    );
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo_splash.png',
          fit: BoxFit.cover,
          width: 300,
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Powered by Rizky Faisal Rafi Go To Expert',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
