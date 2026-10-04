import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {

  @override
  State<RegisterView> createState() => _RegisterViewState();
}


class _RegisterViewState extends State<RegisterView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> funClickRegistro() async {
    if (repeatPasswordController.text != passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Las contraseñas no coinciden"),
        ),
      );
      return;
    }

    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      if (credential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cuenta creada correctamente"),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      debugPrint('Error de registro: ${e.code}');
      debugPrint('Detalle: ${e.message}');

      String mensaje = "${e.code}: ${e.message}";

      if (e.code == 'weak-password') {
        mensaje = "La contraseña es demasiado débil";
      } else if (e.code == 'email-already-in-use') {
        mensaje = "Ya existe una cuenta con ese correo";
      } else if (e.code == 'invalid-email') {
        mensaje = "El correo electrónico no es válido";
      } else if (e.code == 'network-request-failed') {
        mensaje = "Comprueba tu conexión a Internet";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    } catch (e){
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ha ocurrido un error inesperado")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      appBar: AppBar(
        title: const Text("RECETARIO"),
        backgroundColor: const Color(0xFFFFF7ED),
        foregroundColor: const Color(0xFF9A3412),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(child: Center(child: SingleChildScrollView(child: Container(
        margin: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFFED7AA)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.restaurant_menu_rounded, size: 48, color: Color(0xFF9A3412)),
            const SizedBox(height: 24),

            const Text(
              "Crea tu cuenta",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                color: Color(0xFF431407),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 28),

            TextField(
              decoration: InputDecoration(
                labelText: "Usuario",
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: const Color(0xFFFFF7ED),
                prefixIconColor: const Color(0xFF9A3412),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFED7AA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF9A3412), width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Contraseña",
                prefixIcon: const Icon(Icons.lock),
                filled: true,
                fillColor: const Color(0xFFFFF7ED),
                prefixIconColor: const Color(0xFF9A3412),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFED7AA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF9A3412), width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Repetir contraseña",
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9A3412)),
                filled: true,
                fillColor: const Color(0xFFFFF7ED),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFED7AA))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF9A3412), width: 2))
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9A3412),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: funClickRegistro,
              child: const Text("Crear cuenta"),
            ),
          ],
        ),
      )))),
    );
  }
}

