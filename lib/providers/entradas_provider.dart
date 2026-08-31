import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EntradasProvider with ChangeNotifier {
  List<dynamic> _entradas = [];
  bool _isLoading = false;

  List<dynamic> get entradas => _entradas;
  bool get isLoading => _isLoading;

  Future<void> fetchEntradas() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Ajusta la IP según tu API
      final response = await http.get(Uri.parse('http://192.168.1.43:5000/entradas'));
      if (response.statusCode == 200) {
        _entradas = json.decode(response.body);
      }
    } catch (e) {
      print("Error cargando entradas: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}