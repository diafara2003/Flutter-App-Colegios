import 'package:autraliano/models/profesor_models.dart';
import 'package:autraliano/providers/API/fetch_provider.dart';

class ProfesorServices {
  Future<List<Profesor>> getData() async {
    Providers obj = new Providers();

    try {
      //http://www.comunicatecolegios.com/api/Mensajes/destinatarios?idusuario=73&filter=%C2%A0
      String json = await obj.getAPI('profesor');
      return new Profesor.empty().profesorProviderFromJson(json);
    } catch (e) {
      print(e);

      return <Profesor>[];
    }
  }
}
