import 'dart:ui';
import 'package:html/parser.dart' show parse;

class Utilities {
  static String inicialesUsuario(String? nombre, String? apellidos) {
    if (apellidos == null) apellidos = "";

    if (nombre!.isEmpty && apellidos.isEmpty) return "-";

    if (nombre.isEmpty && apellidos.isNotEmpty) {
      nombre = apellidos;
      apellidos = "";
    }

    final String n1 = nombre.substring(0, 1).toUpperCase();

    final String n2 =
        apellidos.isEmpty ? "" : apellidos.substring(0, 1).toUpperCase();
    //apellidos = apellidos == "" ? nombre.substr(0, 3) : apellidos;
    return '$n1$n2';
  }

  static Color hexToColor(String code) {
    if (code.isEmpty) code = '#ffffff';
    if (code == 'red') code = "#ff0000";

    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static String parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  static String parseStringToHTML(String text) {
    var document = parse(text);

    String parsedString = parse(document.body!.text).documentElement!.innerHtml;

    return parsedString;
  }
}
