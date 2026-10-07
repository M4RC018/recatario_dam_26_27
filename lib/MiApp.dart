import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recetario_dam_mry/views/HomeView.dart';
import 'package:recetario_dam_mry/views/LoginView.dart';
import 'package:recetario_dam_mry/views/RegisterView.dart';

/// Configura la pantalla inicial y los nombres usados por Navigator.
class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String rutaIncial = "/LoginView";

    return MaterialApp(
      title: "Recetario",
      // Por ahora siempre se abre el login; splash y onboarding están pendientes.
      initialRoute: "/LoginView",
      routes: {
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
