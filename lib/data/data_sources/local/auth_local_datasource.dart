import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<bool> isAuth();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  static const _tokenKey = 'USER_TOKEN';

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    log('Token saved: $token'); // Log untuk memeriksa
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    log('Token retrieved: $token'); // Log untuk memeriksa
    return token;
  }

  @override
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    log('Token deleted'); // Log untuk memeriksa
  }

  @override
  Future<bool> isAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null;
  }
}
