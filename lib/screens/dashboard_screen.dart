import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mi_primer_app/providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - ZoundInventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login', 
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¡Bienvenido al Dashboard!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/inventario'),
              icon: const Icon(Icons.inventory),
              label: const Text('Ver Inventario'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/inventario_crud'),
              icon: const Icon(Icons.edit),
              label: const Text('Gestión de Inventario (CRUD)'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/productos_catalogo'),
              icon: const Icon(Icons.store),
              label: const Text('Catálogo de Productos'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/entradas'),
              icon: const Icon(Icons.login),
              label: const Text('Entradas'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/salidas_form'),
              icon: const Icon(Icons.logout),
              label: const Text('Salidas'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/reportes'),
              icon: const Icon(Icons.bar_chart),
              label: const Text('Reportes'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/alertas_stock'),
              icon: const Icon(Icons.warning),
              label: const Text('Alertas de Stock'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/crear_usuario'),
              icon: const Icon(Icons.person_add),
              label: const Text('Crear Usuario'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/perfil_usuario'),
              icon: const Icon(Icons.person),
              label: const Text('Perfil de Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}