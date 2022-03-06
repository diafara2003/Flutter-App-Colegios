import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/models/message_details_models.dart';
import 'package:autraliano/models/sent_to_models.dart';
import 'package:autraliano/pages/common/common_message.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ChatEnviadosPages extends StatefulWidget {
  final MessageDetatails message;
  ChatEnviadosPages({Key? key, required this.message}) : super(key: key);

  @override
  _ChatEnviadosPagesState createState() => _ChatEnviadosPagesState();
}

class _ChatEnviadosPagesState extends State<ChatEnviadosPages> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Card(
            margin: EdgeInsets.all(5.0),
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Para:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  if (this.widget.message.menSendTo!.isNotEmpty)
                    Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: renderDestinatarios()),
                  Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text('Asunto:',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(this.widget.message.menAsunto!)),
                  if (this.widget.message.adjuntos != null &&
                      this.widget.message.adjuntos!.length > 0)
                    Divider(),
                  Divider(),
                  Container(
                    child: Html(data: this.widget.message.menMensaje),
                  ),
                  this.widget.message.adjuntos != null &&
                          this.widget.message.adjuntos!.length > 0
                      ? renderizarAdjuntos(this.widget.message.adjuntos!)
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget renderDestinatarios() {
    List<SentToModels> _lst = sentToFromMap(this.widget.message.menSendTo!);

    if (_lst.length > 2) {
      return ExpandablePanel(
        header: Wrap(children: uiDestinatario(_lst.take(2).toList())),
        collapsed: Container(),
        expanded: Wrap(children: uiDestinatario(_lst.sublist(2, _lst.length))),
      );
    } else
      return Wrap(children: uiDestinatario(_lst));
  }

  List<Widget> uiDestinatario(List<SentToModels> _lst) {
    List<Widget> _objLst = [];

    _lst.forEach((element) {
      _objLst.add(textoBurbujaEnviados(new DestinatarioModel(
          curDescripcion: element.ocupacion,
          grEnColorBurbuja: '',
          grEnColorObs: '',
          grEnColorRgb: element.bg,
          graDescripcion: '',
          idEst: element.id,
          perApellidos: element.apellido,
          perId: element.id,
          perNombres: element.nombre,
          tipo: element.tipo)));
    });

    return _objLst;
  }
}
