import 'dart:convert';

class Profesor {
  Profesor.empty() {
    this.apellido = "";
    this.celular = "";
    this.email = "";
    this.nombre = "";
    this.id = 0;
  }

  Profesor({
    required this.apellido,
    required this.celular,
    required this.email,
    required this.nombre,
    required this.id,
  });

  String apellido = "";
  String celular = "";
  String email = "";
  String nombre = "";
  int id = 0;

  List<Profesor> profesorProviderFromJson(String str) =>
      List<Profesor>.from(json.decode(str).map((x) => Profesor.fromJson(x)));

  String profesorProviderToJson(List<Profesor> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  factory Profesor.fromJson(Map<String, dynamic> json) => Profesor(
        apellido: json["apellido"] == null ? "" : json["apellido"],
        celular: json["celular"] == null ? "" : json["celular"],
        email: json["email"] == null ? "" : json["email"],
        nombre: json["nombre"] == null ? "" : json["nombre"],
        id: json["id"] == null ? 0 : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "apellido": apellido,
        "celular": celular,
        "email": email,
        "nombre": nombre,
        "AdjNombre": id
      };
}
