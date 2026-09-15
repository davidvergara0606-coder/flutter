  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'providers/auth_provider.dart';

  import 'screens/login_screen.dart';
  import 'screens/dashboard_screen.dart';
  import 'screens/dashboard_bodega_screen.dart';
  import 'screens/inventario_screen.dart';
  import 'screens/inventario_crud_screen.dart';
  import 'screens/productos_catalogo_screen.dart';
  import 'screens/entradas_screen.dart';
  import 'screens/salidas_form_screen.dart';
  import 'screens/reportes_screen.dart';
  import 'screens/alertas_stock_screen.dart';
  import 'screens/crear_usuario_screen.dart';
  import 'screens/perfil_usuario_screen.dart';

  void main() {
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ZoundInventory Flutter',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(), // <-- ¡Agregada aquí!
            '/dashboard': (context) => const DashboardScreen(),
            '/dashboard_bodega': (context) => const DashboardBodegaScreen(),
            '/inventario': (context) => const InventarioScreen(),
            '/inventario_crud': (context) => const InventarioCRUDScreen(),
            '/productos_catalogo': (context) => const ProductosCatalogoScreen(),
            '/entradas': (context) => const EntradasScreen(),
            '/salidas_form': (context) => const SalidasFormScreen(),
            '/reportes': (context) => const ReportesScreen(),
            '/alertas_stock': (context) => const AlertasStockScreen(),
            '/crear_usuario': (context) => const CrearUsuarioScreen(),
            '/perfil_usuario': (context) => const PerfilUsuarioScreen(),
          },
        ),
      );
    }
  }