import 'dart:io';
//import 'dart:convert';
import 'traducciones.dart';
import 'main.dart';

void main(List<String> args) {
    stdout.write("Seleccione idioma (es/en/fr): ");
  String? idioma = stdin.readLineSync();
  if (idioma != null && traducciones.containsKey(idioma)) {
    idiomaSeleccionado = idioma;
  }  
}