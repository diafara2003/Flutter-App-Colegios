import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/message.dart';
import 'package:autraliano/services/message/messaje_services.dart';
import 'package:flutter/material.dart';

class MessageModelProvider {
  static List<MessageModelProvider> map(List<MessageDTO> response) {
    List<MessageModelProvider> objResponse = [];

    response.forEach((MessageDTO element) {
      MessageModelProvider _message = new MessageModelProvider();

      _message.id = element.menId!;
      _message.nombre = element.perNombres!;
      _message.apellido = element.perApellidos!;
      _message.fecha = element.menFecha!;
      _message.banHoraLeido = element.banHoraLeido;
      _message.menAsunto = element.menAsunto!;
      _message.banid = element.banId!;
      _message.textoMensaje = element.menMensaje!;
      _message.estApellido = element.estApellidos!;
      _message.estNombre = element.estNombres!;

      objResponse.add(_message);
    });

    return objResponse;
  }

  // MessageModelProvider.empty();
  int _id = 0;
  String _nombre = "";
  String _apellido = "";
  String _fecha = "";
  DateTime? _banHoraLeido = DateTime.now();
  String _menAsunto = "";
  int _banid = 0;
  String _textoMensaje = "";
  String _estNombre = "";
  String _estApellido = "";

  String get estNombre => this._estNombre;
  set estNombre(String value) {
    this._estNombre = value;
  }

  String get estApellido => this._estApellido;
  set estApellido(String value) {
    this._estApellido = value;
  }

  String get textoMensaje => this._textoMensaje;
  set textoMensaje(String value) {
    this._textoMensaje = value;
  }

  int get id => this._id;
  set id(int value) {
    this._id = value;
  }

  int get banid => this._banid;
  set banid(int value) {
    this._banid = value;
  }

  String get menAsunto => this._menAsunto;
  set menAsunto(String value) {
    this._menAsunto = value;
  }

  String get nombre => this._nombre;
  set nombre(String value) {
    this._nombre = value;
  }

  String get apellido => this._apellido;
  set apellido(String value) {
    this._apellido = value;
  }

  String get fecha => this._fecha;
  set fecha(String value) {
    this._fecha = value;
  }

  DateTime? get banHoraLeido => this._banHoraLeido;
  set banHoraLeido(DateTime? value) {
    this._banHoraLeido = value;
  }
}

class MessageProvider with ChangeNotifier {
  bool _isCompletedfetch = false;
  List<MessageModelProvider> _messages = [];
  int _countNoLeidos = 0;
  String _searchString = "";
  int _userIdMensaje = 0;
  bool _readOnly = false;

  List<MessageModelProvider> get messages => _searchString.isEmpty
      ? _messages
      : _messages
          .where((dog) =>
              dog.nombre.contains(_searchString) ||
              dog.apellido.contains(_searchString) ||
              dog.menAsunto.contains(_searchString) ||
              Utilities.parseHtmlString(dog.textoMensaje)
                  .contains(_searchString))
          .toList();

  set messages(List<MessageModelProvider> value) {
    this._messages = value;

    notifyListeners();
  }

  bool get readOnly => this._readOnly;

  set readOnly(value) => this._readOnly = value;

  int get idUserMensaje => this._userIdMensaje;

  set idUserMensaje(value) {
    if (value != 0) {
      this._userIdMensaje = value;
      //  notifyListeners();
    }
  }

  int get countNoLeidos => this._countNoLeidos;
  set countNoLeidos(value) {
    this._countNoLeidos = value;
    notifyListeners();
  }

  bool get isCompletedfetch => this._isCompletedfetch;
  set isLoaded(value) {
    this._isCompletedfetch = value;
  }

  update(MessageModelProvider model) {
    int _index = messages.indexWhere((element) => model.id == element._id);

    messages[_index] = model;

    notifyListeners();
  }

  void changeSearchString(String searchString) {
    this._searchString = searchString.trim();

    notifyListeners();
  }

  MessageModelProvider getByIndex(int index) => messages[index];

  add(MessageModelProvider value) {
    messages.add(value);

    notifyListeners();
  }

  delete(int id) {
    int _index = messages.indexWhere((element) => id == element._id);

    messages.removeAt(_index);

    notifyListeners();
  }

  void getMessages(int tipo, bool sinLeer) async {
    this._isCompletedfetch = false;
    this._searchString = "";
    List<MessageModelProvider> _lstMessages = MessageModelProvider.map(
        await new MessageServices().getMessages(tipo, this.idUserMensaje));

    this._isCompletedfetch = true;

    if (sinLeer)
      _lstMessages = _lstMessages
          .where((element) => element.banHoraLeido == null)
          .toList();

    this.messages = _lstMessages;

    if (tipo == 0)
      countNoLeidos =
          messages.where((element) => element.banHoraLeido == null).length;
  }
}
