import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CrearUsuarioScreen extends StatefulWidget {
  const CrearUsuarioScreen({super.key});

  @override
  State<CrearUsuarioScreen> createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends State<CrearUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _documentoController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final String _tipoDoc = 'CC';
  int _idRol = 2;
  bool _isLoading = false;

  final _correoRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');

  Future<void> _crearUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final response = await ApiService.post('/auth/crear-usuario', {
        'primer_nombre': _nombreController.text.trim(),
        'primer_apellido': _apellidoController.text.trim(),
        'tipo_documento': _tipoDoc,
        'documento': _documentoController.text.trim(),
        'correo': _correoController.text.trim(),
        'password': _passwordController.text.trim(),
        'id_rol': _idRol,
      });
      if (!mounted) return;

      final data = jsonDecode(response.body);
      messenger.showSnackBar(
        SnackBar(content: Text(data['mensaje'] ?? 'Resultado procesado')),
      );

      if (response.statusCode == 201) {
        navigator.pop();
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _documentoController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Primer Nombre', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Primer Apellido', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'El apellido es obligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _documentoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Documento', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'El documento es obligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'El correo es obligatorio';
                  if (!_correoRegex.hasMatch(v.trim())) return 'Ingresa un correo válido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'La contraseña es obligatoria';
                  if (v.length < 8) return 'Debe tener al menos 8 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _idRol,
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
      ),
    );
  }
}