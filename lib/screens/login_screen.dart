import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miplata/services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () {
            _signInWithGoogle(context);
          },
          child: Text('Login with Google'),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

