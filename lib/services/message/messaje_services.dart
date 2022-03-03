// To parse this JSON data, do
//
//     final messageProvider = messageProviderFromJson(jsonString);

import 'package:autraliano/models/acudientes_models.dart';
import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/models/message.dart';
import 'package:autraliano/models/message_details_models.dart';
import 'package:autraliano/models/new_messge.dart';
import 'package:autraliano/models/person.dart';
import 'package:autraliano/models/response_models.dart';
import 'package:autraliano/models/sent_message.dart';
import 'package:autraliano/providers/API/fetch_provider.dart';
import 'package:autraliano/providers/Session/preferencias_provider.dart';

class MessageServices {
  Future<List<MessageDTO>> getMessages(int tipo, int usuario) async {
    Providers obj = new Providers();

    try {
      //   print('JAU SERVICES');
      String json = await obj.getAPI(
          'BandejaEntrada/mensajes/usuario?usuario=$usuario&tipo=$tipo');

      return new MessageDTO().messageProviderFromJson(json);
    } catch (e) {
      print(e);

      return <MessageDTO>[];
    }
  }

  //BandejaEntrada/mensajes/usuario?usuario=85&tipo=0

  Future nuevoMensaje(NewMessage modelo) async {
    Providers obj = new Providers();
    PreferenciasUsuario _user = new PreferenciasUsuario();

    try {
      modelo.mensaje!.menUsuario = Usuario.fromJson(_user.usuario).perId!;

      await obj.postAPI('Mensajes', modelo.toJson(), 0);

      return "";
    } catch (e) {
      print(e);

      return null;
    }
  }

  Future<ResponseDto?> enviarMensaje(EnviarMensajeDto modelo) async {
    Providers obj = new Providers();

    try {
      Map<String, dynamic> _result =
          await obj.postAPI('Mensajes', modelo.toMap(), 0);

      ResponseDto _response = ResponseDto.fromMap(_result);

      return _response;
    } catch (e) {
      print(e);

      return null;
    }
  }

  Future<List<MessageDetatails>> getChat(int? id, int? idBandeja) async {
    Providers obj = new Providers();

    try {
      String json = await obj.getAPI('Mensajes?id=$id&bandeja=$idBandeja');

      print(json);
      List<MessageDetatails> _msn =
          new MessageDetatails().messageDetatailsFromMap(json);

      obj.getAPI('Mensajes/marcarleido?id=$id&bandeja=$idBandeja');
      return _msn;
    } catch (e) {
      print(e);

      return <MessageDetatails>[];
    }
  }

  Future<List<DestinatarioModel>> getDestinatarios(int usuario) async {
    Providers obj = new Providers();
    try {
      String json = await obj
          .getAPI('Mensajes/destinatarios?idusuario=$usuario&filter= ');

      return destinatarioModelFromMap(json);
    } catch (e) {
      return <DestinatarioModel>[];
    }
  }

  Future<List<AcudientesModel>> getInfoGrupo(int idgrupo) async {
    Providers obj = new Providers();
    try {
      String json = await obj.getAPI('Mensajes/info/grupo?idgrupo=$idgrupo');

      return acudientesModelFromMap(json);
    } catch (e) {
      return <AcudientesModel>[];
    }
  }
}
