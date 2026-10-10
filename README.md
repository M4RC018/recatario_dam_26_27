# Recetario DAM

Aplicación de recetas desarrollada con Flutter y Firebase para el proyecto de 2.º de DAM.

**Estado documentado: 10 de octubre de 2026.** Proyecto en desarrollo. Actualmente implementa el acceso, el registro y el perfil del usuario; todavía no permite gestionar recetas. Entrega de la fase 1: 16 de octubre de 2026.

## 1. Tecnologías

- Entorno consultado: Flutter 3.47.3 (stable) y Dart 3.13.3.
- Restricción de Dart en `pubspec.yaml`: `^3.13.3`.
- `firebase_core`: inicialización de Firebase.
- `firebase_auth`: registro y acceso con correo y contraseña.
- `cloud_firestore`: lectura y escritura de perfiles.
- `flutter_test`: pruebas de widgets.

Las versiones resueltas están en `pubspec.lock`. Las plataformas prioritarias para la entrega son Android y web. Tener carpetas de iOS, macOS y Windows no significa que se hayan probado esas plataformas.

## 2. Estructura actual

```text
lib/
  main.dart                 Inicializa Firebase y ejecuta MiApp.
  MiApp.dart                MaterialApp y rutas.
  firebase_options.dart     Configuración generada por FlutterFire.
  DataHolder.dart           Perfil compartido y referencia con conversor.
  Admins/                   Administradores de servicios (preparada).
  FbObjects/
    Perfil.dart             Modelo y conversiones de datos de Firestore.
  insLib/
    theme/AppTheme.dart     Colores compartidos azul y violeta.
    bot_bars/InsBotBarStyle1.dart  Barra compartida de tres destinos.
  views/
    SplashView.dart         Imagen URL, progreso y recuperación del perfil.
    ProfileView.dart        Campos y validaciones en construcción; sin guardado.
    LoginView.dart          Acceso y comprobación del perfil.
    RegisterView.dart       Registro y formulario de nombre y edad.
    HomeView.dart           Pantalla de bienvenida provisional.


test/
  register_view_test.dart   Validaciones locales del registro.
  widget_test.dart          Prueba heredada del contador de Flutter.
android/, ios/, macos/, web/, windows/
                            Proyectos y configuración de plataformas.
```

La estructura sigue el ejemplo de clase: `views` contiene las pantallas, `FbObjects` los modelos de Firestore y `DataHolder.dart` comparte los datos desde la raíz de `lib`. `Admins` está preparada para administradores de servicios e `insLib` contiene el tema y la barra reutilizable. Las carpetas preparadas incluyen `.gitkeep` para conservarlas en el repositorio. Las consultas todavía están dentro de las vistas; crear administradores de datos sigue pendiente.

## 3. Arranque en un equipo limpio

### Requisitos

1. Instalar Git y Flutter, incluyendo Dart, y añadir sus ejecutables al PATH. Usar una versión compatible con el Dart declarado arriba.
2. Instalar Chrome para web.
3. Para Android, instalar Android Studio, Android SDK y un emulador con Google Play mediante Device Manager. Configurar las herramientas que solicite `flutter doctor` y aceptar las licencias con `flutter doctor --android-licenses`.
4. En Windows, activar el Modo de desarrollador si Flutter solicita soporte de enlaces simbólicos. Se puede abrir la configuración con `start ms-settings:developers` en PowerShell.
5. Tener conexión a Internet para descargar dependencias y acceder a Firebase.

### Descargar y ejecutar

```powershell
git clone https://github.com/M4RC018/recatario_dam_26_27.git
cd recatario_dam_26_27
flutter --version
flutter doctor
flutter pub get
flutter devices
flutter run -d chrome
```

Ejecutar los comandos desde la carpeta que contiene `pubspec.yaml`. Para Android, arrancar el emulador en Android Studio, ejecutar `flutter devices` y después `flutter run -d ID_DEL_DISPOSITIVO`, sustituyendo ese identificador por el mostrado. No es necesario regenerar toda la aplicación con `flutter create`.

La configuración incluida apunta a `recetario-dam-rmy`. Para usarla, los servicios y las reglas de ese proyecto deben estar habilitados. Ejecutar el cliente no requiere iniciar sesión en Firebase CLI; cambiar la configuración del proyecto sí requiere acceso administrativo. Las cuentas creadas desde la aplicación son cuentas reales de ese proyecto.

### Configurar un Firebase propio o regenerar la configuración

Con Node.js y npm disponibles, instalar las herramientas:

```powershell
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
```

Desde la raíz del proyecto:

```powershell
flutterfire configure
```

Seleccionar el proyecto propio y las plataformas deseadas. Si no se reconoce un comando, revisar el PATH y reiniciar la terminal. `npm config get prefix` permite localizar los ejecutables globales de npm; FlutterFire necesita también la carpeta de ejecutables globales de Dart en el PATH.

En la consola de Firebase:

1. Activar Authentication y el proveedor Correo electrónico/contraseña.
2. Crear Cloud Firestore, base de datos predeterminada.
3. Publicar reglas que permitan a cada usuario acceder a su propio perfil.

Configuración empleada para los perfiles:

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /perfil/{uid} {
      allow read, create, update: if request.auth != null
                                 && request.auth.uid == uid;
    }
  }
}
```

Estas reglas no permiten borrar perfiles ni acceder a otras colecciones. No validan todavía los tipos o campos de cada escritura. Las recetas necesitarán reglas propias. Este bloque documenta la configuración acordada; no se ha descargado una copia de las reglas actualmente publicadas. El repositorio aún no tiene un archivo de reglas conectado al despliegue con Firebase CLI.

La configuración con FlutterFire sigue la [guía oficial de Firebase para Flutter](https://firebase.google.com/docs/flutter/setup). El control por UID se explica en las [condiciones de las reglas de Firestore](https://firebase.google.com/docs/firestore/security/rules-conditions).

## 4. Configuración y control de versiones

Se incluyen el código, `pubspec.yaml`, `pubspec.lock`, `.metadata`, los proyectos de plataformas y la configuración cliente de Firebase:

- `lib/firebase_options.dart`.
- `android/app/google-services.json`.
- `firebase.json` y los ajustes Gradle correspondientes.

La configuración cliente identifica el proyecto y no equivale a credenciales de administración. La protección de los datos depende de Authentication y las reglas. Para otras plataformas, regenerar y verificar su configuración con FlutterFire cuando proceda.

No deben subirse contraseñas, tokens de sesión, archivos de cuentas de servicio, claves privadas ni credenciales de firma. Los `.gitignore` actuales excluyen, entre otros, `build/`, `.dart_tool/`, archivos locales del IDE, `android/local.properties`, `key.properties` y almacenes de claves Android. También se excluye el registro local `registro_android.txt`. Esto no sustituye revisar `git status` y el contenido antes de cada commit.

## 5. Flujo actual del usuario

1. `main()` prepara Flutter, espera a `Firebase.initializeApp()` y ejecuta `MiApp`.
2. La ruta inicial es `/SplashView`. Muestra una imagen URL con carga y error, y cuatro pasos de espera simulada. Sin sesión abre el login; con sesión consulta el perfil y lo guarda en DataHolder antes de abrir Home. Ver las limitaciones del splash al final.
3. El registro solicita correo, contraseña y repetición. Comprueba campos vacíos, formato de correo y coincidencia de contraseñas.
4. Authentication crea la cuenta. La misma `RegisterView` pasa al modo de completar perfil.
5. El formulario solicita nombre y edad. El nombre no puede quedar vacío y la edad debe ser un entero positivo.
6. Se guarda el documento `perfil/{uid}`, se actualiza `DataHolder.instance.perfilUsuario` y se abre `/HomeView`.
7. Al iniciar sesión posteriormente, el login consulta el perfil: con nombre no vacío y edad positiva abre Home; si faltan datos, solicita completarlos.

El UID lo proporciona Authentication. Se usa también como ID del documento; por eso `documento.id` coincide con el UID. Las contraseñas se gestionan en Authentication, nunca en el documento del perfil. Un perfil sin cuenta no se puede vincular a una cuenta nueva solo por el nombre.

`RegisterView` decide su modo inicial mediante `completarPerfil` y la sesión existente. Si se solicita completar perfil sin sesión, muestra el registro. Los campos existentes se precargan solo cuando el perfil compartido pertenece al usuario actual.

## 6. Modelo y Firestore

Documento actual:

```text
perfil/{uid}
  Nombre: texto
  Edad: entero positivo
  correo: texto (puede existir en documentos antiguos; el conversor actual no lo escribe)
```

Las mayúsculas importan: `Edad` es distinto de `edad`. No se pide altura.

`Perfil` contiene `uid`, `nombre` y `edad`, todos anulables. `fromMap(uid, data)` construye el objeto a partir del documento. `toFirestore()` devuelve un mapa con `Nombre` y `Edad`; no realiza ninguna petición por sí mismo.

`DataHolder` es un singleton: `DataHolder.instance` permite compartir una única instancia. Tiene:

- `perfilUsuario`: perfil en memoria del usuario actual. Ponerlo a `null` no borra Firestore.
- `perfiles`: referencia a la colección con `withConverter<Perfil>`. Configura cómo convertir documentos en objetos y objetos en mapas; no descarga toda la colección al declararla.

**Integración actual:** el login lee mediante `DataHolder.instance.perfiles.doc(uid).get()` y recibe un `Perfil` directamente. El registro guarda mediante `.set(perfil, SetOptions(merge: true))`. Ambas operaciones utilizan el conversor definido en DataHolder.

El modelo y `toFirestore()` solo incluyen nombre y edad. El correo está disponible en Authentication. Los documentos antiguos pueden conservar el campo `correo`: `merge: true` conserva los campos que no se envían.

## 7. Rutas y recursos

| Ruta | Pantalla | Parámetros |
|---|---|---|
| `/SplashView` | SplashView | Ninguno |
| `/LoginView` | LoginView | Ninguno |
| `/RegisterView` | RegisterView | `true` solicita completar perfil |
| `/HomeView` | Homeview | Ninguno |
| `/ProfileView` | ProfileView | Ninguno |

Las rutas están declaradas en `MiApp`. El enlace de registro utiliza `Navigator.pushNamed(context, '/RegisterView')`. El argumento `true` selecciona el formulario de perfil. La separación en una pantalla ProfileView está pospuesta; ProfileView ya participa en las rutas y muestra campos y botón, pero aún no guarda; el formulario funcional sigue en RegisterView.

Los controladores de texto se liberan con `dispose()`. Las consultas actuales son puntuales (`get` y `set`), sin suscripciones que cancelar. El cierre de sesión llama a `signOut()`, limpia `perfilUsuario` y usa `pushNamedAndRemoveUntil` para retirar las rutas anteriores. Su funcionamiento completo en Android y navegador sigue pendiente de prueba manual.

## 8. Errores y limitaciones

El registro distingue correo usado, contraseña débil, correo inválido, problemas de red, proveedor deshabilitado y exceso de intentos. El login trata credenciales incorrectas, correo inválido, falta de conexión y demasiados intentos dentro de `FirebaseAuthException`. Los fallos de consulta del perfil se capturan por separado en `FirebaseException`. Esta separación se corrigió el 7 de octubre; falta verificar cada mensaje en la interfaz.

El login muestra «Correo electrónico». Home es provisional y saluda con el nombre guardado en DataHolder, o con un texto genérico si no hay nombre. En `main.dart` quedan las clases del contador original que no se ejecutan desde `runApp(MiApp())`; su prueba tampoco acredita el funcionamiento del recetario.

Problemas de arranque conocidos:

| Mensaje | Comprobación |
|---|---|
| No parece un proyecto Flutter | Abrir terminal en la carpeta de `pubspec.yaml`. |
| `firebase` no reconocido | Instalar Firebase CLI y revisar PATH. |
| Plugins requieren symlink | Activar Modo de desarrollador en Windows. |
| `permission-denied` | Revisar sesión, UID, nombre de colección y reglas publicadas. |
| `operation-not-allowed` | Habilitar correo/contraseña en Authentication. |
| `network-request-failed` | Revisar conexión y acceso a Firebase desde el entorno. |

## 9. Pruebas y evidencias

Comandos reproducibles:

```powershell
flutter test
flutter analyze
```

El 7 de octubre se ejecutaron las tres pruebas existentes. Una primera ejecución falló al cargar una suite (conexión cerrada); la repetición con `flutter test --no-pub --concurrency=1` pasó las tres. Dos cubren validaciones locales de registro y una el contador original. No cubren Authentication real, cierre de sesión ni navegación completa. El análisis específico de LoginView no detectó errores de Dart; sí avisos por imports y constructor. La compilación de la app con web-server también terminó, pero el control automatizado del navegador falló antes de recorrer las pantallas.

| Comprobación previa | Entorno | Resultado observado | Alcance |
|---|---|---|---|
| Arranque y formulario de acceso | Web local, navegador integrado | Se mostró LoginView y validación de campos vacíos | No recorrido completo |
| Login con datos ficticios | Navegador integrado | `network-request-failed` | No demuestra fallo general de Firebase |
| Registro y acceso temporal | API real de Firebase | Correctos | Verificación de backend, no de UI |
| Crear, leer y actualizar perfil | API real, tras cambiar reglas | Correctos | Prueba anterior al campo `Edad` añadido al formulario |
| Leer perfil sin sesión | API real | Rechazado con 403 | Control de acceso sin autenticación |

La cuenta temporal se eliminó. Quedó documentado el perfil ficticio `perfil/7RIfGTWIAmN2wvz6RYRyP7EIKJ63`: las reglas rechazaron su borrado. Su eliminación desde la consola no se ha confirmado.

### Tabla a completar para la entrega

No marcar como correcto un caso que no se haya ejecutado. Anotar fecha, dispositivo, navegador y capturas propias. Probar un teléfono físico no sustituye la evidencia de emulador solicitada.

| Caso | Resultado esperado | Emulador Android | Navegador |
|---|---|---|---|
| Registro nuevo | Cuenta creada y formulario de perfil | Pendiente | Pendiente |
| Correo usado / contraseña débil | Mensaje específico | Pendiente | Pendiente |
| Credenciales incorrectas | Mensaje específico y permanencia en login | Pendiente | Pendiente |
| Perfil incompleto | Solicitud de nombre y edad | Pendiente | Pendiente |
| Guardar perfil válido | Documento actualizado y Home | Pendiente | Pendiente |
| Perfil completo al entrar | Acceso a Home | Pendiente | Pendiente |
| Nombre vacío / edad inválida | Validación sin guardar | Pendiente | Pendiente |
| Cerrar sesión | Regreso a acceso y limpieza del perfil | Pendiente | Pendiente |
| Splash | Imagen URL, carga/error y recuperación de sesión | Pendiente | Implementado; recorrido completo pendiente |
| Onboarding | Tres páginas, saltar y primera visita | Sin implementar | Sin implementar |
| Lista y cuadrícula | Datos, carga, vacío y error | Sin implementar | Sin implementar |

## 10. Pendientes de fase 1

- Completar la separación de servicios en `Admins`; los modelos ya están en `FbObjects` y las pantallas en `views`.
- Verificar manualmente el recorrido con lectura y escritura tipadas ya conectadas.
- Probar las rutas por nombre y los mensajes del login ya corregidos.
- Comprobar cierre de sesión, limpieza del perfil y comportamiento de Atrás.
- Verificar el splash con imagen URL, carga y error en Android y navegador; tratar errores al recuperar el perfil.
- Onboarding de tres pantallas, omisión y persistencia de primera visita.
- Colección de recetas y al menos seis documentos de prueba para el contenido.
- Barra inferior con tres secciones, lista y cuadrícula desde Firestore y sus estados.
- Probar en emulador Android y navegador y completar la tabla con diferencias.
- Preparar PDF de capturas y resultados reales.
- Mantener al menos 15 commits que reflejen avances y confirmar invitación del profesor.
- Actualizar esta documentación y la bitácora [IA.md](IA.md).

Esta documentación describe el estado intermedio; no sustituye el PDF de evidencias ni afirma que la fase esté terminada.

## 11. Seguimiento de la sesión del 7 de octubre

- Lectura y escritura del perfil conectadas a withConverter.
- Botón de cerrar sesión añadido a HomeView.
- Ruta del enlace de registro corregida a `/RegisterView`, sin paréntesis.
- Mensajes de Authentication recolocados en su bloque específico por el asistente, con autorización del alumno.
- El alumno confirmó manualmente que funcionan los avisos de campos vacíos y contraseñas diferentes. No se han adjuntado capturas ni confirmado el dispositivo en esas respuestas; no se asignan automáticamente a Android o navegador.
- El asistente no completó el recorrido visual: la herramienta de navegador no arrancó. No se confunde la compilación web con una prueba de interacción superada.

### Guía para leer los comentarios del código

1. `main.dart`: preparación de Flutter e inicialización asíncrona de Firebase.
2. `MiApp.dart`: rutas y argumento para completar perfil.
3. `Perfil.dart`: campos personales, lectura desde mapa y preparación para escritura.
4. `DataHolder.dart`: singleton, perfil en memoria y referencia tipada.
5. `LoginView.dart`: autenticación, consulta del perfil, validación y errores.
6. `RegisterView.dart`: dos formularios, controladores, validación, guardado y cambio de modo.
7. `HomeView.dart`: cierre de sesión y limpieza del historial de navegación.

Los comentarios explican el código de la app sin modificar sus operaciones. `firebase_options.dart` se mantiene como archivo generado por FlutterFire. El ejemplo del contador que permanece en main se identifica como código heredado, no como parte del flujo real.


## 12. Avance del 8 de octubre

- Estructura adaptada al profesor: FbObjects/Perfil.dart, DataHolder en lib, vistas en views y carpetas Admins e insLib preparadas. Todavía no tienen implementaciones de servicios o componentes.
- Tema compartido y presentación de splash, perfil e inicio ajustados. El GIF actual es de Pixabay; no se sustituyó por Dash.
- El splash comprueba la sesión y consulta el perfil con la referencia tipada. DataHolder vive en memoria y se vuelve a rellenar al arrancar.
- El alumno confirmó que la sesión se conserva al detener y volver a ejecutar en navegador. No se aporta captura ni evidencia Android.
- Para repetir la prueba web en el navegador habitual y con la misma dirección:

```powershell
flutter run -d web-server --web-port=8080
```

Abrir http://localhost:8080 en el mismo navegador y perfil. Iniciar sesión, detener con q, ejecutar el mismo comando y volver a esa dirección sin cerrar sesión.

### Límites del arranque actual

- La lectura del perfil en SplashView no captura errores de Firestore: si falla, todavía no ofrece recuperación.
- Si no hay documento, abre RegisterView sin arguments: true, por lo que muestra crear cuenta. Debe pedir completar el perfil.
- El splash comprueba que existe perfil, pero no valida nombre y edad como el login.
- El progreso es simulado; el 100 % no implica que haya terminado la consulta del perfil o la descarga del GIF.
- ProfileView sigue reservada y no está conectada a las rutas. Falta el onboarding de tres páginas.
- La compilación web del 8 de octubre terminó correctamente antes de la última incorporación del alumno a la consulta del perfil. El control automatizado del navegador falló al iniciar; no se presenta como prueba visual superada.

Validación tras actualizar comentarios y documentación: las dos pruebas de register_view_test.dart pasan; flutter analyze no detecta errores, pero informa 14 avisos de estilo e importaciones. La prueba antigua del contador sigue pendiente de resolver y no se ha repetido en este cierre.

## 13. Avance del 9 y 10 de octubre

- El 9 de octubre se renovó el diseño a petición del alumno: paleta azul y violeta, sombras suaves y colores compartidos en insLib/theme/AppTheme.dart.
- El 10 de octubre se construyó el formulario de ProfileView: controladores de nombre y edad, dispose, avisos de validación y botón conectado a funGuardarPerfil.
- La barra sigue el patrón del profesor: StatelessWidget, índice recibido por constructor y navegación por rutas. Home usa índice 0 y Perfil índice 2. Explorar (1) está deshabilitada hasta crear la cuadrícula. Los casos del switch no necesitan break en la versión actual de Dart.
- ProfileView se puede abrir desde Home y volver a Home por la barra. Registro, login y splash todavía no redirigen a esta pantalla; mantienen su flujo anterior.

### Pendientes concretos del formulario

- La condición del nombre usa isNotEmpty: actualmente muestra el aviso con nombre escrito. Cambiarla a isEmpty y salir de la función tras el aviso.
- funGuardarPerfil todavía no escribe en Firestore ni actualiza DataHolder. Su nombre describe la intención, no una funcionalidad terminada.
- guardando permanece en false y todavía no bloquea ninguna petición real.
- El usuario se captura al crear el State; conviene consultarlo dentro de la función para usar la sesión actual.
- Falta precargar el perfil existente, solicitar teclado numérico y adaptar el formulario a teclado/pantallas pequeñas.
- La barra tiene tres destinos visuales, pero solo dos habilitados y aún no presenta lista ni cuadrícula de Firestore. No acredita el bloque 5 completo.

Validación del cierre del 10 de octubre: flutter analyze sin errores, con 16 avisos de estilo/importaciones. Se intentó dos veces la suite de registro: en la repetición pasó campos vacíos, pero la prueba de contraseñas distintas no terminó. No se declara la suite superada ni se realizaron pruebas visuales Android/web en este cierre.
