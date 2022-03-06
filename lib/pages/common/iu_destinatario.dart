import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/pages/common/common_message.dart';
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
    objWidget.add(textoBurbujaEnviados(element));
  });

  return objWidget;
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
