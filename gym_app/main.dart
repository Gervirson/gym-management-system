// TRADUCIDO

import 'dart:io';
import 'dart:convert';
import 'traducciones.dart';

// Importamos todos los módulos
import 'agregado_validación.dart';
import 'update_user.dart';
import 'delete_members.dart';
import 'visualizar_datos.dart';
import 'tiempo_activo.dart';
import 'cumple_descuentos.dart';
import 'compras.dart';

String idiomaSeleccionado = "es"; // por defecto español

Future<void> limpiarUsuariosInactivos() async {
  final dir = Directory("usuarios");

  if (!dir.existsSync()) return;

  final archivos = dir.listSync().where((f) => f.path.endsWith(".json"));

  for (var archivo in archivos) {
    try {
      String contenido = await File(archivo.path).readAsString();
      Map<String, dynamic> datos = jsonDecode(contenido);

      bool status = datos["MembresiaStatus"] ?? true;
      String fechaDesactivacionStr = (datos["FechaDesactivacion"] ?? "").toString();

      if (!status && fechaDesactivacionStr.isNotEmpty) {
        DateTime fechaDesactivacion = DateTime.parse(fechaDesactivacionStr);
        DateTime limite = fechaDesactivacion.add(Duration(days: 30));

        if (DateTime.now().isAfter(limite)) {
          await File(archivo.path).delete();
          print("Perfil eliminado automáticamente: ${datos["Nombre"]}");
        }
      }
    } catch (e) {
      print("Error revisando archivo ${archivo.path}: $e");
    }
  }
}

void main() async {
  // Limpieza automática al iniciar
  await limpiarUsuariosInactivos();



  bool salir = false;

  while (!salir) {
    print("==============================================================================================");
    print(traducciones[idiomaSeleccionado]!["welcome"]);
    print("");
    print(" 1 : ${traducciones[idiomaSeleccionado]!["menu_option_1"]}");
    print(" 2 : ${traducciones[idiomaSeleccionado]!["menu_option_2"]}");
    print(" 3 : ${traducciones[idiomaSeleccionado]!["menu_option_3"]}");
    print(" 4 : ${traducciones[idiomaSeleccionado]!["menu_option_4"]}");
    print(" 5 : ${traducciones[idiomaSeleccionado]!["menu_option_5"]}");
    print(" 6 : ${traducciones[idiomaSeleccionado]!["menu_option_6"]}");
    print(" 7 : ${traducciones[idiomaSeleccionado]!["menu_option_7"]}");
    print(" 8 : ${traducciones[idiomaSeleccionado]!["menu_option_8"]}");
    print(" 9 : ${traducciones[idiomaSeleccionado]!["menu_option_9"]}");
    print("==============================================================================================");

    stdout.write(traducciones[idiomaSeleccionado]!["select_option"]);
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "1":
        await menuAgregarUsuarios();
        break;
      case "2":
        await menuUpdateUsuarios();
        break;
      case "3":
        await menuDeleteUsuarios();
        break;
      case "4":
        await menuVisualizarUsuarios();
        break;
      case "5":
        await menuTiempoActivo();
        break;
      case "6":
        await menuCumpleDescuentos();
        break;
      case "7":
        await menuCompras();
        break;
      case "8":
        stdout.write("Seleccione idioma (es/en/fr): ");
        String? nuevoIdioma = stdin.readLineSync();
        if (nuevoIdioma != null && traducciones.containsKey(nuevoIdioma)) {
          idiomaSeleccionado = nuevoIdioma;
          print("Idioma cambiado a $nuevoIdioma.");
        } else {
          print("Idioma no válido.");
        }
        break;
      case "9":
        print("Cerrando sistema... ¡Hasta luego!");
        salir = true;
        break;
      default:
        print("Opción inválida. Intenta de nuevo.");
    }
  }
}
