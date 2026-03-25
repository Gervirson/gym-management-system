import 'dart:io';
import 'dart:convert';

Future<void> menuCompras() async {
  bool salir = false;

  while (!salir) {
    print("==============================================================================================");
    print("MÓDULO: REGISTRO DE COMPRAS");
    print("----------------------------------------------------------------------------------------------");
    print(" 1 : Registrar nueva compra");
    print(" 2 : Ver compras de un usuario");
    print(" 3 : Volver al menú principal");
    print(" 4 : Salir del programa");
    print("==============================================================================================");

    stdout.write("Selecciona una opción: ");
    String? opcion = stdin.readLineSync();

    switch (opcion) {
      case "1":
        await registrarCompra();
        break;

      case "2":
        stdout.write("Ingrese el ID del usuario: ");
        String id = stdin.readLineSync() ?? "";
        await verComprasUsuario(id);
        break;

      case "3":
        salir = true;
        break;

      case "4":
        print("Saliendo del programa... ¡Hasta luego!");
        exit(0);
        // break;

      default:
        print("Opción inválida. Intenta de nuevo.");
    }
  }
}

Future<void> registrarCompra() async {
  stdout.write("Ingrese el ID del usuario: ");
  String usuarioId = stdin.readLineSync() ?? "";

  List<Map<String, dynamic>> items = [];
  double total = 0.0;

  bool agregarMas = true;
  while (agregarMas) {
    stdout.write("Nombre del item: ");
    String item = stdin.readLineSync() ?? "";

    stdout.write("Precio del item: ");
    double precio = double.tryParse(stdin.readLineSync() ?? "0") ?? 0;

    items.add({"item": item, "precio": precio});
    total += precio;

    stdout.write("¿Agregar otro item? (yes/no): ");
    String? respuesta = stdin.readLineSync();
    if (respuesta?.toLowerCase() != "yes") {
      agregarMas = false;
    }
  }

  Map<String, dynamic> recibo = {
    "UsuarioID": usuarioId,
    "Items": items,
    "PrecioTotal": total,
    "FechaHora": DateTime.now().toIso8601String(),
  };

  Directory dir = Directory("compras");
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  File reciboFile = File("${dir.path}/${usuarioId}_${DateTime.now().millisecondsSinceEpoch}.json");
  await reciboFile.writeAsString(JsonEncoder.withIndent("  ").convert(recibo));

  print("Compra registrada correctamente. Total: \$${total}");
}

Future<void> verComprasUsuario(String usuarioId) async {
  final dir = Directory("compras");

  if (!dir.existsSync()) {
    print("No hay compras registradas.");
    return;
  }

  final archivos = dir.listSync().where((f) => f.path.contains(usuarioId));

  if (archivos.isEmpty) {
    print("No hay compras registradas para el usuario $usuarioId.");
    return;
  }

  print("==============================================================================================");
  print("COMPRAS DEL USUARIO $usuarioId");
  print("----------------------------------------------------------------------------------------------");

  for (var archivo in archivos) {
    String contenido = await File(archivo.path).readAsString();
    Map<String, dynamic> recibo = jsonDecode(contenido);

    print("Fecha: ${recibo["FechaHora"]}");
    print("Items:");
    for (var item in recibo["Items"]) {
      print(" - ${item["item"]}: \$${item["precio"]}");
    }
    print("Total: \$${recibo["PrecioTotal"]}");
    print("----------------------------------------------------------------------------------------------");
  }
}
