// To parse this JSON data, do
//
//     final replicaMsnDto = replicaMsnDtoFromMap(jsonString);

import 'dart:convert';

ReplicaMsnDto replicaMsnDtoFromMap(String str) =>
    ReplicaMsnDto.fromMap(json.decode(str));

String replicaMsnDtoToMap(ReplicaMsnDto data) => json.encode(data.toMap());

class ReplicaMsnDto {
  ReplicaMsnDto({
    required this.menId,
    this.menEmpId,
    required this.menUsuario,
    required this.menClase,
    required this.menTipoMsn,
    required this.menAsunto,
    required this.menMensaje,
    required this.menReplicaIdMsn,
    required this.menOkRecibido,
    required this.menSendTo,
    required this.menBloquearRespuesta,
    required this.menCategoriaId,
  });

  int menId;
  int? menEmpId;
  int menUsuario;
  int menClase;
  String menTipoMsn;
  String menAsunto;
  String menMensaje;
  int menReplicaIdMsn;
  int menOkRecibido;
  String menSendTo;
  int menBloquearRespuesta;
  int menCategoriaId;

  factory ReplicaMsnDto.fromMap(Map<String, dynamic> json) => ReplicaMsnDto(
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
      );

  Map<String, dynamic> toMap() => {
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
      };
}
