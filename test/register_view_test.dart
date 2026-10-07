import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recetario_dam_mry/views/RegisterView.dart';

void main() {
  testWidgets('Valida campos vacíos antes de contactar con Firebase', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: RegisterView()));
    await tester.tap(find.text('Crear cuenta'));
    await tester.pump();
    expect(find.text('Completa todos los campos'), findsOneWidget);
  });

  testWidgets('Lee los tres campos y detecta contraseñas diferentes', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: RegisterView()));
    final campos = find.byType(TextField);
    await tester.enterText(campos.at(0), 'prueba@example.com');
    await tester.enterText(campos.at(1), 'clave123');
    await tester.enterText(campos.at(2), 'otraClave');
    await tester.ensureVisible(find.text('Crear cuenta'));
    await tester.tap(find.text('Crear cuenta'));
    await tester.pump();
    expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    expect(find.text('Completa todos los campos'), findsNothing);
  });
}
