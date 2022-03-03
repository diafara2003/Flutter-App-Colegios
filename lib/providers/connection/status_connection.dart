import 'dart:async';
import 'dart:io';

Future<bool> checkConnection() async {
  bool _result = false;
  try {
    final result = await InternetAddress.lookup('comunicatecolegios.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      _result = true;
    }
  } on SocketException catch (_) {
    _result = false;
  }

  return _result;
}
