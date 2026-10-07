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


  Future<void> funClickLogin() async {
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
        DataHolder.instance.perfilUsuario = null;
        final documento = await FirebaseFirestore.instance
            .collection('perfil')
            .doc(usuario.uid)
            .get();
        if (!mounted) return;

        final datos = documento.data();

        final perfil = datos != null
          ?Perfil.fromMap(documento.id, datos)
            : Perfil(uid: usuario.uid);

        DataHolder.instance.perfilUsuario = perfil;
        final tieneEdad = perfil.edad != null && perfil.edad! > 0;
        final tieneNombre = perfil.nombre?.trim().isNotEmpty ?? false;

        if(documento.exists && tieneNombre&& tieneEdad){
          Navigator.pushReplacementNamed(context, "/HomeView");
        } else {
          Navigator.pushReplacementNamed(context, '/RegisterView', arguments: true);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se ha podido iniciar sesión"),
        ),
      );

      debugPrint("Error de login: ${e.code}");
    } on FirebaseException catch (e) {
      debugPrint('Error de Firestore: ${e.code}: ${e.message}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.code == 'permission-denied'
            ? 'Firestore no permite leer el perfil. Revisa sus reglas.'
            : 'No se ha podido consultar el perfil. Inténtalo de nuevo.')),
      );
    } catch (e) {
      debugPrint('Error de login: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ha ocurrido un error al iniciar sesión')),
      );
    } finally {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterView()), // Cambia por el nombre de tu vista
                );
              },
              child: const Text("¿No tienes cuenta? Regístrate", textAlign: TextAlign.center),
            ),
          ],
        ),
      )))),
    );
  }
}

