import 'dart:convert';

List<DestinatariosMessageModels> destinatarioFromMap(String str) =>
    List<DestinatariosMessageModels>.from(
        json.decode(str).map((x) => DestinatariosMessageModels.fromJson(x)));

String destinatarioToMap(List<DestinatariosMessageModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DestinatariosMessageModels {
  DestinatariosMessageModels(
      {required this.id, required this.tipo, required this.estudiante});

  int id;
  int tipo;
  int estudiante;

  factory DestinatariosMessageModels.fromJson(Map<String, dynamic> json) =>
      DestinatariosMessageModels(
          id: json["id"], tipo: json["tipo"], estudiante: json["estudiante"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "estudiante": estudiante,
      };
}
