import 'package:autraliano/providers/API/fetch_provider.dart';
import 'package:autraliano/providers/Session/preferencias_provider.dart';
import 'package:autraliano/services/auth/login_services.dart';
import 'package:autraliano/services/push/push_notificacions_services.dart';
import 'package:flutter/material.dart';

class LoggedProvider with ChangeNotifier {
  bool _logged = false;
  bool _loadedSession = false;

  bool get logged => this._logged;

  set logged(bool value) {
    this._logged = value;

    notifyListeners();
  }

  bool get loadedSession => this._loadedSession;

  set loadedSession(bool value) {
    this._loadedSession = value;
    notifyListeners();
  }

  Future<bool> validateSession() async {
    await PreferenciasUsuario.init();

    this.logged = await new Providers().verificarSession();

    if (this.logged && PushNotificacionService.token != '') {
      new LoginProvider().registarToken(PushNotificacionService.token);
    }
    this.loadedSession = true;

    return this.logged;
  }
}
