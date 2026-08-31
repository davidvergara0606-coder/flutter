import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductosCatalogoScreen extends StatefulWidget {
  const ProductosCatalogoScreen({super.key});

  @override
  State<ProductosCatalogoScreen> createState() => _ProductosCatalogoScreenState();
}

class _ProductosCatalogoScreenState extends State<ProductosCatalogoScreen> {
  List<dynamic> _productos = [];

  @override
  void initState() {
    super.initState();
    http.get(Uri.parse('http://192.168.1.43:5000/productos')).then((res) {
      if (res.statusCode == 200) {
        setState(() => _productos = jsonDecode(res.body));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Productos')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1),
        itemCount: _productos.length,
        itemBuilder: (ctx, i) => Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory, size: 48),
              Text(_productos[i]['nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Stock: ${_productos[i]['stock_actual']}'),
            ],
          ),
        ),
      ),
    );
  }
}