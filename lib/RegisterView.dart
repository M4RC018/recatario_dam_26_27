import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
              onPressed: () {},
              child: const Text("Crear cuenta"),
            ),

            TextButton(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF9A3412)),
              onPressed: () {},
              child: const Text("¿Ya tienes cuenta? Inicia sesión", textAlign: TextAlign.center),
            ),
          ],
        ),
      )))),
    );
  }
}

