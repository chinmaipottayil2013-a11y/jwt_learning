import 'package:flutter/material.dart';
import 'package:jwt_learning/services/auth_service.dart';

import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _service = AuthService();
  bool isLoading = false;
  String? error;
  bool _obscureText = false;

  void togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    final result = await _service.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
    );
    if (!mounted) return;
    if (result == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() {
        isLoading = false;
        error = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication'), centerTitle: true),
      body: Column(
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            obscureText: _obscureText,
            controller: passwordController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  togglePassword();
                },
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 15),
          if (error != null) Text(error!, style: TextStyle(color: Colors.red)),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(onPressed: _handleLogin, child: Text('Login')),
        ],
      ),
    );
  }
}
