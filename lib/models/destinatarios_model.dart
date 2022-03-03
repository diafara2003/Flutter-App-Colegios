// To parse this JSON data, do
//
//     final destinatarioModel = destinatarioModelFromMap(jsonString);

import 'dart:convert';

List<DestinatarioModel> destinatarioModelFromMap(String str) =>
    List<DestinatarioModel>.from(
        json.decode(str).map((x) => DestinatarioModel.fromMap(x)));

String destinatarioModelToMap(List<DestinatarioModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GruposDestinatarioModel extends DestinatarioModel {
  int idGrupo = 0;

  GruposDestinatarioModel.empty() : super.empty();
}

class DestinatarioModel {
  DestinatarioModel.empty() {
    this.curDescripcion = "";
    this.grEnColorBurbuja = "";
    this.grEnColorObs = "";
    this.grEnColorRgb = "";
    this.graDescripcion = "";
    this.idEst = 0;
    this.perApellidos = "";
    this.perId = 0;
    this.perNombres = "";
    this.tipo = 0;
  }
  DestinatarioModel({
    required this.perId,
    required this.perNombres,
    required this.perApellidos,
    required this.graDescripcion,
    required this.curDescripcion,
    required this.tipo,
    required this.grEnColorRgb,
    required this.grEnColorObs,
    required this.grEnColorBurbuja,
    required this.idEst,
  });

  int perId = 0;
  String perNombres = "";
  String perApellidos = "";
  String graDescripcion = "";
  String curDescripcion = "";
  int tipo = 0;
  String grEnColorRgb = "";
  String grEnColorObs = "";
  String grEnColorBurbuja = "";
  int idEst = 0;
  int idGrupo = 0;

  factory DestinatarioModel.fromMap(Map<String, dynamic> json) =>
      DestinatarioModel(
        perId: json["PerId"] == null ? 0 : json["PerId"],
        perNombres: json["PerNombres"] == null ? '' : json["PerNombres"],
        perApellidos: json["PerApellidos"] == null ? '' : json["PerApellidos"],
        graDescripcion:
            json["GraDescripcion"] == null ? '' : json["GraDescripcion"],
        curDescripcion:
            json["CurDescripcion"] == null ? '' : json["CurDescripcion"],
        tipo: json["tipo"] == null ? null : json["tipo"],
        grEnColorRgb: json["GrEnColorRGB"] == null ? '' : json["GrEnColorRGB"],
        grEnColorObs: json["GrEnColorObs"] == null ? '' : json["GrEnColorObs"],
        grEnColorBurbuja:
            json["GrEnColorBurbuja"] == null ? '' : json["GrEnColorBurbuja"],
        idEst: json["idEst"] == null ? '' : json["idEst"],
      );

  Map<String, dynamic> toMap() => {
        "PerId": perId,
        "PerNombres": perNombres,
        "PerApellidos": perApellidos,
        "GraDescripcion": graDescripcion,
        "CurDescripcion": curDescripcion,
        "tipo": tipo,
        "GrEnColorRGB": grEnColorRgb,
        "GrEnColorObs": grEnColorObs,
        "GrEnColorBurbuja": grEnColorBurbuja,
        "idEst": idEst,
      };
}
