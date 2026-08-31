import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';

class PerfilUsuarioScreen extends StatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  State<PerfilUsuarioScreen> createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    final doc = Provider.of<AuthProvider>(context, listen: false).userData?['id'];
    if (doc == null) return;

    try {
      final res = await http.get(Uri.parse('http://192.168.1.43:5000/auth/perfil/$doc'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _nombreController.text = data['primer_nombre'] ?? '';
        _correoController.text = data['correo'] ?? '';
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(controller: _nombreController, decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _correoController, decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder())),
          ],
        ),
      ),
    );
  }
}