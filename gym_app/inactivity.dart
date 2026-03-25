import 'dart:io';
import 'dart:convert';

Future<void> limpiarUsuariosInactivos() async {
  final dir = Directory("usuarios");

  if (!dir.existsSync()) return;

  final archivos = dir.listSync().where((f) => f.path.endsWith(".json"));

  for (var archivo in archivos) {
    try {
      String contenido = await File(archivo.path).readAsString();
      Map<String, dynamic> datos = jsonDecode(contenido);

      bool status = datos["MembresiaStatus"] ?? true;
      String fechaDesactivacionStr = datos["FechaDesactivacion"] ?? "";

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
