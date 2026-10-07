import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DataHolder.dart';
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
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/LoginView',
            (ruta) => false,
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se ha podido cerrar sesión'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xFFFFF7ED),
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
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Bienvenido a HomeView',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9A3412),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
