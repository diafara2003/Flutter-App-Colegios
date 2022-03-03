import 'package:autraliano/helper/utilities.dart';
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
        header: Wrap(children: textoBurbuja(_lst.take(2).toList())),
        collapsed: Container(),
        expanded: Wrap(children: textoBurbuja(_lst.sublist(2, _lst.length))),
      );
    } else
      return Wrap(children: textoBurbuja(_lst));
  }

  List<Widget> textoBurbuja(List<SentToModels> _lst) {
    List<Widget> _objLst = [];

    _lst.forEach((element) {
      _objLst.add(FittedBox(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                topLeft: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0)),
          ),
          margin: EdgeInsets.only(right: 5.0, top: 2.0, bottom: 2.0),
          padding: EdgeInsets.only(
              right: element.tipo == -99 ? 0 : 5.0, bottom: 2.0),
          child: Row(children: [
            Container(
              padding: EdgeInsets.only(right: 5.0),
              //  alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundColor: Utilities.hexToColor(element.bg),
                //  backgroundColor: Colors.transparent,
                radius: 15.0,
                child: Text(
                  Utilities.inicialesUsuario(element.nombre, element.apellido),
                  style: TextStyle(color: Colors.white70, fontSize: 14.0),
                ),
              ),
            ),
            if (element.tipo != -99)
              Container(
                  // padding: EdgeInsets.only(left: 2.0),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${element.nombre} ${element.apellido}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Utilities.hexToColor(element.bg))),
                  if (element.ocupacion.isNotEmpty)
                    Text(
                      "(${element.ocupacion})",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54, fontSize: 11.0),
                    )
                ],
              )),
          ]),
        ),
      ));
    });

    return _objLst;
  }
}
