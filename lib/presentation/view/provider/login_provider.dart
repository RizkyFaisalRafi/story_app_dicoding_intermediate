import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app_dicoding_intermediate/data/data_sources/local/auth_local_datasource.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/save_token_usecase.dart';
import '../../../common/error/failure.dart';
import '../../../common/state_enum.dart';
import '../../../domain/entities/login_result.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/token_repository.dart';
import '../../../domain/use_case/post_login.dart';
import '../../router/route_constants.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider({
    required this.postLogin,
    required this.authRepository,
    required this.tokenRepository,
    required this.saveTokenUseCase,
  });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  LoginResult? _loginResult;
  String _errorMessage = '';
  RequestState _state = RequestState.empty;
  PostLogin postLogin;
  final AuthRepository authRepository;
  final TokenRepository tokenRepository;
  final SaveTokenUseCase saveTokenUseCase;

  // Cek apakah sudah login
  final isAuth = AuthLocalDatasourceImpl().isAuth();

  // Getter
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  GlobalKey<FormState> get formKey => _formKey;
  bool get obscureText => _obscureText;
  LoginResult? get loginResult => _loginResult;
  String? get errorMessage => _errorMessage;
  RequestState get state => _state;

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
  Future<void> login(
    BuildContext context,
  ) async {
    _state = RequestState.loading;
    notifyListeners();

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final result = await postLogin.execute(email, password);
      result.fold(
        (failure) {
          _state = RequestState.error;
          _errorMessage = failure.message;
          log('Login Provider: $_errorMessage');

          // Cek tipe kegagalan dan berikan pesan kesalahan yang lebih spesifik
          if (failure is ServerFailure) {
            if (failure.message.toLowerCase().contains("user not found")) {
              _errorMessage = "Email atau password salah. Silakan coba lagi.";
            } else if (failure.message
                .contains('Invalid request payload JSON format.')) {
              _errorMessage = "Format email atau password tidak valid.";
            } else {
              log(failure.message);
              _errorMessage =
                  "Terjadi kesalahan pada server. Silakan coba lagi.";
            }
          } else if (failure is ConnectionFailure) {
            _errorMessage =
                "Tidak dapat terhubung ke server. Periksa koneksi internet Anda!";
          } else {
            _errorMessage = "Terjadi kesalahan yang tidak diketahui.";
          }
          notifyListeners();

          // Tampilkan pesan error ke pengguna
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        },
        (data) async {
          _state = RequestState.loaded;
          _loginResult = data;
          notifyListeners();

          try {
            // Simpan Data Token menggunakan TokenRepository di Local
            // await tokenRepository.saveToken(data.token); // Sama saja
            await saveTokenUseCase.execute(data.token);

            if (context.mounted) {
              // Navigasi ke halaman utama
              context.goNamed(
                RouteConstants.home,
                extra: data.token,
              );
              log('Navigating to Home with token: ${data.token}');

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Welcome ${data.name}!'),
                backgroundColor: Colors.green,
              ));
            }
          } catch (e) {
            log('Error saving token: $e');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal menyimpan token: $e.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }

          // // Kirim Token ke HomePage
          // context.goNamed(
          //   RouteConstants.home,
          //   extra: data.token,
          // );
          // log('Navigating to Home with token: ${data.token}');

          // // Tampilkan pesan sukses
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('Welcome ${data.name}!'),
          //   backgroundColor: Colors.green,
          // ));
        },
      );
    } catch (e) {
      _state = RequestState.error;
      _errorMessage = "Kesalahan tidak terduga: $e";
      log('Unexpected error: $e');
      notifyListeners();

      // Pesan default untuk error yang tidak diketahui
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Terjadi kesalahan tidak terduga: $e"),
          backgroundColor: Colors.red,
        ));
      }
    }
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
