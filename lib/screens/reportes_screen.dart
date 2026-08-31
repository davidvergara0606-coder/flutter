import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  String _tipoReporte = 'stock';
  List<dynamic> _datos = [];
  bool _isLoading = false;

  Future<void> _fetchReporte(String tipo) async {
    setState(() {
      _tipoReporte = tipo;
      _isLoading = true;
    });
    try {
      final res = await http.get(Uri.parse('http://192.168.1.43:5000/reportes/$tipo'));
      if (res.statusCode == 200) {
        setState(() => _datos = jsonDecode(res.body));
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes de Sistema')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () => _fetchReporte('stock'), child: const Text('Stock')),
              ElevatedButton(onPressed: () => _fetchReporte('garantia'), child: const Text('Garantías')),
              ElevatedButton(onPressed: () => _fetchReporte('devoluciones'), child: const Text('Devoluciones')),
            ],
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _datos.length,
                    itemBuilder: (ctx, i) => ListTile(
                      title: Text(_datos[i]['nombre'] ?? ''),
                      subtitle: Text(_datos[i]['observacion'] ?? 'Stock: ${_datos[i]['stock']}'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}