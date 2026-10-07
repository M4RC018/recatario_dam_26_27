import 'package:cloud_firestore/cloud_firestore.dart';
/// Datos personales del usuario. No contiene ni almacena su contraseña.
class Perfil {
  String? uid;
  String? nombre;
  int? edad;

  Perfil({
    this.uid,
    this.nombre,
    this.edad,
  });

  // Convierte campos descargados en un objeto. Los datos ausentes o de un
  // tipo inesperado quedan en null para que el login pida completar el perfil.
  factory Perfil.fromMap(String uid, Map<String, dynamic> data) {
    return Perfil(
      uid: uid,
      nombre: data['Nombre'] is String
          ? data['Nombre'] as String
          : null,
      edad: data['Edad'] is num
          ? (data['Edad'] as num).toInt()
          : null,
    );
  }
  // Prepara un mapa; no realiza una escritura. El conversor lo usa en set().
  // Las claves respetan las mayúsculas de Firestore. El UID es el ID del doc.
  Map<String, dynamic> toFirestore(){
    return {
      'Nombre' : nombre,
      'Edad': edad
    };
  }
}
