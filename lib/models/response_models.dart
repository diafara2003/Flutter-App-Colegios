// To parse this JSON data, do
//
//     final responseDto = responseDtoFromMap(jsonString);

import 'dart:convert';

ResponseDto responseDtoFromMap(String str) =>
    ResponseDto.fromMap(json.decode(str));

String responseDtoToMap(ResponseDto data) => json.encode(data.toMap());

class ResponseDto {
  ResponseDto({
    required this.codigo,
    required this.respuesta,
  });

  int codigo;
  String respuesta;

  factory ResponseDto.fromMap(Map<String, dynamic> json) => ResponseDto(
        codigo: json["codigo"],
        respuesta: json["respuesta"],
      );

  Map<String, dynamic> toMap() => {
        "codigo": codigo,
        "respuesta": respuesta,
      };
}
