import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../services/api_service.dart';

class InventarioCRUDScreen extends StatefulWidget {
  const InventarioCRUDScreen({super.key});

  @override
  State<InventarioCRUDScreen> createState() => _InventarioCRUDScreenState();
}

class _InventarioCRUDScreenState extends State<InventarioCRUDScreen> {
  List<Producto> _productos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductos();
  }

  Future<void> _fetchProductos() async {
    try {
      final response = await ApiService.get('/productos');
      if (!mounted) return;
      if (response.statusCode == 200) {
        final List<dynamic> lista = jsonDecode(response.body);
        setState(() {
          _productos = lista.map((json) => Producto.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _eliminarProducto(int id) async {
    try {
      final response = await ApiService.delete('/productos/$id');
      if (!mounted) return;
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['mensaje'])));
      if (response.statusCode == 200) _fetchProductos();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Inventario (CRUD)')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _productos.length,
              itemBuilder: (context, index) {
                final p = _productos[index];
                return ListTile(
                  title: Text(p.nombre),
                  subtitle: Text('Código: ${p.codigo} | Stock: ${p.stockActual}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarProducto(p.idProducto),
                  ),
                );
              },
            ),
    );
  }
}