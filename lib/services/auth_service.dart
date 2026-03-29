import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session_service.dart';

class AuthService {
  static const String baseUrl = 'https://tortasyaniapi-production.up.railway.app/api';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      final result = jsonDecode(response.body);

      if (result['success'] == true) {
        await SessionService.saveUser(
          nombreCompleto: result['nombreCompleto'] ?? '',
          email: email,
          telefono: '',
          direccion: '',
        );
      }

      return result;
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> register({
    required String nombreCompleto,
    required String email,
    required String password,
    required String telefono,
    required String direccion,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombreCompleto': nombreCompleto,
          'email': email,
          'password': password,
          'telefono': telefono,
          'direccion': direccion,
        }),
      );
      final result = jsonDecode(response.body);

      if (result['success'] == true) {
        await SessionService.saveUser(
          nombreCompleto: nombreCompleto,
          email: email,
          telefono: telefono,
          direccion: direccion,
        );
      }

      return result;
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String nombreCompleto,
    required String telefono,
    required String direccion,
    String? nuevaPassword,
  }) async {
    try {
      final user = await SessionService.getUser();
      final response = await http.put(
        Uri.parse('$baseUrl/Auth/update'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': user['email'],
          'nombreCompleto': nombreCompleto,
          'telefono': telefono,
          'direccion': direccion,
          'nuevaPassword': nuevaPassword ?? '',
        }),
      );
      final result = jsonDecode(response.body);

      if (result['success'] == true) {
        await SessionService.saveUser(
          nombreCompleto: nombreCompleto,
          email: user['email'] ?? '',
          telefono: telefono,
          direccion: direccion,
        );
      }

      return result;
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }
}