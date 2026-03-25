import 'dart:io';
import 'dart:convert';

Future<void> menuTiempoActivo() async {
  bool salir = false;

  while (!salir) {
    print("==============================================================================================");
    print("MÓDULO: TIEMPO ACTIVO DE USUARIOS");
    print("----------------------------------------------------------------------------------------------");
    print(" 1 : Calcular tiempo activo de un usuario");
    print(" 2 : Calcular tiempo activo de todos los usuarios");
    print(" 3 : Volver al menú principal"); // 👈 opción para regresar al main
    print(" 4 : Salir del programa");
    print("==============================================================================================");

    stdout.write("Selecciona una opción: ");
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "1":
        stdout.write("Ingrese el ID del usuario: ");
        String id = stdin.readLineSync() ?? "";
        await calcularTiempoActivo(id);
        break;

      case "2":
        await calcularTiempoActivoTodos();
        break;

      case "3":
        salir = true; // 👈 regresa al menú principal
        break;

      case "4":
        print("Saliendo del programa... ¡Hasta luego!");
        exit(0); // termina el programa completo

      default:
        print("Opción inválida. Intenta de nuevo.");
    }
  }
}

/// Calcula el tiempo total que un usuario ha estado activo.
/// Si el usuario desactiva su membresía, el contador se reinicia.
Future<void> calcularTiempoActivo(String usuarioId) async {
  File usuarioData = File("usuarios/$usuarioId.json");

  if (!await usuarioData.exists()) {
    print("Error 404: Usuario no encontrado.");
    return;
  }

  String contenido = await usuarioData.readAsString();
  Map<String, dynamic> datos = jsonDecode(contenido);

  bool status = datos["MembresiaStatus"] ?? true;
  String fechaActivacionStr = (datos["FechaActivacion"] ?? "").toString();

  if (status) {
    if (fechaActivacionStr.isEmpty) {
      datos["FechaActivacion"] = DateTime.now().toIso8601String();
      await usuarioData.writeAsString(JsonEncoder.withIndent("  ").convert(datos));
      print("Fecha de activación registrada para ${datos["Nombre"]}");
      return;
    }

    DateTime fechaActivacion = DateTime.parse(fechaActivacionStr);
    Duration tiempoActivo = DateTime.now().difference(fechaActivacion);

    print("Usuario ${datos["Nombre"]} ha estado activo por ${tiempoActivo.inDays} días.");
  } else {
    datos["FechaActivacion"] = "";
    await usuarioData.writeAsString(JsonEncoder.withIndent("  ").convert(datos));
    print("Usuario ${datos["Nombre"]} está inactivo. Tiempo activo reiniciado.");
  }
}

/// Calcula el tiempo activo de todos los usuarios registrados.
Future<void> calcularTiempoActivoTodos() async {
  final dir = Directory("usuarios");

  if (!dir.existsSync()) {
    print("No hay usuarios registrados todavía.");
    return;
  }

  final archivos = dir.listSync().where((f) => f.path.endsWith(".json"));

  if (archivos.isEmpty) {
    print("No hay usuarios registrados todavía.");
    return;
  }

  print("==============================================================================================");
  print("TIEMPO ACTIVO DE TODOS LOS USUARIOS");
  print("----------------------------------------------------------------------------------------------");

  for (var archivo in archivos) {
    try {
      String contenido = await File(archivo.path).readAsString();
      Map<String, dynamic> datos = jsonDecode(contenido);

      bool status = datos["MembresiaStatus"] ?? true;
      String fechaActivacionStr = (datos["FechaActivacion"] ?? "").toString();

      if (status && fechaActivacionStr.isNotEmpty) {
        DateTime fechaActivacion = DateTime.parse(fechaActivacionStr);
        Duration tiempoActivo = DateTime.now().difference(fechaActivacion);
        print("Usuario ${datos["Nombre"]} ha estado activo por ${tiempoActivo.inDays} días.");
      } else {
        print("Usuario ${datos["Nombre"]} está inactivo o sin fecha de activación.");
      }
    } catch (e) {
      print("Error leyendo archivo ${archivo.path}: $e");
    }
  }

  print("==============================================================================================");
}

