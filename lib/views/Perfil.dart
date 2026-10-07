class Perfil {
  String? uid;
  String? nombre;
  int? edad;

  Perfil({
    this.uid,
    this.nombre,
    this.edad,
  });

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
}