import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_flutter_app/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await _authService.signInWithPassword(
        dotenv.env['username'] ?? '',
        dotenv.env['password'] ?? '',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login'),
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _login,
                child: const Text('Log In'),
              ),
      ),
    );
  }
}
