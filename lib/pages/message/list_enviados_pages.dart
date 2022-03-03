import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/models/message.dart';
import 'package:autraliano/models/person.dart';
import 'package:autraliano/models/sent_to_models.dart';
import 'package:autraliano/providers/Models/message_provider.dart';
import 'package:autraliano/providers/Session/preferencias_provider.dart';
import 'package:autraliano/services/message/messaje_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_pages.dart';

class ListEnvaidosPages extends StatefulWidget {
  ListEnvaidosPages({Key? key}) : super(key: key);

  @override
  _ListEnvaidosPagesState createState() => _ListEnvaidosPagesState();
}

class _ListEnvaidosPagesState extends State<ListEnvaidosPages> {
  Usuario _user = Usuario.empty();

  Future<List<MessageDTO>> getdata() async {
    return await new MessageServices().getMessages(1, _user.perId!);
  }

  MessageModelProvider map(MessageDTO element) {
    MessageModelProvider _message = new MessageModelProvider();

    _message.id = element.menId!;
    _message.nombre = element.perNombres!;
    _message.apellido = element.perApellidos!;
    _message.fecha = element.menFecha!;
    _message.banHoraLeido = element.banHoraLeido;
    _message.menAsunto = element.menAsunto!;
    _message.banid = element.banId!;
    _message.textoMensaje = element.menMensaje!;
    _message.estApellido = element.estApellidos!;
    _message.estNombre = element.estNombres!;

    return _message;
  }

  void abrirMensaje(MessageDTO modelo) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPages(
                  isEnviados: true,
                  message: map(modelo),
                )));
  }

  @override
  void initState() {
    super.initState();

    PreferenciasUsuario _session = new PreferenciasUsuario();

    _user = Usuario.fromJson(_session.usuario);

    // Provider.of<DestinatariosProvider>(context, listen: false).destinatarios =
    //     [];
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getdata();
      },
      child: FutureBuilder(
        builder: (_, AsyncSnapshot<List<MessageDTO>> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else
            return ListView.builder(
              padding: EdgeInsets.only(top: 7.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                MessageDTO _msn = snapshot.data![index];
                return renderizarEnviados(_msn);
              },
            );
        },
        future: getdata(),
      ),
    );
  }

  Widget renderizarEnviados(MessageDTO _msn) {
    String fecha = _msn.menFecha!;
    DateTime tempDate = DateFormat('d/M/yyyy hh:mm').parse(fecha);

    return Column(
      children: [
        ListTile(
          onTap: () {
            abrirMensaje(_msn);
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              renderizarSentTo(_msn.menSendTo!),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: renderText(_msn.menAsunto!, 15),
              ),
              renderText(Utilities.parseHtmlString(_msn.menMensaje!), 13),
            ],
          ),
          trailing: Text(
            timeago.format(tempDate, locale: 'es'),
            style: TextStyle(
              fontSize: 9,
              fontWeight:
                  _msn.banHoraLeido == null ? FontWeight.w600 : FontWeight.w300,
              // color: Colors.black54
            ),
          ),
        ),
        Divider()
      ],
    );
  }

  Text renderText(String _msn, double fontSize) {
    return Text(
      _msn,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }

  Widget renderizarSentTo(String data) {
    if (data.isEmpty) return Container();

    List<SentToModels> _sentTo = sentToFromMap(data);
    int _length = _sentTo.length;

    if (_sentTo.length > 1) {
      _sentTo = _sentTo.take(1).toList();
      _sentTo.add(new SentToModels(
          id: 0,
          tipo: -99,
          bg: '#43AC34',
          apellido: '${_length - 1}',
          nombre: "+${_length - 1}",
          ocupacion: ''));
    }

    List<Widget> _render = [];

    _sentTo.forEach((element) {
      _render.add(textoBurbuja(new DestinatarioModel(
          perId: element.id,
          perNombres: element.nombre,
          perApellidos: element.apellido,
          graDescripcion: element.ocupacion,
          curDescripcion: '',
          tipo: element.tipo,
          grEnColorRgb: element.bg,
          grEnColorObs: element.bg,
          grEnColorBurbuja: element.bg,
          idEst: 0)));
    });

    return Wrap(
      children: _render,
    );
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
                      Container(
                        width: 200,
                        child: Text(
                          element.graDescripcion.isNotEmpty
                              ? "${element.graDescripcion} "
                              : "${element.curDescripcion}",
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 11.0),
                        ),
                      )
                  ],
                )),
        ]),
      ),
    );
  }
}
