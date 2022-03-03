// To parse this JSON data, do
//
//     final newMessage = newMessageFromJson(jsonString);

import 'dart:convert';

import 'destinatarios_message_modeles.dart';

NewMessage newMessageFromJson(String str) =>
    NewMessage.fromJson(json.decode(str));

String newMessageToJson(NewMessage data) => json.encode(data.toJson());

class NewMessajeDto {
  NewMessajeDto({
    this.menId,
    this.menEmpId,
    this.menUsuario,
    this.menClase,
    this.menTipoMsn,
    this.menAsunto,
    this.menMensaje,
    this.menReplicaIdMsn,
    this.menOkRecibido,
    this.menSendTo,
    this.menBloquearRespuesta,
    this.menCategoriaId,
    this.menEstado,
    this.menFechaMaxima,
  });

  int? menId;
  int? menEmpId;
  int? menUsuario;
  int? menClase;
  String? menTipoMsn;
  String? menAsunto;
  String? menMensaje;
  int? menReplicaIdMsn;
  int? menOkRecibido;
  String? menSendTo;
  int? menBloquearRespuesta;
  int? menCategoriaId;
  int? menEstado;
  dynamic menFechaMaxima;

  factory NewMessajeDto.fromJson(Map<String, dynamic> json) => NewMessajeDto(
        menId: json["MenId"],
        menEmpId: json["MenEmpId"],
        menUsuario: json["MenUsuario"],
        menClase: json["MenClase"],
        menTipoMsn: json["MenTipoMsn"],
        menAsunto: json["MenAsunto"],
        menMensaje: json["MenMensaje"],
        menReplicaIdMsn: json["MenReplicaIdMsn"],
        menOkRecibido: json["MenOkRecibido"],
        menSendTo: json["MenSendTo"],
        menBloquearRespuesta: json["MenBloquearRespuesta"],
        menCategoriaId: json["MenCategoriaId"],
        menEstado: json["MenEstado"],
        menFechaMaxima: json["MenFechaMaxima"],
      );

  Map<String, dynamic> toJson() => {
        "MenId": menId,
        "MenEmpId": menEmpId,
        "MenUsuario": menUsuario,
        "MenClase": menClase,
        "MenTipoMsn": menTipoMsn,
        "MenAsunto": menAsunto,
        "MenMensaje": menMensaje,
        "MenReplicaIdMsn": menReplicaIdMsn,
        "MenOkRecibido": menOkRecibido,
        "MenSendTo": menSendTo,
        "MenBloquearRespuesta": menBloquearRespuesta,
        "MenCategoriaId": menCategoriaId,
        "MenEstado": menEstado,
        "MenFechaMaxima": menFechaMaxima,
      };
}

class NewMessage {
  NewMessage({
    required this.destinatarios,
    this.mensaje,
    required this.adjuntos,
  });

  List<DestinatariosMessageModels> destinatarios;
  NewMessajeDto? mensaje;
  List<int> adjuntos;

  factory NewMessage.fromJson(Map<String, dynamic> json) => NewMessage(
        destinatarios: List<DestinatariosMessageModels>.from(
            json["destinatarios"]
                .map((x) => DestinatariosMessageModels.fromJson(x))),
        mensaje: NewMessajeDto.fromJson(json["mensaje"]),
        adjuntos: List<int>.from(json["adjuntos"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "destinatarios":
            List<dynamic>.from(destinatarios.map((x) => x.toJson())),
        "mensaje": mensaje!.toJson(),
        "adjuntos": List<dynamic>.from(adjuntos.map((x) => x)),
      };
}
