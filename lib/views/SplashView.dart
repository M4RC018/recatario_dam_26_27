import 'package:recetario_dam_mry/insLib/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recetario_dam_mry/DataHolder.dart';
import 'package:recetario_dam_mry/FbObjects/Perfil.dart';

/// Pantalla inicial: muestra una imagen remota y recupera el perfil si hay sesión.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  // Porcentaje simulado: los recursos actuales solo esperan un segundo.
  int progreso = 0;

  @override
  void initState() {
    super.initState();
    // Se inicia una sola vez al crear la pantalla.
    cargarRecursos();
  }

  /// Simula cuatro pasos y después decide la ruta según sesión y perfil.
  /// Pendiente: capturar errores de Firestore y comprobar nombre y edad.
  void cargarRecursos() async {
    // Tras cada espera, mounted evita actualizar una pantalla ya destruida.
    await recursos1();
    if (!mounted) return;
    setState(() => progreso = 20);
    await recursos2();
    if (!mounted) return;
    setState(() => progreso = 50);
    await recursos3();
    if (!mounted) return;
    setState(() => progreso = 80);
    await recursos4();
    if (!mounted) return;
    setState(() => progreso = 100);

    // Authentication conserva la sesión; DataHolder debe rellenarse de nuevo.
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacementNamed(context, '/LoginView');
    } else {
      // El ! es válido aquí porque la rama anterior descartó un usuario null.
      final usuario = FirebaseAuth.instance.currentUser!;
      // El UID es también el ID del documento. get() hace una lectura puntual.
      final documento = await DataHolder.instance.perfiles
          .doc(usuario.uid)
          .get();

      if (!mounted) return;

      // withConverter devuelve Perfil; data() será null si no existe.
      final perfil = documento.data();
      DataHolder.instance.perfilUsuario = perfil;

      // Pendiente: enviar arguments: true para completar el perfil, como el login.
      // Actualmente esta ruta muestra el formulario de crear una cuenta.
      if (perfil == null) {
        Navigator.pushReplacementNamed(context, '/RegisterView');
      } else {
        Navigator.pushReplacementNamed(context, '/HomeView');
      }
    }
  }

  // Estos cuatro métodos son simulaciones, no descargan recursos reales.
  Future<void> recursos1() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> recursos2() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> recursos3() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> recursos4() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          // Permite desplazar el contenido en pantallas pequeñas.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(32),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.restaurant_menu_rounded,
                    size: 40,
                    color: AppColores.principal,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Recetario',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColores.oscuro,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tu cocina empieza aquí',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Imagen de Internet: loadingBuilder muestra espera y
                  // errorBuilder ofrece un icono si falla la descarga.
                  Image.network(
                    'https://cdn.pixabay.com/animation/2023/08/11/21/18/21-18-05-265_512.gif',
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        height: 180,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          height: 180,
                          child: Icon(
                            Icons.soup_kitchen_rounded,
                            size: 88,
                            color: AppColores.principal,
                          ),
                        ),
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    // El widget espera un valor entre 0 y 1, no entre 0 y 100.
                    child: LinearProgressIndicator(
                      value: progreso / 100,
                      minHeight: 8,
                      backgroundColor: AppColores.suave,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Preparando tu recetario… $progreso %',
                    textAlign: TextAlign.center,
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
