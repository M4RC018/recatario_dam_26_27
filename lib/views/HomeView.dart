import 'package:recetario_dam_mry/insLib/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recetario_dam_mry/insLib/bot_bars/InsBotBarStyle1.dart';

import '../DataHolder.dart';

/// Inicio provisional: saluda con el perfil cargado y permite cerrar sesión.
class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  /// Cierra la sesión, limpia el perfil en memoria y vuelve al login.
  Future<void> cerrarSesion() async {
    try {
      await FirebaseAuth.instance.signOut();

      DataHolder.instance.perfilUsuario = null;

      if (!mounted) return;

      // false elimina todas las rutas anteriores de Navigator para que
      // el botón Atrás de la app no vuelva a Home después de cerrar sesión.
      Navigator.pushNamedAndRemoveUntil(context, '/LoginView', (ruta) => false);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha podido cerrar sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.fondo,
      appBar: AppBar(
        title: const Text('Recetario'),
        actions: [
          IconButton(
            onPressed: cerrarSesion,
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(28),
            margin: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: AppColores.tarjeta,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColores.suave),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x104F46E5),
                  blurRadius: 32,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            // Si no hay nombre, muestra un saludo genérico sin forzar un null.
            child: Text(
              DataHolder.instance.perfilUsuario?.nombre?.trim().isNotEmpty ==
                      true
                  ? 'Hola, ${DataHolder.instance.perfilUsuario!.nombre!.trim()}'
                  : 'Bienvenido a tu recetario',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColores.principal,
              ),
            ),
          ),
        ),
      ),
      // Recetas corresponde al índice 0; la barra permite abrir el perfil.
      bottomNavigationBar: const InsBotBarStyle1(iBarIndex: 0),
    );
  }
}
