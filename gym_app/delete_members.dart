import 'dart:io';

Future<void> menuDeleteUsuarios() async {
  bool salir = false;

  while (!salir) {
    print("==============================================================================================");
    print("ELIMINACIÓN DE USUARIOS");
    print("----------------------------------------------------------------------------------------------");
    print(" 1 : Eliminar usuario");
    print(" 2 : Volver al menú principal"); // 👈 opción para regresar al main
    print(" 3 : Salir del programa");
    print("==============================================================================================");

    stdout.write("Selecciona una opción: ");
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "1":
        stdout.write("Ingrese el ID del usuario a eliminar: ");
        String id = stdin.readLineSync() ?? "";
        await deleteUser(id); // 👈 aquí sí está definida más abajo
        break;

      case "2":
        salir = true; // 👈 regresa al main
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

/// Función que elimina un usuario por ID
Future<void> deleteUser(String usuarioId) async {
  try {
    File usuarioData = File("usuarios/$usuarioId.json");

    if (await usuarioData.exists()) {
      await usuarioData.delete();
      print("Perfil eliminado correctamente: $usuarioId");
    } else {
      print("Error 404: Usuario no encontrado");
    }
  } catch (e) {
    print("Error al eliminar usuario: $e");
  }
}



