// To parse this JSON data, do
//
//     final messageProvider = messageProviderFromJson(jsonString);

import 'dart:convert';

class MessageDTO {
  MessageDTO(
      {this.menId,
      this.banId,
      this.menAsunto,
      this.menMensaje,
      this.menFecha,
      this.menSendTo,
      this.menOkRecibido,
      this.menBloquearRespuesta,
      this.perNombres,
      this.perApellidos,
      this.menColor,
      this.banHoraLeido,
      this.banOkRecibido,
      this.banClaseId,
      this.banDestacado,
      this.menCategoriaId,
      this.tieneAdjuntos,
      this.catDescripcion,
      this.estNombres,
      this.estApellidos});

  int? menId;
  int? banId;
  String? menSendTo;
  String? menAsunto;
  String? menMensaje;
  String? menFecha;
  int? menOkRecibido;
  int? menBloquearRespuesta;
  String? perNombres;
  String? perApellidos;
  String? menColor;
  DateTime? banHoraLeido;
  int? banOkRecibido;
  int? banClaseId;
  int? banDestacado;
  int? menCategoriaId;
  int? tieneAdjuntos;
  String? catDescripcion;
  String? estApellidos;
  String? estNombres;

  List<MessageDTO> messageProviderFromJson(String str) => List<MessageDTO>.from(
      json.decode(str).map((x) => MessageDTO.fromJson(x)));

  String messageProviderToJson(List<MessageDTO> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  factory MessageDTO.fromJson(Map<String, dynamic> json) => MessageDTO(
        menId: json["MenId"],
        banId: json["BanId"],
        menSendTo: json["MenSendTo"],
        menAsunto: json["MenAsunto"],
        menMensaje: json["MenMensaje"],
        menFecha: json["MenFecha"],
        menOkRecibido: json["MenOkRecibido"],
        menBloquearRespuesta: json["MenBloquearRespuesta"],
        perNombres: json["PerNombres"],
        perApellidos: json["PerApellidos"],
        menColor: json["MenColor"],
        estApellidos: json["EstApellidos"],
        estNombres: json["EstNombres"],
        banHoraLeido: json["BanHoraLeido"] == null
            ? null
            : DateTime.parse(json["BanHoraLeido"]),
        banOkRecibido: json["BanOkRecibido"],
        banClaseId: json["BanClaseId"],
        banDestacado: json["BanDestacado"],
        menCategoriaId: json["MenCategoriaId"],
        tieneAdjuntos: json["TieneAdjuntos"],
        catDescripcion: json["CatDescripcion"],
      );

  Map<String, dynamic> toJson() => {
        "MenId": menId,
        "BanId": banId,
        "MenSendTo": menSendTo,
        "MenAsunto": menAsunto,
        "MenMensaje": menMensaje,
        "MenFecha": menFecha,
        "MenOkRecibido": menOkRecibido,
        "MenBloquearRespuesta": menBloquearRespuesta,
        "PerNombres": perNombres,
        "PerApellidos": perApellidos,
        "MenColor": menColor,
        "BanHoraLeido": banHoraLeido!.toIso8601String(),
        "BanOkRecibido": banOkRecibido,
        "BanClaseId": banClaseId,
        "BanDestacado": banDestacado,
        "MenCategoriaId": menCategoriaId,
        "TieneAdjuntos": tieneAdjuntos,
        "CatDescripcion": catDescripcion,
        "EstApellidos": estApellidos,
        "EstNombres": estNombres,
      };
}
