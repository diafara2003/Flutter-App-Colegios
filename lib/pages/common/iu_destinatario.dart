import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/destinatarios_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget uiDestinatario(List<DestinatarioModel> _destinatarios) {
  if (_destinatarios.length > 2) {
    return ExpandablePanel(
      header: Wrap(children: lstDestinatarios(_destinatarios.take(2).toList())),
      collapsed: Container(),
      expanded: Wrap(
          children: lstDestinatarios(
              _destinatarios.sublist(2, _destinatarios.length))),
    );
  } else
    return Wrap(children: lstDestinatarios(_destinatarios));
}

List<Widget> lstDestinatarios(List<DestinatarioModel> lst) {
  List<Widget> objWidget = [];

  lst.forEach((element) {
    objWidget.add(textoBurbuja(element));
  });

  return objWidget;
}

FittedBox textoBurbuja(DestinatarioModel element) {
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
      margin: EdgeInsets.only(right: 5.0, bottom: 5.0),
      padding: EdgeInsets.only(right: 5.0, top: 3.0, bottom: 3.0),
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
        Container(
            padding: EdgeInsets.only(left: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${element.perNombres} ${element.perApellidos}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Utilities.hexToColor(element.grEnColorRgb))),
                if (element.curDescripcion != '')
                  Text(
                    element.tipo == -25
                        ? "${element.graDescripcion} - (${element.curDescripcion})"
                        : "(${element.curDescripcion})",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black54, fontSize: 11.0),
                  )
              ],
            )),
      ]),
    ),
  );
}

Widget asunto(TextEditingController asuntotext, bool validation) {
  return Container(
    child: Column(
      children: [
        TextFormField(
          inputFormatters: [
            new LengthLimitingTextInputFormatter(100),
          ],
          //  autofocus: true,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: "Asunto:"),
          controller: asuntotext,
          validator: (val) {
            if (!validation) return null;
            if (val!.isEmpty) return "Ingrese un asunto";

            return null;
          },
          // decoration: InputDecoration(
          //   border: UnderlineInputBorder(),
          // ),
        ),
      ],
    ),
  );
}
