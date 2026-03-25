import 'dart:io';
import 'dart:convert';

Future<void> menuCumpleDescuentos() async {
  bool salir = false;

  while (!salir) {
    print("==============================================================================================");
    print("MÓDULO: DESCUENTOS DE CUMPLEAÑOS");
    print("----------------------------------------------------------------------------------------------");
    print(" 1 : Verificar cumpleaños de un usuario");
    print(" 2 : Volver al menú principal");
    print(" 3 : Salir del programa");
    print("==============================================================================================");

    stdout.write("Selecciona una opción: ");
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "1":
        stdout.write("Ingrese el ID del usuario: ");
        String id = stdin.readLineSync() ?? "";
        await verificarCumpleanos(id);
        break;

      case "2":
        salir = true;
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

Future<void> verificarCumpleanos(String usuarioId) async {
  File usuarioData = File("usuarios/$usuarioId.json");

  if (!await usuarioData.exists()) {
    print("Error 404: Usuario no encontrado.");
    return;
  }

  String contenido = await usuarioData.readAsString();
  Map<String, dynamic> datos = jsonDecode(contenido);

  String fechaNacimientoStr = datos["FechaNacimiento"];
  DateTime fechaNacimiento = DateTime.parse(fechaNacimientoStr);

  DateTime hoy = DateTime.now();

  if (hoy.month == fechaNacimiento.month && hoy.day == fechaNacimiento.day) {
    print("🎉 ¡Feliz cumpleaños ${datos["Nombre"]}! Hoy tienes derecho a un descuento especial.");
  } else {
    print("Hoy no es el cumpleaños de ${datos["Nombre"]}.");
  }
}
