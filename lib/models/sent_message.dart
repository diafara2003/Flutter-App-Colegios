// To parse this JSON data, do
//
//     final enviarMensajeDto = enviarMensajeDtoFromMap(jsonString);

import 'dart:convert';

import 'destinatarios_message_modeles.dart';
import 'reply_message.dart';

EnviarMensajeDto enviarMensajeDtoFromMap(String str) =>
    EnviarMensajeDto.fromMap(json.decode(str));

String enviarMensajeDtoToMap(EnviarMensajeDto data) =>
    json.encode(data.toMap());

class EnviarMensajeDto {
  EnviarMensajeDto({
    this.destinatarios,
    this.mensaje,
    this.adjuntos,
  });

  List<DestinatariosMessageModels>? destinatarios = [];
  ReplicaMsnDto? mensaje;
  List<int>? adjuntos = [];

  factory EnviarMensajeDto.fromMap(Map<String, dynamic> json) =>
      EnviarMensajeDto(
        destinatarios: List<DestinatariosMessageModels>.from(
            json["destinatarios"]
                .map((x) => DestinatariosMessageModels.fromJson(x))),
        mensaje: ReplicaMsnDto.fromMap(json["mensaje"]),
        adjuntos: List<int>.from(json["adjuntos"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "destinatarios":
            List<DestinatariosMessageModels>.from(destinatarios!.map((x) => x)),
        "mensaje": mensaje!.toMap(),
        "adjuntos": List<dynamic>.from(adjuntos!.map((x) => x)),
      };
}
