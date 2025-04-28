import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _userId;

  String? get userId => _userId;

  Future<bool> login(String email, String password) async {
    try {
      _userId = await _authService.signIn(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signup(String email, String password) async {
    try {
      _userId = await _authService.signUp(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _userId = null;
    notifyListeners();
  }
}