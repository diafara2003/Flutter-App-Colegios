import 'dart:convert';

List<SentToModels> sentToFromMap(String str) => List<SentToModels>.from(
    json.decode(str).map((x) => SentToModels.fromJson(x)));

String senToToMap(List<SentToModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SentToModels {
  SentToModels(
      {required this.id,
      required this.tipo,
      required this.bg,
      required this.apellido,
      required this.nombre,
      required this.ocupacion});

  int id;
  int tipo;
  String bg;
  String ocupacion;
  String nombre;
  String apellido;

  factory SentToModels.fromJson(Map<String, dynamic> json) => SentToModels(
        id: json["id"],
        tipo: json["tipo"],
        bg: json["BG"],
        ocupacion: json["ocupacion"] == null ? '' : json["ocupacion"],
        nombre: json["nombre"],
        apellido: json["apellido"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "BG": bg,
        "ocupacion": ocupacion,
        "nombre": nombre,
        "apellido": apellido
      };
}
