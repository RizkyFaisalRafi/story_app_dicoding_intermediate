import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/error/failure.dart';
import '../../../domain/entities/register.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_case/post_register.dart';
import '../../../common/state_enum.dart';
import '../../router/app_router.dart';

class RegisterProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  RegisterProvider({
    required this.postRegister,
    required this.authRepository,
  });
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  Register? _registerEntities;
  String _errorMessage = '';
  RequestState _state = RequestState.empty;
  PostRegister postRegister;

  // Getter
  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  GlobalKey<FormState> get formKey => _formKey;
  bool get obscureText => _obscureText;
  Register? get registerEntities => _registerEntities;
  String? get errorMessage => _errorMessage;
  RequestState get state => _state;

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
      return 'Password harus terdiri dari minimal 8 kata!';
    } else {
      return null;
    }
  }

  // Validate Name
  String? validateName(name) {
    if (name.isEmpty) {
      return "Nama tidak boleh kosong!";
    } else if (name.split('').length < 4) {
      return 'Nama harus terdiri dari minimal 4 karakter!';
    } else {
      return null;
    }
  }

  // Method Register
  Future<void> register(BuildContext context) async {
    state == RequestState.loading;
    notifyListeners();

    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;

    try {
      final result = await postRegister.execute(name, email, password);

      result.fold(
        (failure) {
          _state = RequestState.error;
          _errorMessage = failure.message;
          log('Register Provider: $_errorMessage');

          // Cek tipe kegagalan dan berikan pesan kesalahan yang lebih spesifik
          if (failure is ServerFailure) {
            if (failure.message.contains("Email is already taken")) {
              _errorMessage =
                  "Email sudah terdaftar, silahkan gunnakan email yang lain.";
            } else if (failure.message
                .contains("Invalid request payload JSON format")) {
              _errorMessage = "Format nama, email atau password tidak valid.";
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

          // Tampilkan pesan error ke pengguna
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_errorMessage),
            backgroundColor: Colors.red,
          ));
        },
        (data) {
          _state = RequestState.loaded;
          _registerEntities = data;
          notifyListeners();

          // Tampilkan pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Berhasil Daftar, Silahkan Log In Terlebih Dahulu.'),
            backgroundColor: Colors.green,
          ));
          // Go to Home
          context.goNamed(RouteConstants.login);
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
    log("RegisterProvider disposed");
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
