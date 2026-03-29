import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static Future<void> saveUser({
    required String nombreCompleto,
    required String email,
    required String telefono,
    required String direccion,
    String? fotoPerfil,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombreCompleto', nombreCompleto);
    await prefs.setString('email', email);
    await prefs.setString('telefono', telefono);
    await prefs.setString('direccion', direccion);
    if (fotoPerfil != null) {
      await prefs.setString('fotoPerfil', fotoPerfil);
    }
  }

  static Future<Map<String, String>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'nombreCompleto': prefs.getString('nombreCompleto') ?? '',
      'email': prefs.getString('email') ?? '',
      'telefono': prefs.getString('telefono') ?? '',
      'direccion': prefs.getString('direccion') ?? '',
      'fotoPerfil': prefs.getString('fotoPerfil') ?? '',
    };
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}