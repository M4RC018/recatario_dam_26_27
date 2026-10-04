import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterView extends StatefulWidget {


  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final db = FirebaseFirestore.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  bool registrando = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  final usuario = FirebaseAuth.instance.currentUser;

  Future<void> funClickRegistro() async {
    if (registrando) return;

    final correo = emailController.text.trim();
    if (correo.isEmpty ||
        passwordController.text.isEmpty ||
        repeatPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(correo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Introduce un correo electrónico válido")),
      );
      return;
    }
    if (repeatPasswordController.text != passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden")),
      );
      return;
    }

    setState(() => registrando = true);
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: correo,
            password: passwordController.text,
          );

      if (!mounted) return;

      if (credential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cuenta creada correctamente")),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      debugPrint('Error de registro: ${e.code}');
      debugPrint('Detalle: ${e.message}');

      String mensaje = "No se ha podido crear la cuenta";

      if (e.code == 'weak-password') {
        mensaje = "La contraseña es demasiado débil";
      } else if (e.code == 'email-already-in-use') {
        mensaje = "Ya existe una cuenta con ese correo";
      } else if (e.code == 'invalid-email') {
        mensaje = "El correo electrónico no es válido";
      } else if (e.code == 'network-request-failed') {
        mensaje = "Comprueba tu conexión a Internet";
      } else if (e.code == 'operation-not-allowed') {
        mensaje = "Activa el acceso con correo y contraseña en Firebase";
      } else if (e.code == 'too-many-requests') {
        mensaje = "Demasiados intentos. Prueba de nuevo más tarde";
      } else if (e.code == 'channel-error') {
        mensaje =
            "No se ha podido comunicar con Firebase Auth. Revisa la consola";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));
    } catch (e, stackTrace) {
      debugPrint('Error inesperado de registro: $e\n$stackTrace');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ha ocurrido un error inesperado")),
      );
    } finally {
      if (mounted) setState(() => registrando = false);
    }
    if(usuario == null){
      debugPrint('No existe ese usuario');
      return;
    }
    final document = await db.collection('perfil').doc(usuario?.uid).get();
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
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
                  const Icon(
                    Icons.restaurant_menu_rounded,
                    size: 48,
                    color: Color(0xFF9A3412),
                  ),
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
                    controller: emailController,
                    enabled: !registrando,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: "Correo electrónico",
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
                        borderSide: const BorderSide(
                          color: Color(0xFF9A3412),
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: passwordController,
                    enabled: !registrando,
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
                        borderSide: const BorderSide(
                          color: Color(0xFF9A3412),
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: repeatPasswordController,
                    enabled: !registrando,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Repetir contraseña",
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF9A3412),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFF7ED),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFFED7AA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF9A3412),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9A3412),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: registrando ? null : funClickRegistro,
                    child: Text(
                      registrando ? "Creando cuenta..." : "Crear cuenta",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
