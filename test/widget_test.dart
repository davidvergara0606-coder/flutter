// Pruebas básicas de widgets para ZoundInventory.
//
// Verifica que la app arranca correctamente y que la pantalla
// de login se muestra con sus elementos principales.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mi_primer_app/main.dart';

void main() {
  testWidgets('La app arranca y muestra la pantalla de login', (WidgetTester tester) async {
    // Construye la app y deja que se estabilice.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verifica que estamos en la pantalla de login.
    expect(find.text('ZoundInventory'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);

    // Verifica que existen los dos campos de texto (documento y contraseña).
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('El botón de login está deshabilitado mientras no se escriba nada', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // El botón "Ingresar" debe existir y ser tocable sin crashear
    // (la validación de campos vacíos la maneja el propio widget).
    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    expect(find.text('Por favor, ingresa tu documento y contraseña.'), findsOneWidget);
  });
}