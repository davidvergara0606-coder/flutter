import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SalidasFormScreen extends StatefulWidget {
  const SalidasFormScreen({super.key});

  @override
  State<SalidasFormScreen> createState() => _SalidasFormScreenState();
}

class _SalidasFormScreenState extends State<SalidasFormScreen> {
  final TextEditingController _idProductoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSalida() async {
    final idProductoTexto = _idProductoController.text.trim();
    final cantidadTexto = _cantidadController.text.trim();

    if (idProductoTexto.isEmpty || cantidadTexto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final idProducto = int.tryParse(idProductoTexto);
    final cantidad = int.tryParse(cantidadTexto);

    if (idProducto == null || cantidad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID de producto y cantidad deben ser números enteros')),
      );
      return;
    }
    if (cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La cantidad debe ser mayor que cero')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.post('/productos/salida', {
        'id_producto': idProducto,
        'cantidad': cantidad,
      });
      if (!mounted) return;

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['mensaje'] ?? '¡Salida registrada con éxito!')),
        );
        _idProductoController.clear();
        _cantidadController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['mensaje'] ?? 'Error al registrar la salida')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Salida')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _idProductoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ID del Producto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad a retirar',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.remove_circle_outline),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSalida,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('Registrar Salida', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}