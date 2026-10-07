import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recetario_dam_mry/views/HomeView.dart';
import 'package:recetario_dam_mry/views/LoginView.dart';
import 'package:recetario_dam_mry/views/RegisterView.dart';

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String rutaIncial = "/LoginView";

    return MaterialApp(
      title: "Recetario",
      initialRoute: "/LoginView",
      routes: {
        "/HomeView": (context) => Homeview(),
        "/LoginView": (context) => LoginView(),
        "/RegisterView": (context) => RegisterView(
          completarPerfil: ModalRoute.of(context)?.settings.arguments == true,
        ),
      },
    );

  }

}
