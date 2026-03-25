import 'dart:convert';
import 'dart:io';
import 'gymnasio.dart';

Future<void> menuAgregarUsuarios() async {
  bool salir = false;

  while (!salir) {
    print("==============================================================================================");
    print(" CREACIÓN DE USUARIOS");
    print("----------------------------------------------------------------------------------------------");
    print(" 1 : Crear nuevo usuario");
    print(" 2 : Volver al menú principal");
    print(" 3 : Salir del programa");
    print("==============================================================================================");

    stdout.write("Selecciona una opción: ");
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "1":
        await agregarValidarDatos();
        // 👈 IMPORTANTE: después de crear o fallar, seguimos en este menú
        break;

      case "2":
        // Volvemos al main saliendo del bucle
        salir = true;
        break;

      case "3":
        print("Saliendo del programa... ¡Hasta luego!");
        exit(0); // termina el programa completo
        //break;

      default:
        print("Opción inválida. Intenta de nuevo.");
    }
  }
}

Future<void> agregarValidarDatos() async {
  try {
    stdout.write("¿Quieres crear un perfil de miembro? (Yes/No): ");
    String? respuesta = stdin.readLineSync();

    if (respuesta?.toLowerCase() == "yes") {
      stdout.write("Ingresa tu Nombre: ");
      String nombre = stdin.readLineSync() ?? "";

      stdout.write("Fecha de Nacimiento (YYYY-MM-DD): ");
      DateTime fechaNacimiento;
      try {
        fechaNacimiento = DateTime.parse(stdin.readLineSync()!);
      } catch (_) {
        print("Formato inválido. Ejemplo correcto: 2000-05-12");
        return; // 👈 vuelve al menú sin salir al main
      }

      stdout.write("Ingrese la Membresía que desea (Plata/Oro/Bronze): ");
      String membresia = stdin.readLineSync() ?? "Bronze";

      Gymnasio usuario = Gymnasio(
        nombre: nombre,
        fechaNacimiento: fechaNacimiento,
        membresia: membresia,
        membresiaStatus: true,
      );

      if (usuario.edad < 15) {
        print("Lo sentimos, eres demasiado joven para registrarte.");
        return; // 👈 vuelve al menú sin salir al main
      }

      Map<String, dynamic> usuarioMap = usuario.toMap();
      JsonEncoder encoder = JsonEncoder.withIndent("  ");
      String contenidoJson = encoder.convert(usuarioMap);

      Directory dir = Directory("usuarios");
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      File usuarioData = File("${dir.path}/${usuario.id}.json");
      await usuarioData.writeAsString(contenidoJson);

      print("Perfil de ${usuario.nombre} creado satisfactoriamente con ID: ${usuario.id}");
    } else {
      print("Puedes seguir usando nuestro centro sin ser miembro.");
    }
  } catch (e) {
    print("Error al crear perfil: $e");
  }
}


