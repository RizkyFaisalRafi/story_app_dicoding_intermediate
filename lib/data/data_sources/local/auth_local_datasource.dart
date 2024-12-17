import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<bool> isAuth();

  Future<void> saveName(String name);
  Future<String?> getName();
  Future<void> deleteName();

  Future<void> saveEmail(String name);
  Future<String?> getEmail();
  Future<void> deleteEmail();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  static const _tokenKey = 'USER_TOKEN';
  static const _nameKey = 'USER_NAME';
  static const _emailKey = 'USER_EMAIL';

  // *Token Local
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

  // *Name Local
  @override
  Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    log('Named saved: $name'); // Log untuk memeriksa
  }

  @override
  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_nameKey);
    log('Name retrieved: $name'); // Log untuk memeriksa
    return name;
  }

  @override
  Future<void> deleteName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    log('Name deleted'); // Log untuk memeriksa
  }

  // *Email Local
  @override
  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    log('Email saved: $email'); // Log untuk memeriksa
  }

  @override
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    log('Email retrieved: $email'); // Log untuk memeriksa
    return email;
  }

  @override
  Future<void> deleteEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    log('Email deleted'); // Log untuk memeriksa
  }
}
