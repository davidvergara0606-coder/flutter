import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../services/api_service.dart';

class ProductosCatalogoScreen extends StatefulWidget {
  const ProductosCatalogoScreen({super.key});

  @override
  State<ProductosCatalogoScreen> createState() =>
      _ProductosCatalogoScreenState();
}

class _ProductosCatalogoScreenState extends State<ProductosCatalogoScreen> {
  List<Producto> _productos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      final res = await ApiService.get('/productos');
      if (!mounted) return;
      if (res.statusCode == 200) {
        final List<dynamic> lista = jsonDecode(res.body);
        setState(() {
          _productos = lista.map((json) => Producto.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Error del servidor (código ${res.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error de conexión: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Productos')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: _productos.length,
                  itemBuilder: (ctx, i) => Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inventory, size: 48),
                        Text(
                          _productos[i].nombre,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Stock: ${_productos[i].stockActual}'),
                      ],
                    ),
                  ),
                ),
    );
  }
}