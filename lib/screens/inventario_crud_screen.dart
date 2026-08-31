import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InventarioCRUDScreen extends StatefulWidget {
  const InventarioCRUDScreen({super.key});

  @override
  State<InventarioCRUDScreen> createState() => _InventarioCRUDScreenState();
}

class _InventarioCRUDScreenState extends State<InventarioCRUDScreen> {
  List<dynamic> _productos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductos();
  }

  Future<void> _fetchProductos() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.43:5000/productos'));
      if (response.statusCode == 200) {
        setState(() {
          _productos = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _eliminarProducto(int id) async {
    try {
      final response = await http.delete(Uri.parse('http://192.168.1.43:5000/productos/$id'));
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['mensaje'])));
      if (response.statusCode == 200) _fetchProductos();
    } catch (e) {
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
                  title: Text(p['nombre'] ?? ''),
                  subtitle: Text('Código: ${p['codigo']} | Stock: ${p['stock_actual']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarProducto(p['id_producto']),
                  ),
                );
              },
            ),
    );
  }
}