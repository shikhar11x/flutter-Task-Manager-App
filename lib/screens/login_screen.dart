import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/gradient_button.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscure = true;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.task_alt,
                        size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  const Text('Task Manager',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  Text('Manages Your Tasks',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7))),
                  const SizedBox(height: 40),
                  GlassContainer(
                    padding: const EdgeInsets.all(28),
                    borderRadius: BorderRadius.circular(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GlassTextField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            validator: (val) =>
                                val!.isEmpty ? 'Enter Email' : null,
                          ),
                          const SizedBox(height: 16),
                          GlassTextField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Icons.lock_outline,
                            obscure: _obscure,
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white70),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                            validator: (val) => val!.length < 6
                                ? 'Min 6 characters'
                                : null,
                          ),
                          const SizedBox(height: 28),
                          GradientButton(
                            text: 'Login',
                            onPressed: _login,
                            isLoading: _isLoading,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const SignupScreen())),
                    child: Text("Don't have an account? Sign up",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}