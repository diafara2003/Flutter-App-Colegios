// To parse this JSON data, do
//
//     final acudientesModel = acudientesModelFromMap(jsonString);

import 'dart:convert';

List<AcudientesModel> acudientesModelFromMap(String str) =>
    List<AcudientesModel>.from(
        json.decode(str).map((x) => AcudientesModel.fromMap(x)));

String acudientesModelToMap(List<AcudientesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class AcudientesModel {
  AcudientesModel.empty() {
    this.perIdA1 = 0;
    this.tipoA1 = '';
    this.perNombresA1 = '';
    this.perApellidosA1 = '';
    this.color = '';
    this.estNombres = '';
    this.estApellidos = '';
    this.estId = 0;

    this.perIdA2 = 0;
    this.tipoA2 = '';
    this.perNombresA2 = '';
    this.perApellidosA2 = '';
  }

  AcudientesModel({
    required this.perIdA1,
    required this.tipoA1,
    required this.perNombresA1,
    required this.perApellidosA1,
    this.perIdA2,
    this.tipoA2,
    this.perNombresA2,
    this.perApellidosA2,
    required this.color,
    required this.estNombres,
    required this.estApellidos,
    required this.estId,
  });

  int perIdA1 = 0;
  String tipoA1 = "";
  String perNombresA1 = "";
  String perApellidosA1 = "";
  int? perIdA2 = 0;
  String? tipoA2 = '';
  String? perNombresA2 = '';
  String? perApellidosA2 = '';
  String color = '';
  String estNombres = '';
  String estApellidos = '';
  int estId = 0;

  factory AcudientesModel.fromMap(Map<String, dynamic> json) => AcudientesModel(
        perIdA1: json["PerIdA1"] == null ? null : json["PerIdA1"],
        tipoA1: json["TipoA1"] == null ? null : json["TipoA1"],
        perNombresA1:
            json["PerNombresA1"] == null ? null : json["PerNombresA1"],
        perApellidosA1:
            json["PerApellidosA1"] == null ? null : json["PerApellidosA1"],
        perIdA2: json["PerIdA2"] == null ? null : json["PerIdA2"],
        tipoA2: json["TipoA2"] == null ? null : json["TipoA2"],
        perNombresA2:
            json["PerNombresA2"] == null ? null : json["PerNombresA2"],
        perApellidosA2:
            json["PerApellidosA2"] == null ? null : json["PerApellidosA2"],
        color: json["color"] == null ? null : json["color"],
        estNombres: json["EstNombres"] == null ? null : json["EstNombres"],
        estApellidos:
            json["EstApellidos"] == null ? null : json["EstApellidos"],
        estId: json["EstId"] == null ? null : json["EstId"],
      );

  Map<String, dynamic> toMap() => {
        "PerIdA1": perIdA1,
        "TipoA1": tipoA1,
        "PerNombresA1": perNombresA1,
        "PerApellidosA1": perApellidosA1,
        "PerIdA2": perIdA2 == null ? 0 : perIdA2,
        "TipoA2": tipoA2 == null ? '' : tipoA2,
        "PerNombresA2": perNombresA2 == null ? '' : perNombresA2,
        "PerApellidosA2": perApellidosA2 == null ? '' : perApellidosA2,
        "color": color,
        "EstNombres": estNombres,
        "EstApellidos": estApellidos,
        "EstId": estId,
      };
}
