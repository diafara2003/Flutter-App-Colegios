import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/services/message/messaje_services.dart';
import 'package:flutter/material.dart';

class DestinatariosProvider with ChangeNotifier {
  bool _isCompletedfetch = false;
  List<DestinatarioModel> _destinatarios = [];
  List<DestinatarioModel> _sentTo = [];

  List<DestinatarioModel> get destinatarios => this._destinatarios;
  set destinatarios(List<DestinatarioModel> value) {
    this._destinatarios = value;
    if (this.hasListeners) notifyListeners();
  }

  List<DestinatarioModel> get sentTo => this._sentTo;
  set sentTo(List<DestinatarioModel> value) {
    this._sentTo = value;
    //  notifyListeners();
  }

  void notifyUpdate() {
    notifyListeners();
  }

  bool get isCompletedfecth => this._isCompletedfetch;
  set isCompletedfecth(bool value) => this._isCompletedfetch = value;

  update(DestinatarioModel model) {
    int _index =
        _destinatarios.indexWhere((element) => model.perId == element.perId);

    _destinatarios[_index] = model;

    notifyListeners();
  }

  void getDestinatarios(int usuario) async {
    if (this._destinatarios.length == 0) {
      this._isCompletedfetch = false;

      List<DestinatarioModel> _response =
          await new MessageServices().getDestinatarios(usuario);

      this._isCompletedfetch = true;
      this.destinatarios = _response;
    }
  }
}
