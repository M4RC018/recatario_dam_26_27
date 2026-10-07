import 'package:flutter/material.dart';
import 'package:recetario_dam_mry/views/RegisterView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Perfil.dart';
import 'DataHolder.dart';



class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool entrando = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  /// Autentica la cuenta y decide si ir a Home o completar sus datos personales.
  Future<void> funClickLogin() async {
    // Evita varias peticiones si se pulsa el botón mientras estamos esperando.
    if (entrando) return;
    if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce correo y contraseña')),
      );
      return;
    }
    setState(() => entrando = true);
    try {
      final credential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final usuario = credential.user;

      if (usuario != null) {
        // Evita conservar datos de otro usuario durante la consulta.
        DataHolder.instance.perfilUsuario = null;
        final documento = await DataHolder.instance.perfiles
          .doc(usuario.uid)
          .get();
        if (!mounted) return;

        // withConverter ya devuelve un Perfil, no un Map.
        // Si no existe el documento, creamos un objeto vacío para completarlo.
        final perfil = documento.data() ?? Perfil(uid: usuario.uid);

        DataHolder.instance.perfilUsuario = perfil;
        // No basta con que exista el documento: comprobamos sus campos.
        final tieneEdad = perfil.edad != null && perfil.edad! > 0;
        final tieneNombre = perfil.nombre?.trim().isNotEmpty ?? false;

        if(documento.exists && tieneNombre&& tieneEdad){
          Navigator.pushReplacementNamed(context, "/HomeView");
        } else {
          Navigator.pushReplacementNamed(context, '/RegisterView', arguments: true);
        }
      }
    } on FirebaseAuthException catch (e) {
      // Primero el error específico de Authentication; los fallos al leer
      // Firestore se tratan en el siguiente bloque FirebaseException.
      if (!mounted) return;

      String mensaje = 'No se ha podido iniciar sesión';

      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        mensaje = 'Correo o contraseña incorrectos';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El correo electrónico no es válido';
      } else if (e.code == 'network-request-failed') {
        mensaje = 'Comprueba tu conexión a Internet';
      } else if (e.code == 'too-many-requests') {
        mensaje = 'Demasiados intentos. Prueba más tarde';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
      debugPrint('Error de login: ${e.code}');
    } on FirebaseException catch (e) {
      debugPrint('Error de Firestore: ${e.code}: ${e.message}');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.code == 'permission-denied'
            ? 'No tienes permiso para consultar el perfil.'
            : 'No se ha podido consultar el perfil. Inténtalo de nuevo.')),
      );
    } finally {
      // Se ejecuta tanto si funcionó como si hubo error. mounted comprueba
      // que la pantalla sigue existiendo antes de actualizarla con setState.
      if (mounted) setState(() => entrando = false);
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
              "Bienvenido de nuevo",
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
              controller: passwordController,
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

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9A3412),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: entrando ? null : funClickLogin,
              child: Text(entrando ? 'Entrando...' : 'Iniciar sesión'),
            ),

            TextButton(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF9A3412)),
              onPressed: () {
                Navigator.pushNamed(context, '/RegisterView');
              },
              child: const Text("¿No tienes cuenta? Regístrate", textAlign: TextAlign.center),
            ),
          ],
        ),
      )))),
    );
  }
}

