import 'dart:io';

import 'package:autraliano/models/adjunto_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'fetch_provider.dart';

class DocumentProvider {
  static Future<String> get _localDevicePath async {
    final _devicePath = await getTemporaryDirectory();
    return _devicePath.path;
  }

  static Future<File> _localFile(
      {required String path,
      required String type,
      required String name}) async {
    String _path = await _localDevicePath;

    var _newPath = await Directory("$_path/$path").create();
    return File("${_newPath.path}/$name.$type");
  }

  static Future<String> downloadDocument(Adjunto document) async {
    var url =
        Uri.parse("${Providers.base}/adjunto/descargar?id=${document.ajdId}");
    final _response = await http.get(url);

    final _file = await _localFile(
        path: "veli",
        type: _fileExtension(document.ajdExtension!),
        name: document.adjNombre!);
    await _file.writeAsBytes(_response.bodyBytes, flush: true);

    return _file.path;
  }

  static String _fileExtension(String type) {
    String _extension = type.toLowerCase().replaceAll('.', '');

    return _extension;
  }
}
