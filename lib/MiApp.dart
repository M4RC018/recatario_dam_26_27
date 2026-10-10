import 'package:recetario_dam_mry/insLib/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:recetario_dam_mry/views/HomeView.dart';
import 'package:recetario_dam_mry/views/LoginView.dart';
import 'package:recetario_dam_mry/views/ProfileView.dart';
import 'package:recetario_dam_mry/views/RegisterView.dart';
import 'package:recetario_dam_mry/views/SplashView.dart';

/// Configura la pantalla inicial y los nombres usados por Navigator.
class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Recetario",
      // Colores compartidos en insLib/theme, como en el proyecto de clase.
      theme: ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColores.oscuro, height: 1.5),
          titleLarge: TextStyle(
            color: AppColores.oscuro,
            fontWeight: FontWeight.w700,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColores.principal,
          primary: AppColores.principal,
        ),
        scaffoldBackgroundColor: AppColores.fondo,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColores.fondo,
          foregroundColor: AppColores.principal,
          centerTitle: true,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColores.fondo,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColores.suave),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
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
        // Ruta del formulario accesible desde la barra, aún sin guardado.
        "/ProfileView": (context) => ProfileView(),
      },
    );
  }
}
