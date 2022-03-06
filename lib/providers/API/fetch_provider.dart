import 'dart:convert';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe

import 'package:autraliano/models/adjunto_models.dart';
import 'package:autraliano/models/person.dart';
import 'package:autraliano/providers/Session/preferencias_provider.dart';
import 'package:autraliano/services/auth/login_services.dart';
import "package:http/http.dart" as http;

import 'package:http/http.dart';

class Providers {
  static final String base = 'https://www.comunicatecolegios.com/api/';

  String _getToken() {
    PreferenciasUsuario _prefe = new PreferenciasUsuario();

    return _prefe.token;
  }

  Future<bool> verificarSession() async {
    dynamic _userLogged = new PreferenciasUsuario().usuario;

    if (_userLogged == null) return false;

    Usuario _session = Usuario.fromJson(_userLogged);
    Usuario? _user = await new LoginProvider()
        .validationUser(_session.perUsuario, _session.perClave);

    if (_user != null)
      return true;
    else {
      new PreferenciasUsuario().clear();
      return false;
    }
  }

  final Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    "Accept": "application/json"
  };

  void oUpload(String nameFile, File file, Function callback) async {
    Adjunto objResult = new Adjunto();

    final token = _getToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(base + 'Adjuntos'),
    );
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      HttpHeaders.authorizationHeader: "Bearer $token",
      'Accept': 'application/json'
    };
    request.files.add(http.MultipartFile(
        'image', file.readAsBytes().asStream(), file.lengthSync(),
        filename: nameFile));

    request.headers.addAll(headers);
    print("request: " + request.toString());
    StreamedResponse _result = await request.send();

    _result.stream.transform(utf8.decoder).listen((value) {
      var json = jsonDecode(value);

      objResult = Adjunto.fromMap(json);

      callback(objResult);
    });

    //  return objResult;
  }

  Future<String> getAPI(String _url, {int allowAnonymous = 0}) async {
    var url = Uri.parse(base + _url);
    http.Response response;

    if (allowAnonymous == 0) {
      final token = _getToken();
      print('empezo $_url');
      response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );
    } else
      response = await http.get(url);
    print('termino $_url');

    return (response.body);
  }

  Future<Map<String, dynamic>> postAPI(
      String _url, Object object, int allowAnonymous) async {
    final token = _getToken();
    print('empezo $_url');
    var url = Uri.parse(base + _url);
    http.Response response;

    if (allowAnonymous == 1)
      response = await http.post(url,
          headers: requestHeaders, body: json.encode(object));
    else {
      response = await http.post(url, body: json.encode(object), headers: {
        "Content-Type": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });
    }
    print('termino $_url');
    return jsonDecode(response.body);
  }
}
