import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/login_provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/register_provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Story App Dicoding Intermidiate',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
