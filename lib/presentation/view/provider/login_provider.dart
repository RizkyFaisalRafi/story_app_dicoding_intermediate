import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app_dicoding_intermediate/common/error/failure.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/login_result.dart';
import 'package:story_app_dicoding_intermediate/domain/repositories/auth_repository.dart';
import 'package:story_app_dicoding_intermediate/presentation/router/route_constants.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  LoginProvider({required this.authRepository});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  LoginResult? _loginResult;
  String? _errorMessage;

  // Getter
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  GlobalKey<FormState> get formKey => _formKey;
  bool get obscureText => _obscureText;
  bool get isLoading => _isLoading;
  LoginResult? get loginResult => _loginResult;
  String? get errorMessage => _errorMessage;

  // Toggle Obscure Password
  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  // Validator Email
  String? validateEmail(email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

    if (email.isEmpty) {
      return "Email tidak boleh kosong!";
    } else if (!emailRegex.hasMatch(email)) {
      return 'Format email tidak valid!';
    } else if (email.contains(RegExp(r'[!#<>?":$_`~;[\]\\|=+)(*&^%-]'))) {
      return 'Email tidak boleh mengandung karakter khusus!';
    } else {
      return null; // Email valid
    }
  }

  // Validator Password
  String? validatePass(pass) {
    if (pass.isEmpty) {
      return "Password tidak boleh kosong!";
    } else if (pass.split('').length < 8) {
      return 'Password harus terdiri dari minimal 8 karakter!';
    } else {
      return null;
    }
  }

  // Method Login
  Future<void> login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final email = _emailController.text;
    final password = _passwordController.text;

    final result = await authRepository.login(email: email, password: password);

    result.fold(
      (failure) {
        // Cek tipe kegagalan dan berikan pesan kesalahan yang lebih spesifik
        if (failure is ServerFailure) {
          if (failure.message.toLowerCase().contains("no internet")) {
            _errorMessage =
                "Tidak ada koneksi internet. Silakan periksa koneksi Anda.";
          } else if (failure.message.toLowerCase().contains("unauthorized")) {
            _errorMessage = "Email atau password salah. Silakan coba lagi.";
          } else {
            _errorMessage = "Terjadi kesalahan pada server. Silakan coba lagi.";
          }
        } else if (failure is ConnectionFailure) {
          _errorMessage =
              "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.";
        } else {
          _errorMessage = "Terjadi kesalahan yang tidak diketahui.";
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_errorMessage ?? 'Login failed'),
          backgroundColor: Colors.red,
        ));
      },
      (data) {
        _loginResult = data;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Welcome ${data.name}!'),
          backgroundColor: Colors.green,
        ));
        // Go to Home
        context.goNamed(RouteConstants.home);
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    notifyListeners();
    log("LoginProvider disposed");
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
