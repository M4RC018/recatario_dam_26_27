import 'package:flutter/material.dart';

/// Barra compartida: cada pantalla indica cuál de sus tres opciones está activa.
class InsBotBarStyle1 extends StatelessWidget {
  const InsBotBarStyle1({super.key, required this.iBarIndex});

  // 0: Recetas; 1: Explorar (pendiente); 2: Perfil.
  final int iBarIndex;

  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: iBarIndex,
    onDestinationSelected: (index) {
      // No sustituimos la pantalla si el usuario pulsa su sección actual.
      if (index == iBarIndex) return;
      // En Dart actual, estos casos terminan automáticamente sin break.
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/HomeView');
        case 2:
          Navigator.pushReplacementNamed(context, '/ProfileView');
      }
    },
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'Recetas',
      ),
      // Se habilitará cuando construyamos la pantalla de cuadrícula.
      NavigationDestination(
        icon: Icon(Icons.grid_view_outlined),
        selectedIcon: Icon(Icons.grid_view_rounded),
        label: 'Explorar',
        enabled: false,
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline_rounded),
        selectedIcon: Icon(Icons.person_rounded),
        label: 'Perfil',
      ),
    ],
  );
}
