



import 'dart:convert';
import 'dart:io';

Future<void> menuUpdateUsuarios() async {
  bool salir = false;

  while (!salir) {
    print("==============================================================================================");
    print("MÓDULO: ACTUALIZACIÓN DE USUARIOS");
    print("----------------------------------------------------------------------------------------------");
    print(" 1 : Actualizar datos de un usuario");
    print(" 2 : Volver al menú principal"); // 👈 opción para volver al main
    print(" 3 : Salir del programa");
    print("==============================================================================================");

    stdout.write("Selecciona una opción: ");
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "1":
        stdout.write("Ingrese el ID del usuario a actualizar: ");
        String id = stdin.readLineSync() ?? "";
        await updateUserData(id); // 👈 aquí entras al menú interno
        break;

      case "2":
        salir = true; // 👈 regresa al main
        break;

      case "3":
        print("Saliendo del programa... ¡Hasta luego!");
        exit(0);
        // break;

      default:
        print("Opción inválida. Intenta de nuevo.");
    }
  }
}

Future<void> updateUserData(String usuarioId) async {
  File usuarioData = File("usuarios/$usuarioId.json");

  if (!await usuarioData.exists()) {
    print("Error 404: Usuario no encontrado.");
    return;
  }

  String contenido = await usuarioData.readAsString();
  Map<String, dynamic> datosExistentes = jsonDecode(contenido);

  bool volver = false;
  while (!volver) {
    print("¿Qué deseas actualizar?");
    print(" 1 : NOMBRE DE USUARIO");
    print(" 2 : FECHA DE NACIMIENTO");
    print(" 3 : MEMBERSÍA");
    print(" 4 : ESTADO DE MEMBRESÍA (Active/Inactive)");
    print(" 5 : Volver al menú anterior"); // 👈 opción para volver al menú exterior

    stdout.write("Selecciona una opción: ");
    String? opcionStr = stdin.readLineSync();
    int opcion = int.tryParse(opcionStr ?? "") ?? 0;

    switch (opcion) {
      case 1:
        stdout.write("Nuevo nombre: ");
        datosExistentes["Nombre"] = stdin.readLineSync() ?? datosExistentes["Nombre"];
        break;

      case 2:
        stdout.write("Nueva fecha de nacimiento (YYYY-MM-DD): ");
        try {
          DateTime nuevaFecha = DateTime.parse(stdin.readLineSync()!);
          datosExistentes["FechaNacimiento"] =
              "${nuevaFecha.year}-${nuevaFecha.month}-${nuevaFecha.day}";
          final hoy = DateTime.now();
          int edad = hoy.year - nuevaFecha.year;
          if (hoy.month < nuevaFecha.month ||
              (hoy.month == nuevaFecha.month && hoy.day < nuevaFecha.day)) {
            edad--;
          }
          datosExistentes["Edad"] = edad;
        } catch (_) {
          print("Formato inválido.");
        }
        break;

      case 3:
        stdout.write("Nueva membresía (Plata/Oro/Bronze): ");
        datosExistentes["Membresia"] = stdin.readLineSync() ?? datosExistentes["Membresia"];
        break;

      case 4:
        stdout.write("Estado de membresía (true = activa, false = inactiva): ");
        String? nuevoStatusStr = stdin.readLineSync();
        bool nuevoStatus = (nuevoStatusStr?.toLowerCase() == "true");

        datosExistentes["MembresiaStatus"] = nuevoStatus;

        if (!nuevoStatus) {
          datosExistentes["FechaDesactivacion"] = DateTime.now().toIso8601String();
          print("Membresía marcada como inactiva. El perfil será eliminado en 30 días.");
        } else {
          datosExistentes["FechaDesactivacion"] = "";
          datosExistentes["FechaActivacion"] = DateTime.now().toIso8601String();
          print("Membresía reactivada. Fecha de activación reiniciada.");
        }
        break;

      case 5:
        volver = true; // 👈 regresa al menú exterior
        break;

      default:
        print("Opción no existente");
    }

    // Guardamos cambios siempre que se actualice algo
    JsonEncoder encoder = JsonEncoder.withIndent("  ");
    await usuarioData.writeAsString(encoder.convert(datosExistentes));
    print("Perfil actualizado correctamente.");
  }
}


