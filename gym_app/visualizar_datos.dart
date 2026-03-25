import 'dart:io';
import 'dart:convert';

Future<void> menuVisualizarUsuarios() async {
  bool salir = false;

  while (!salir) {
    print("==============================================================================================");
    print(" VISUALIZACIÓN DE USUARIOS");
    print("----------------------------------------------------------------------------------------------");
    print(" 1 : Ver datos de un usuario");
    print(" 2 : Listar / Filtrar usuarios");
    print(" 3 : Volver al menú principal");
    print(" 4 : Salir del programa");
    print("==============================================================================================");

    stdout.write("Selecciona una opción: ");
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "1":
        stdout.write("Ingrese el ID del usuario: ");
        String id = stdin.readLineSync() ?? "";
        await verUsuario(id);
        break;

      case "2":
        await subMenuUsuarios();
        break;

      case "3":
        salir = true;
        break;

      case "4":
        print("Saliendo del programa... ¡Hasta luego!");
        exit(0);

      default:
        print("Opción inválida. Intenta de nuevo.");
    }
  }
}

Future<void> subMenuUsuarios() async {
  bool volver = false;

  while (!volver) {
    print("==============================================================================================");
    print("SUBMENÚ: LISTAR / FILTRAR USUARIOS");
    print("----------------------------------------------------------------------------------------------");
    print(" 2.1 : Listar todos los usuarios");
    print(" 2.2 : Filtrar por fecha de nacimiento (mes)");
    print(" 2.3 : Filtrar por membresía");
    print(" 2.4 : Filtrar por edad");
    print(" 2.5 : Filtrar por estado activo / inactivo");
    print(" 3   : Volver al menú anterior");
    print(" 4   : Salir del programa");
    print("==============================================================================================");

    stdout.write("Selecciona una opción: ");
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "2.1":
        await listarUsuarios();
        break;

      case "2.2":
        stdout.write("Ingrese el mes de nacimiento (1-12): ");
        int mes = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
        await filtrarPorFechaNacimiento(mes);
        break;

      case "2.3":
        stdout.write("Ingrese el tipo de membresía (Bronze/Gold/Platinum): ");
        String tipo = stdin.readLineSync() ?? "";
        await filtrarUsuarios(membresia: tipo);
        break;

      case "2.4":
        stdout.write("Ingrese la edad mínima: ");
        int edadMin = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
        stdout.write("Ingrese la edad máxima: ");
        int edadMax = int.tryParse(stdin.readLineSync() ?? "") ?? 999;
        await filtrarPorEdad(edadMin, edadMax);
        break;

      case "2.5":
        stdout.write("¿Quieres ver usuarios activos? (s/n): ");
        String respuesta = stdin.readLineSync() ?? "";
        bool estado = respuesta.toLowerCase() == "s";
        await filtrarUsuarios(estadoMembresia: estado);
        break;

      case "3":
        volver = true;
        break;

      case "4":
        print("Saliendo del programa... ¡Hasta luego!");
        exit(0);

      default:
        print("Opción inválida. Intenta de nuevo.");
    }
  }
}

// ================= FUNCIONES DE APOYO =================

Future<void> verUsuario(String usuarioId) async {
  File usuarioData = File("usuarios/$usuarioId.json");

  if (!await usuarioData.exists()) {
    print("Error 404: Usuario no encontrado.");
    return;
  }

  String contenido = await usuarioData.readAsString();
  Map<String, dynamic> datos = jsonDecode(contenido);

  print("==============================================================================================");
  print("DATOS DEL USUARIO: ${datos["Nombre"]}");
  print("----------------------------------------------------------------------------------------------");
  print("ID: ${datos["ID"]}");
  print("Nombre: ${datos["Nombre"]}");
  print("Fecha de Nacimiento: ${datos["FechaNacimiento"]}");
  print("Edad: ${datos["Edad"]}");
  print("Membresía: ${datos["Membresia"]}");
  print("Estado Membresía: ${datos["MembresiaStatus"] ? "Activa" : "Inactiva"}");
  print("==============================================================================================");
}

Future<void> listarUsuarios() async {
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
  print("LISTA DE USUARIOS REGISTRADOS");
  print("----------------------------------------------------------------------------------------------");

  for (var archivo in archivos) {
    try {
      String contenido = await File(archivo.path).readAsString();
      Map<String, dynamic> datos = jsonDecode(contenido);

      print("ID: ${datos["ID"]}");
      print("Nombre: ${datos["Nombre"]}");
      print("Fecha de Nacimiento: ${datos["FechaNacimiento"]}");
      print("Edad: ${datos["Edad"]}");
      print("Membresía: ${datos["Membresia"]}");
      print("Estado Membresía: ${datos["MembresiaStatus"] ? "Activa" : "Inactiva"}");
      print("");
    } catch (e) {
      print("Error leyendo archivo ${archivo.path}: $e");
    }
  }

  print("==============================================================================================");
}

Future<void> filtrarUsuarios({String? membresia, bool? estadoMembresia}) async {
  final dir = Directory("usuarios");
  if (!dir.existsSync()) return;

  final archivos = dir.listSync().where((f) => f.path.endsWith(".json"));

  for (var archivo in archivos) {
    String contenido = await File(archivo.path).readAsString();
    Map<String, dynamic> datos = jsonDecode(contenido);

    bool coincide = true;
    if (membresia != null && datos["Membresia"] != membresia) coincide = false;
    if (estadoMembresia != null && datos["MembresiaStatus"] != estadoMembresia) coincide = false;

    if (coincide) {
      print("ID: ${datos["ID"]} | Nombre: ${datos["Nombre"]} | Membresía: ${datos["Membresia"]}");
    }
  }
}

Future<void> filtrarPorFechaNacimiento(int mes) async {
  final dir = Directory("usuarios");
  if (!dir.existsSync()) return;

  final archivos = dir.listSync().where((f) => f.path.endsWith(".json"));

  for (var archivo in archivos) {
    String contenido = await File(archivo.path).readAsString();
    Map<String, dynamic> datos = jsonDecode(contenido);

    // FechaNacimiento guardada como string "YYYY-MM-DD"
    DateTime fecha = DateTime.parse(datos["FechaNacimiento"]);
    if (fecha.month == mes) {
      print("ID: ${datos["ID"]} | Nombre: ${datos["Nombre"]} | Nacimiento: ${datos["FechaNacimiento"]}");
    }
  }
}

Future<void> filtrarPorEdad(int edadMin, int edadMax) async {
  final dir = Directory("usuarios");
  if (!dir.existsSync()) return;

  final archivos = dir.listSync().where((f) => f.path.endsWith(".json"));

  for (var archivo in archivos) {
    String contenido = await File(archivo.path).readAsString();
    Map<String, dynamic> datos = jsonDecode(contenido);

    int edad = datos["Edad"];
    if (edad >= edadMin && edad <= edadMax) {
      print("ID: ${datos["ID"]} | Nombre: ${datos["Nombre"]} | Edad: $edad");
    }
  }
}
