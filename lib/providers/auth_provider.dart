import 'package:flutter/material.dart';
import 'package:jwt_learning/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String? error;
  bool obscureText = true;

  void togglePassword() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<bool> login() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await _authService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    isLoading = false;
    error = result;
    emailController.clear();
    passwordController.clear();
    notifyListeners();
    return result == null;
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
