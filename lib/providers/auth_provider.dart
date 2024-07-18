import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class ApiAuthProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  static final Logger _logger = Logger();

  Future<void> login(String email, String password) async {
    User user = User(email: email, password: password);
    try {
      _logger.d('Intentando login con email: $email');
      await apiService.login(user);
      _logger.d('Login en API Transferencia exitoso.');
    } catch (error) {
      _logger.e('Error en login: $error');
      throw error;
    }
  }

  Future<void> register(String email, String password) async {
    User user = User(email: email, password: password);
    try {
      _logger.d('Intentando registro con email: $email');
      await apiService.register(user);
      _logger.d('Registro en API Transferencia exitoso.');
    } catch (error) {
      _logger.e('Error en registro: $error');
      throw error;
    }
  }
}
