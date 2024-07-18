import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.90:8000/api/v1';
  final Dio _dio = Dio();
  static final Logger _logger = Logger();

  Future<void> login(User user) async {
    final String endpoint = '$baseUrl/login';
    final Map<String, dynamic> data = {
      'email': user.email,
      'password': user.password,
    };

    try {
      _logger.d('Enviando solicitud de login a $endpoint con cuerpo $data');
      Response response = await _dio.post(
        endpoint,
        data: data,
      );
      _logger.d('Respuesta recibida: ${response.data}');
      if (response.statusCode == 200) {
        _logger.d('Login exitoso.');
      } else {
        _logger.e('Error en login: ${response.statusMessage}');
        throw Exception('Error en login: ${response.statusMessage}');
      }
    } catch (e) {
      _logger.e('Excepción durante el login: $e');
      throw e;
    }
  }

  Future<void> register(User user) async {
    final String endpoint = '$baseUrl/register';
    final Map<String, dynamic> data = {
      'email': user.email,
      'password': user.password,
    };

    try {
      _logger.d('Enviando solicitud de registro a $endpoint con cuerpo $data');
      Response response = await _dio.post(
        endpoint,
        data: data,
      );
      _logger.d('Respuesta recibida: ${response.data}');
      if (response.statusCode == 200) {
        _logger.d('Registro exitoso.');
      } else {
        _logger.e('Error en registro: ${response.statusMessage}');
        throw Exception('Error en registro: ${response.statusMessage}');
      }
    } catch (e) {
      _logger.e('Excepción durante el registro: $e');
      throw e;
    }
  }
}
