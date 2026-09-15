import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  String _tipoReporte = 'stock';
  List<dynamic> _datos = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchReporte('stock');
  }

  Future<void> _fetchReporte(String tipo) async {
    setState(() {
      _tipoReporte = tipo;
      _isLoading = true;
      _error = null;
      _datos = [];
    });

    try {
      final res = await ApiService.get('/reportes/$tipo');
      if (!mounted) return;
      if (res.statusCode == 200) {
        setState(() => _datos = jsonDecode(res.body));
      } else {
        setState(() => _error = 'Error HTTP ${res.statusCode} al cargar el reporte');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Error de conexión al cargar el reporte: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  ButtonStyle _estiloBoton(String tipo) {
    final activo = _tipoReporte == tipo;
    return ElevatedButton.styleFrom(
      backgroundColor: activo ? Colors.blue : null,
      foregroundColor: activo ? Colors.white : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes de Sistema')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: _estiloBoton('stock'),
                  onPressed: () => _fetchReporte('stock'),
                  child: const Text('Stock'),
                ),
                ElevatedButton(
                  style: _estiloBoton('garantia'),
                  onPressed: () => _fetchReporte('garantia'),
                  child: const Text('Garantías'),
                ),
                ElevatedButton(
                  style: _estiloBoton('devoluciones'),
                  onPressed: () => _fetchReporte('devoluciones'),
                  child: const Text('Devoluciones'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!, style: const TextStyle(color: Colors.redAccent)))
                    : _datos.isEmpty
                        ? const Center(child: Text('No hay datos disponibles'))
                        : ListView.builder(
                            itemCount: _datos.length,
                            itemBuilder: (ctx, i) => ListTile(
                              title: Text(_datos[i]['nombre']?.toString() ?? 'Sin nombre'),
                              subtitle: Text(_datos[i]['observacion']?.toString() ?? 'Stock: ${_datos[i]['stock'] ?? 0}'),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}