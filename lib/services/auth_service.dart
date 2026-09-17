import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl =
      'https://dadishaapi.kodhatch.com/api/admin/learning/login/';

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'] ?? data['refresh_token'];
        if (token != null) {
          await _saveToken(token.toString());
          return null;
        }
        return 'Token missing in response';
      }

      try {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Login failed';
      } catch (_) {
        return 'Server error (${response.statusCode})';
      }
    } catch (e) {
      return 'Network error: ${e.toString()}';
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tokenKey', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenKey');
  }

  Future<bool> loggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tokenKey');
  }
}
