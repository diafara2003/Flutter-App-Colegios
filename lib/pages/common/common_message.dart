import 'dart:io';

import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/adjunto_models.dart';
import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/pages/message/download_file.dart';
import 'package:autraliano/providers/API/fetch_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Widget renderizarAdjuntos(List<Adjunto> adjuntos) {
  List<Widget> obj = [];
  for (var i = 0; i < adjuntos.length; i++) {
    Adjunto _document = adjuntos[i];

    obj.add(Container(
        child: DownLoadFilePages(
      file: _document,
      readOnly: true,
    )));
  }

  return Column(
    children: [
      Divider(),
      Container(
        child: Column(
          children: obj,
        ),
      ),
    ],
  );
}

Future adjuntosUI(BuildContext context, Function fn) async {
  return await showMaterialModalBottomSheet(
    expand: false,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => new Container(
        height: 300.0,
        color: Colors.transparent, //could change this to Color(0xFF737373),
        //so you don't have to change MaterialApp canvasColor
        child: new Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Camara'),
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.blue,
                    size: 28.0,
                  ),
                  onTap: () {
                    pickImage(ImageSource.camera, fn);
                    Navigator.of(context).pop();
                  },
                ),
                Divider(),
                ListTile(
                    title: Text('Galeria'),
                    leading: Icon(
                      Icons.photo_size_select_actual_outlined,
                      color: Colors.blue,
                      size: 28.0,
                    ),
                    onTap: () async {
                      await pickImage(ImageSource.gallery, fn);
                      Navigator.of(context).pop();
                    }),
                Divider(),
                ListTile(
                  title: Text('Documento'),
                  leading: Icon(
                    Icons.file_present_outlined,
                    color: Colors.blue,
                    size: 28.0,
                  ),
                  onTap: () async {
                    _openFileExplorer(fn);
                  },
                ),
                Divider(),
                ListTile(
                  title: Center(
                    child: GestureDetector(
                      child: Container(
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  onTap: () => {
                    Navigator.of(context).pop(),
                  },
                ),
              ],
            ))),
  );
  // _openFileExplorer();
}

void _openFileExplorer(Function callback) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    PlatformFile file = result.files.first;

    final File _file = File(result.files.first.path!);

    new Providers().oUpload(file.name, _file, (Adjunto _result) {
      callback(_result);
    });
  }
}

Future pickImage(ImageSource tipo, Function callback) async {
  try {
    final image = await ImagePicker().pickImage(source: tipo);

    if (image == null) return;

    final fileImage = File(image.path);

    new Providers().oUpload(image.name, fileImage, (Adjunto _result) {
      callback(_result);
    });

    //Navigator.of(context).pop();
  } on PlatformException catch (e) {
    print(e);
  }
}

Widget renderizarAdjuntosEnviar(
    BuildContext context, List<Adjunto> _adjuntos, Function callback) {
  List<Widget> _files = [];

  _adjuntos.forEach((_file) {
    _files.add(Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
      child: Card(
        margin: EdgeInsets.only(top: 5.0),
        child: ListTile(
          onTap: () {},
          title: DownLoadFilePages(
            file: _file,
            readOnly: false,
          ),
          trailing: GestureDetector(
            onTap: () {
              callback(_file);

              print('trash');
            },
            child: Icon(
              Icons.delete,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    ));
  });

  return Container(
    child: Column(children: _files),
  );
}

FittedBox textoBurbujaEnviados(DestinatarioModel element) {
  return FittedBox(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
            topLeft: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0)),
      ),
      margin: EdgeInsets.only(right: 5.0),
      padding: EdgeInsets.only(right: element.tipo == -99 ? 0 : 5.0),
      child: Row(children: [
        Container(
          alignment: Alignment.topLeft,
          child: CircleAvatar(
            backgroundColor: Utilities.hexToColor(element.grEnColorRgb),
            //  backgroundColor: Colors.transparent,
            radius: 15.0,
            child: Text(
              Utilities.inicialesUsuario(
                  element.perNombres, element.perApellidos),
              style: TextStyle(color: Colors.white70, fontSize: 14.0),
            ),
          ),
        ),
        if (element.tipo != -99)
          Container(
              // width: 100,
              padding: EdgeInsets.only(left: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${element.perNombres} ${element.perApellidos}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Utilities.hexToColor(element.grEnColorRgb))),
                  if (element.graDescripcion != '' ||
                      element.curDescripcion != '')
                    ConstrainedBox(
                      constraints: new BoxConstraints(
                        minWidth: 0,
                        maxWidth: 200.0,
                      ),
                      child: Container(
                        // width: 200,
                        child: Text(
                          element.graDescripcion.isNotEmpty
                              ? "${element.graDescripcion} "
                              : "${element.curDescripcion}",
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 11.0),
                        ),
                      ),
                    )
                ],
              )),
      ]),
    ),
  );
}
