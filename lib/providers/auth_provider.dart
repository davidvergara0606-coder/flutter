import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;
  bool get isAuthenticated => _userData != null;
  
  // Nuevo getter para extraer el rol fácilmente
  String? get rolUsuario => _userData?['rol']; 

  Future<bool> login(String documento, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('http://192.168.1.43:5000/auth/login');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'documento': documento,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _userData = data;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['mensaje'] ?? 'Credenciales inválidas';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error de conexión con el backend: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _userData = null;
    notifyListeners();
  }
}