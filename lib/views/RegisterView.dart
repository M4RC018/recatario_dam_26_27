import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DataHolder.dart';
import 'Perfil.dart';

/// Reutiliza la pantalla para crear la cuenta o completar nombre y edad.
/// Separar estos formularios en ProfileView queda pendiente.
class RegisterView extends StatefulWidget {
  const RegisterView({super.key, this.completarPerfil = false});
  final bool completarPerfil;


  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nombreController = TextEditingController();
  final edadController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  // Controla el bloqueo de botones durante las operaciones asíncronas.
  bool registrando = false;
  late bool completandoPerfil;

  @override
  void initState() {
    super.initState();
    // Solo se permite guardar un perfil si hay una sesión identificada.
    completandoPerfil = widget.completarPerfil &&
        FirebaseAuth.instance.currentUser != null;
    if (completandoPerfil) {
      final perfil = DataHolder.instance.perfilUsuario;
      // Precargamos una sola vez para no borrar lo escrito al redibujar.
      if (perfil?.uid == FirebaseAuth.instance.currentUser?.uid) {
        nombreController.text = perfil?.nombre ?? '';
        edadController.text = perfil?.edad?.toString() ?? '';
      }
    }
  }

  @override
  void dispose() {
    // Los controladores pertenecen a esta pantalla; liberamos sus recursos.
    nombreController.dispose();
    edadController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  /// Valida el formulario, guarda el objeto Perfil y abre Home al terminar.
  Future<void> funGuardarPerfil() async {
    if (registrando) return;
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) {
      setState(() => completandoPerfil = false);
      return;
    }
    if (nombreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce tu nombre')),
      );
      return;
    }
    // tryParse devuelve null si el texto no es un entero, sin lanzar un error.
    final edad = int.tryParse(edadController.text.trim());
    if (edad == null || edad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce una edad válida')),
      );
      return;
    }
    setState(() => registrando = true);
    try {
      final perfil = Perfil(
        uid: usuario.uid,
        nombre: nombreController.text.trim(),
        edad: edad,
      );

      // El conversor llama a toFirestore. merge conserva otros campos
      // existentes, por ejemplo el correo de perfiles creados anteriormente.
      await DataHolder.instance.perfiles
          .doc(usuario.uid)
          .set(perfil, SetOptions(merge: true));

      // Actualizamos la copia compartida solo después de guardar correctamente.
      DataHolder.instance.perfilUsuario = perfil;
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/HomeView');
    } on FirebaseException catch (e) {
      debugPrint('Error al guardar perfil: ${e.code}: ${e.message}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.code == 'permission-denied'
            ? 'Firestore no permite guardar el perfil. Revisa sus reglas.'
            : 'No se ha podido guardar el perfil. Inténtalo de nuevo.')),
      );
    } finally {
      if (mounted) setState(() => registrando = false);
    }
  }

  /// Crea la cuenta en Authentication; el documento de perfil se guarda después.
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
        // Firebase acaba de crear la cuenta y deja su sesión iniciada.
        // Cambiamos de formulario sin crear otra cuenta ni otra pantalla.
        DataHolder.instance.perfilUsuario = Perfil(uid: credential.user!.uid);
        passwordController.clear();
        repeatPasswordController.clear();
        setState(() => completandoPerfil = true);
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
  }

  @override
  Widget build(BuildContext context) {
    // Este modo muestra nombre y edad. El otro muestra correo y contraseñas.
    if (completandoPerfil) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF7ED),
        appBar: AppBar(title: const Text('Completa tu perfil')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Completa tu nombre y edad para continuar.'),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nombreController,
                    enabled: !registrando,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: edadController,
                    enabled: !registrando,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Edad'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9A3412),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: registrando ? null : funGuardarPerfil,
                    child: Text(registrando ? 'Guardando...' : 'Guardar perfil'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
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
