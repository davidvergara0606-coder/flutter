import 'package:flutter/material.dart';

class InventarioScreen extends StatelessWidget {
  const InventarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Inventario'),
      ),
      body: const Center(
        child: Text(
          'Aquí irá la lista de productos',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}