import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlertasStockScreen extends StatefulWidget {
  const AlertasStockScreen({super.key});

  @override
  State<AlertasStockScreen> createState() => _AlertasStockScreenState();
}

class _AlertasStockScreenState extends State<AlertasStockScreen> {
  List<dynamic> _alertas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlertas();
  }

  Future<void> _fetchAlertas() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.43:5000/productos/alertas'));
      if (response.statusCode == 200) {
        setState(() {
          _alertas = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alertas de Stock Mínimo')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alertas.isEmpty
              ? const Center(child: Text('No hay alertas de stock registradas.'))
              : ListView.builder(
                  itemCount: _alertas.length,
                  itemBuilder: (context, index) {
                    final p = _alertas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.redAccent.withOpacity(0.15),
                      child: ListTile(
                        leading: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 32),
                        title: Text(p['nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Código: ${p['codigo']} | Stock Mínimo: ${p['stock_minimo']}'),
                        trailing: Text(
                          'Stock: ${p['stock_actual']}',
                          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}