import 'Perfil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
/// Comparte el perfil actual y el acceso tipado a Firestore entre pantallas.
/// No es un widget y cambiar sus campos no redibuja automáticamente la UI.
class DataHolder {

  // Constructor privado: otras pantallas acceden mediante instance.
  DataHolder._();

  static final DataHolder instance = DataHolder._();

  // Datos en memoria. null significa que no hay perfil cargado;
  // asignar null aquí no borra el documento de Firestore.
  Perfil? perfilUsuario;

  // Preparar la referencia no descarga datos: get() lee y set() escribe.
  final perfiles = FirebaseFirestore.instance
      .collection('perfil')
      .withConverter<Perfil>(
    // Firestore entrega el documento al leer. Su ID es el UID porque
    // lo guardamos con doc(usuario.uid). opciones no se utiliza aquí.
    fromFirestore: (documento, opciones) =>
        Perfil.fromMap(documento.id, documento.data() ?? {}),
    // Al escribir un Perfil, obtenemos los campos que se enviarán a Firebase.
    toFirestore: (perfil, opciones) => perfil.toFirestore(),
  );
}
