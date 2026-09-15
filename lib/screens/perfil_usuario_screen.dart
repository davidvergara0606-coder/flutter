import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class PerfilUsuarioScreen extends StatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  State<PerfilUsuarioScreen> createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  bool _isLoading = false;
  String? _documento;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    final doc = Provider.of<AuthProvider>(context, listen: false).usuario?.documento;
    if (doc == null) return;
    _documento = doc.toString();

    setState(() => _isLoading = true);
    try {
      final res = await ApiService.get('/auth/perfil/$doc');
      if (!mounted) return;
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _nombreController.text = data['primer_nombre'] ?? '';
        _correoController.text = data['correo'] ?? '';
      }
    } catch (_) {
      // Si falla la carga, se dejan los campos vacíos; el usuario puede reintentar.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _guardarPerfil() async {
    if (_documento == null) return;
    if (_nombreController.text.trim().isEmpty || _correoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre y el correo no pueden estar vacíos')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final res = await ApiService.put('/auth/perfil/actualizar/$_documento', {
        'primer_nombre': _nombreController.text.trim(),
        'correo': _correoController.text.trim(),
      });
      if (!mounted) return;
      final data = jsonDecode(res.body);
      messenger.showSnackBar(SnackBar(content: Text(data['mensaje'] ?? 'Perfil actualizado')));
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _correoController,
              decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _guardarPerfil,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}