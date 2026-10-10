import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../insLib/theme/AppTheme.dart';
import '../insLib/bot_bars/InsBotBarStyle1.dart';

/// Formulario en construcción: muestra campos y valida, pero aún no guarda.
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Los controladores permiten leer lo escrito y se liberan en dispose().
  final nombreController = TextEditingController();
  final edadController = TextEditingController();
  // Preparada para bloquear el botón; todavía no se modifica durante la función.
  bool guardando = false;
  // Captura la sesión al crear este State; pendiente consultarla al pulsar Guardar.
  final usuario = FirebaseAuth.instance.currentUser;
  @override
  void dispose() {
    nombreController.dispose();
    edadController.dispose();
    super.dispose();
  }

  // Pendiente: persistencia en Firestore, actualización de DataHolder y precarga.
  Future<void> funGuardarPerfil() async {
    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debes iniciar sesión para guardar tu perfil')),
      );
    } else {
      final nombre = nombreController.text.trim();
      // tryParse devuelve null si el texto no representa un entero.
      final edad = int.tryParse(edadController.text.trim());
      // Pendiente corregir: el aviso debe aparecer con isEmpty, no isNotEmpty.
      // También falta return tras mostrar el aviso del nombre.
      if (nombre.isNotEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Introduce tu nombre')));
      }
      if (edad == null || edad <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Introduce una edad válida')),
        );
        return;
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completa tu perfil')),
      // La pestaña Perfil es el índice 2 de la barra compartida.
      bottomNavigationBar: const InsBotBarStyle1(iBarIndex: 2),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          constraints: const BoxConstraints(maxWidth: 420),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 56,
                color: AppColores.principal,
              ),
              const SizedBox(height: 20),
              const Text(
                'Tu perfil',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColores.oscuro,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),

                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: edadController,
                decoration: const InputDecoration(labelText: 'Edad'),
                textAlign: TextAlign.center,
              ),
              // Sin paréntesis: Flutter llama a la función al pulsar el botón.
              ElevatedButton(
                onPressed: guardando ? null : funGuardarPerfil,
                child: Text(guardando ? 'Guardando…' : 'Guardar perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
