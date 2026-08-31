import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CrearUsuarioScreen extends StatefulWidget {
  const CrearUsuarioScreen({super.key});

  @override
  State<CrearUsuarioScreen> createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends State<CrearUsuarioScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _documentoController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  String _tipoDoc = 'CC';
  int _idRol = 2; // Default: Bodeguero (1: Admin, 2: Bodeguero)
  bool _isLoading = false;

  Future<void> _crearUsuario() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.43:5000/auth/crear-usuario'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'primer_nombre': _nombreController.text.trim(),
          'primer_apellido': _apellidoController.text.trim(),
          'tipo_documento': _tipoDoc,
          'documento': _documentoController.text.trim(),
          'correo': _correoController.text.trim(),
          'password': _passwordController.text.trim(),
          'id_rol': _idRol,
        }),
      );

      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['mensaje'] ?? 'Resultado procesado')),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(controller: _nombreController, decoration: const InputDecoration(labelText: 'Primer Nombre', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _apellidoController, decoration: const InputDecoration(labelText: 'Primer Apellido', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _documentoController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Documento', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _correoController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _idRol,
              decoration: const InputDecoration(labelText: 'Rol', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Administrador')),
                DropdownMenuItem(value: 2, child: Text('Bodeguero')),
              ],
              onChanged: (val) => setState(() => _idRol = val!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _crearUsuario,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: _isLoading ? const CircularProgressIndicator() : const Text('Guardar Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}