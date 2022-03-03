import 'dart:convert';

import 'package:autraliano/models/destinatarios_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:

  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...

*/

class PreferenciasUsuario {
  static SharedPreferences? _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del nombre
  String get token {
    return _prefs!.getString('token') ?? '';
  }

  set token(String value) {
    _prefs!.setString('token', value);
  }

  dynamic get usuario {
    String _user = _prefs!.getString('usuario') ?? '';

    if (_user != '')
      return json.decode(_user);
    else
      return null;
  }

  set usuario(dynamic value) {
    _prefs!.setString('usuario', value);
  }

  List<DestinatarioModel> get destinatariosSession {
    String _user = _prefs!.getString('usuario') ?? '';

    if (_user != '')
      return destinatarioModelFromMap(_user);
    else
      return <DestinatarioModel>[];
  }

  set destinatariosSession(List<DestinatarioModel> value) {
    _prefs!.setString('usuario', destinatarioModelToMap(value));
  }

  void clear() {
    _prefs!.clear();
  }
}
