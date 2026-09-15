import 'package:flutter/material.dart';

class DashboardBodegaScreen extends StatelessWidget {
  const DashboardBodegaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Bodega - ZoundInventory')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/entradas'),
              child: const Text('Registrar Entradas'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/salidas_form'),
              child: const Text('Registrar Salidas'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/alertas_stock'),
              child: const Text('Alertas de Stock'),
            ),
          ],
        ),
      ),
    );
  }
}