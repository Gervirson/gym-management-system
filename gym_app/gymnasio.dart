import 'dart:math';

class Gymnasio {
  final String id;
  String nombre;
  DateTime fechaNacimiento;
  int edad;
  String membresia;
  bool membresiaStatus;
  DateTime? fechaDesactivacion;
  DateTime fechaActivacion;

  Gymnasio({
    required this.nombre,
    required this.fechaNacimiento,
    required this.membresia,
    required this.membresiaStatus,
    this.fechaDesactivacion,
  })  : id = _generarId(),
        edad = _calcularEdad(fechaNacimiento),
        fechaActivacion = DateTime.now();

  static int _calcularEdad(DateTime fechaNacimiento) {
    final hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento.year;
    if (hoy.month < fechaNacimiento.month ||
        (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  static String _generarId() {
    final random = Random();
    return "USR-${random.nextInt(999999)}";
  }

  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "Nombre": nombre,
      "FechaNacimiento": "${fechaNacimiento.year}-${fechaNacimiento.month}-${fechaNacimiento.day}",
      "Edad": edad,
      "Membresia": membresia,
      "MembresiaStatus": membresiaStatus,
      "FechaDesactivacion": fechaDesactivacion?.toIso8601String() ?? "",
      "FechaActivacion": fechaActivacion.toIso8601String(),
    };
  }
}
