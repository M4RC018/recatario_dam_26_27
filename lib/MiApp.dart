import 'package:flutter/material.dart';
import 'package:recetario_dam_mry/views/HomeView.dart';
import 'package:recetario_dam_mry/views/LoginView.dart';
import 'package:recetario_dam_mry/views/RegisterView.dart';
import 'package:recetario_dam_mry/views/SplashView.dart';

/// Configura la pantalla inicial y los nombres usados por Navigator.
class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Recetario",
      // Estilo común de la app; insLib queda preparada para extraerlo como en clase.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9A3412)),
        scaffoldBackgroundColor: const Color(0xFFFFF7ED),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF7ED),
          foregroundColor: Color(0xFF9A3412),
          centerTitle: true,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFF7ED),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFED7AA)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      // El splash precede al acceso a la cuenta.
      initialRoute: "/SplashView",
      // Las claves deben coincidir exactamente con los nombres usados al navegar.
      routes: {
        "/SplashView": (context) => SplashView(),
        "/HomeView": (context) => Homeview(),
        "/LoginView": (context) => LoginView(),
        "/RegisterView": (context) => RegisterView(
          // arguments: true pide los datos personales; sin argumento crea cuenta.
          completarPerfil: ModalRoute.of(context)?.settings.arguments == true,
        ),
      },
    );
  }
}
