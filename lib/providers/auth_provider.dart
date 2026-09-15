import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Usuario? _usuario;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Usuario? get usuario => _usuario;
  bool get isAuthenticated => _usuario != null;

  Future<bool> login(String documento, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.post('/auth/login', {
        'documento': documento,
        'password': password,
      });

      final bodyTrimmed = response.body.trim().toLowerCase();
      if (bodyTrimmed.startsWith('<!doctype') || bodyTrimmed.startsWith('<html')) {
        _errorMessage = 'El servidor devolvió HTML en vez de JSON (Código: ${response.statusCode}). Revisa que la IP, el puerto y la ruta de la API sean correctos.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _usuario = Usuario(
          documento: data['id'].toString(),
          primerNombre: data['usuario'] ?? '',
          primerApellido: '',
          correo: '',
          idRol: int.tryParse(data['id_rol'].toString()) ?? 0,
        );
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
    _usuario = null;
    notifyListeners();
  }
}