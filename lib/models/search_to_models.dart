// To parse this JSON data, do
//
//     final searchTo = searchToFromJson(jsonString);

import 'dart:convert';

class DestinatariosModel {
  int perId;
  int tipo;
  String nombre;
  String apellido;

  DestinatariosModel(
      {required this.perId,
      required this.tipo,
      required this.apellido,
      required this.nombre});
}

List<SearchTo> searchToFromJson(String str) =>
    List<SearchTo>.from(json.decode(str).map((x) => SearchTo.fromJson(x)));

String searchToToJson(List<SearchTo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchTo {
  int perId;
  String perNombres;
  String perApellidos;
  String graDescripcion;
  String curDescripcion;
  int tipo;
  String grEnColorRgb;
  String grEnColorObs;
  String grEnColorBurbuja;
  bool selected;

  SearchTo(
      {required this.perId,
      required this.perNombres,
      required this.perApellidos,
      required this.graDescripcion,
      required this.curDescripcion,
      required this.tipo,
      required this.grEnColorRgb,
      required this.grEnColorObs,
      required this.grEnColorBurbuja,
      required this.selected});

  factory SearchTo.fromJson(Map<String, dynamic> json) => SearchTo(
      perId: json["PerId"],
      perNombres: json["PerNombres"],
      perApellidos: json["PerApellidos"],
      graDescripcion: json["GraDescripcion"],
      curDescripcion: json["CurDescripcion"],
      tipo: json["tipo"],
      grEnColorRgb: json["GrEnColorRGB"],
      grEnColorObs: json["GrEnColorObs"],
      grEnColorBurbuja: json["GrEnColorBurbuja"],
      selected: false);

  Map<String, dynamic> toJson() => {
        "PerId": perId,
        "PerNombres": perNombres,
        "PerApellidos": perApellidos,
        "GraDescripcion": graDescripcion,
        "CurDescripcion": curDescripcion,
        "tipo": tipo,
        "GrEnColorRGB": grEnColorRgb,
        "GrEnColorObs": grEnColorObs,
        "GrEnColorBurbuja": grEnColorBurbuja,
      };
}
