# Bitácora de asistencia de IA

Actualizada el 7 de octubre de 2026. Resumen retrospectivo basado en esta conversación; el alumno debe revisarlo y añadir sus comprobaciones y lo que puede explicar por sí mismo. No atribuye al alumno pruebas o código realizados por el asistente.

| Periodo | Ayuda solicitada | Participación de la IA | Resultado y límites |
|---|---|---|---|
| 29–30 septiembre | Conectar Flutter con Firebase | Explicó Firebase CLI, FlutterFire, PATH, directorio del proyecto e inicialización | Configuración realizada durante el aprendizaje |
| 6 octubre | Revisar registro, acceso y perfiles | Inspeccionó código, ejecutó pruebas de widgets y probó APIs reales con datos ficticios | Detectó permisos insuficientes y explicó reglas por UID; después verificó lectura y escritura |
| 6 octubre | Comprender el perfil y DataHolder | Explicó UID, mapas, null, singleton y los ejemplos del profesor | El alumno fue escribiendo Perfil y DataHolder paso a paso |
| 6 octubre | Cambios en el flujo | Una primera modificación se revirtió a petición del alumno; después este autorizó añadir edad y ajustar RegisterView | La modificación posterior añadió edad, precarga, actualización de DataHolder y transición tras el registro |
| 6–7 octubre | Revisar requisitos de fase 1 | Comparó el PDF con el proyecto y señaló pendientes | withConverter, organización, navegación, pantallas y evidencias aún requieren trabajo |
| 7 octubre | Subir el proyecto completo | Añadió archivos Flutter que no estaban versionados y realizó commit y push autorizados | Se excluyeron cachés, compilaciones y el registro local |
| 7 octubre | Entender conversión tipada | Explicó fromMap, toFirestore y los parámetros del conversor | Conversor escrito en DataHolder, todavía no usado por login y guardado |
| 7 octubre | Generar documentación | Redactó README y esta bitácora a partir del código y resultados observados | Pendiente revisión del alumno; no inventa capturas ni pruebas Android |

## Criterio de trabajo

El alumno pidió aprender paso a paso y no modificar código salvo petición expresa. Se debe conservar ese criterio. Los ejemplos se adaptaron a nombre y edad; altura no forma parte del perfil de esta aplicación.

## Revisión del alumno antes de entregar

- Explicar por qué el UID coincide con el ID del documento.
- Distinguir Authentication, Firestore y el perfil guardado en memoria.
- Explicar fromMap, toFirestore y withConverter y comprobar su uso real ya integrado.
- Revisar el cambio de RegisterView y la validación de edad.
- Completar pruebas manuales con fecha, entorno y resultados propios.
- Registrar futuras ayudas y decisiones, sin inventar entradas o resultados.

## Plantilla de nuevas entradas

- Fecha:
- Problema o pregunta:
- Herramienta utilizada:
- Ayuda recibida:
- Cambios que se aplicaron:
- Cómo se verificó:
- Qué entiendo y qué queda pendiente:

## Continuación del 7 de octubre: conversor, sesión y comentarios

- Se guió al alumno para conectar la referencia tipada al login y al guardado del perfil, añadir cierre de sesión y navegar por rutas con nombre.
- Durante la revisión se detectaron una ruta con paréntesis y los mensajes de autenticación situados en el bloque de Firestore. El asistente corrigió estos últimos tras la petición expresa del alumno.
- El alumno confirmó manualmente campos vacíos y contraseñas diferentes. El recorrido restante continúa pendiente.
- Las tres pruebas existentes pasaron en ejecución secuencial tras un fallo de carga en una primera ejecución. No cubren el flujo completo ni los mensajes nuevos.
- Se intentó manejar el navegador para probar el flujo; la herramienta falló al arrancar. No se documenta como una prueba superada.
- A petición del alumno, el asistente actualizó README y esta bitácora y añadió comentarios explicativos a los archivos propios de la app. No cambió la lógica en esta tarea de documentación.
- La integración de withConverter, pendiente en las primeras entradas históricas, ya está realizada. Falta probarla de extremo a extremo y poder explicarla sin depender de los comentarios.

## 8 de octubre: organización de carpetas

- A petición del alumno, se siguió la estructura del profesor: Perfil pasó a FbObjects y DataHolder a la raíz de lib.
- Se actualizaron los imports y se prepararon Admins e insLib con .gitkeep. No se añadieron servicios ni componentes nuevos.
- Se actualizó la explicación de carpetas en el README. La lógica de acceso y guardado se conserva.


## 8 de octubre: splash, sesión y documentación

- El asistente ajustó el diseño a petición del alumno y añadió protección mounted y alternativa visual si falla el GIF.
- El alumno pidió escribir personalmente la lógica. Recibió explicación de currentUser, UID, get(), withConverter y la diferencia entre sesión persistente y DataHolder en memoria.
- El alumno añadió al splash la comprobación de sesión y la lectura del perfil. Confirmó que se conserva la sesión tras detener y volver a ejecutar en navegador.
- El asistente revisó el código y compiló la app web; no consiguió hacer la prueba visual porque falló la herramienta de navegador.
- Las dos pruebas locales del registro pasaron en la comprobación anterior. La prueba heredada del contador no terminó. No prueban el recorrido real con Firebase.
- A petición del alumno, se comentaron los archivos propios, se actualizó la documentación y se preparó el commit y push del trabajo de hoy. firebase_options.dart se conserva como archivo generado.
- Pendientes identificados sin cambiar la lógica: error de lectura en splash, ruta de perfil ausente sin arguments: true y comprobación de nombre y edad al recuperar sesión.

- Verificación del cierre: dos pruebas de registro superadas; análisis sin errores y con 14 avisos. No se repitió la prueba heredada del contador ni se realizó un recorrido Android.
