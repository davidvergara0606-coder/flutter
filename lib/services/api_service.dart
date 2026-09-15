import 'dart:convert';
import 'package:http/http.dart' as http;

/// Centraliza la URL base y los métodos HTTP usados por toda la app.
/// Si la IP del backend cambia, solo se edita AQUÍ, en un solo lugar.
class ApiService {
  static const String baseUrl = 'http://10.1.211.230:5000';

  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  static Future<http.Response> get(String path) {
    return http.get(_uri(path));
  }

  static Future<http.Response> post(String path, Map<String, dynamic> body) {
    return http.post(
      _uri(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(String path, Map<String, dynamic> body) {
    return http.put(
      _uri(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String path) {
    return http.delete(_uri(path));
  }
}