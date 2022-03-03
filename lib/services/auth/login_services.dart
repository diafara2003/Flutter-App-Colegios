// To parse this JSON data, do
//
//     final loginProvider = loginProviderFromJson(jsonString);

import 'dart:convert';

import 'package:autraliano/models/person.dart';
import 'package:autraliano/providers/API/fetch_provider.dart';
import 'package:autraliano/providers/Session/preferencias_provider.dart';

class LoginProvider {
  LoginProvider({
    this.usuario,
    this.token,
  });

  Usuario? usuario;
  String? token;

  LoginProvider _getUserSession(Map<String, dynamic> json) => LoginProvider(
        usuario: Usuario.fromJson(json["usuario"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "usuario": usuario!.toJson(),
        "token": token,
      };

  Future<void> registarToken(String token) async {
    Providers obj = new Providers();

    PreferenciasUsuario _prefe = new PreferenciasUsuario();

    try {
      final Usuario _user = Usuario.fromJson(_prefe.usuario);

      await obj.postAPI('login/tokenFCM',
          {"LgId": 0, "UsuarioId": _user.perId, "TokenFCM": token}, 0);

      // ResponseDto.fromMap(_result);
    } catch (e) {
      return null;
    }
  }

  Future<void> cambiarClave(String newClave) async {
    Providers obj = new Providers();

    PreferenciasUsuario _prefe = new PreferenciasUsuario();

    Usuario _user = Usuario.fromJson(_prefe.usuario);

    _user.perClave = newClave;

    await obj.postAPI('Personas', _user, 0);

    String _logged = json.encode(_user);
    _prefe.usuario = _logged;
  }

  Future<Usuario?> validationUser(String? email, String? password) async {
    Providers obj = new Providers();

    PreferenciasUsuario _prefe = new PreferenciasUsuario();

    try {
      Map<String, dynamic> _data = await obj.postAPI(
          'login/validacion', {"username": email, "password": password}, 1);

      final LoginProvider _user = _getUserSession(_data);

      String _logged = json.encode(_user.usuario);

      _prefe.token = _user.token!;
      _prefe.usuario = _logged;

      return _user.usuario;
    } catch (e) {
      return null;
    }
  }
}
