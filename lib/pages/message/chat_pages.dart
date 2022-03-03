import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/adjunto_models.dart';
import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/models/message_details_models.dart';
import 'package:autraliano/models/person.dart';
import 'package:autraliano/models/sent_to_models.dart';
import 'package:autraliano/pages/common/banner_color.dart';
import 'package:autraliano/pages/common/common_message.dart';
import 'package:autraliano/providers/Models/message_provider.dart';
import 'package:autraliano/services/message/messaje_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' show Html;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zefyr/zefyr.dart';
import '../../providers/Session/preferencias_provider.dart';
import 'chat_enviados_pages.dart';
import 'response_chat.dart';

// ignore: must_be_immutable
class ChatPages extends StatefulWidget {
  static final String routeName = "chatMessage";
  MessageModelProvider _message = new MessageModelProvider();
  bool _isEnviados = false;

  ChatPages({Key? key, bool isEnviados = false, MessageModelProvider? message})
      : super(key: key) {
    this._isEnviados = isEnviados;

    if (message != null) this._message = message;
  }

  @override
  _ChatPagesState createState() => _ChatPagesState();
}

class _ChatPagesState extends State<ChatPages> {
  MessageServices _messagesProvider = new MessageServices();
  bool download = false;
  List<Adjunto> lstAdjuntos = [];
  List<MessageDetatails> lstMessages = <MessageDetatails>[];
  MessageDetatails _msnCurrent = new MessageDetatails();
  PreferenciasUsuario _prefe = new PreferenciasUsuario();
  Usuario currentUser = new Usuario();

  bool focus = false;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> _user = _prefe.usuario;

    currentUser = Usuario.fromJson(_user);
  }

  NotusDocument loadDocument(String msn) {
    final Delta delta = Delta()..insert("$msn\n");

    return NotusDocument.fromDelta(delta);
  }

  Future<List<MessageDetatails>> getMessages() async {
    lstMessages = await _messagesProvider.getChat(
        this.widget._message.id, this.widget._message.banid);

    _msnCurrent = lstMessages
        .firstWhere((element) => element.menId == this.widget._message.id);

    if (_msnCurrent.menTipoMsn == null) _msnCurrent.menTipoMsn = "";

    return lstMessages;
  }

  List<DestinatarioModel> sentTochat(String sentto) {
    List<SentToModels> _lst = sentToFromMap(sentto);
    List<DestinatarioModel> _destinatarios = [];

    _lst.forEach((element) {
/*
 id: element.perId,
          tipo: element.tipo,
          bg: element.grEnColorRgb,
          apellido: element.perApellidos,
          nombre: element.perNombres,
          ocupacion: element.graDescripcion
 */
      _destinatarios.add(new DestinatarioModel(
          perId: element.id,
          grEnColorRgb: element.bg,
          perApellidos: element.apellido,
          perNombres: element.nombre,
          graDescripcion: element.ocupacion,
          curDescripcion: '',
          grEnColorBurbuja: '',
          grEnColorObs: '',
          idEst: 0,
          tipo: element.tipo));
    });

    return _destinatarios;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NewGradientAppBar(
          actions: !this.widget._isEnviados
              ? [
                  IconButton(
                      onPressed: () {
                        showBarModalBottomSheet(
                          context: context,
                          builder: (context) => Scaffold(
                            body: Container(
                              //  padding: EdgeInsets.all(5.0),
                              child: Container(
                                color: Colors.red,
                                height: 800.0,
                                child: ResponserChatPages(
                                    asunto: _msnCurrent.menAsunto!,
                                    msnCurrent: _msnCurrent,
                                    enabledSender: this.widget._isEnviados,
                                    destinatarios:
                                        sentTochat(_msnCurrent.menSendTo!)),
                              ),
                            ),
                          ),
                          expand: true,
                        );
                      },
                      icon: Icon(
                        Icons.outgoing_mail,
                        color: Colors.black54,
                        size: 30.0,
                      ))
                ]
              : [],
          gradient: LinearGradient(colors: bannerColor()),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${this.widget._message.nombre} ${this.widget._message.apellido}',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Text(
                this.widget._message.menAsunto,
                style: TextStyle(color: Colors.black54, fontSize: 14.0),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: getMessages(),
                  builder: (BuildContext contex,
                      AsyncSnapshot<List<MessageDetatails>> snapshot) {
                    if (!snapshot.hasData)
                      return loadding();
                    else {
                      if (snapshot.data!.length == 1)
                        return ChatEnviadosPages(message: snapshot.data!.first);
                      else
                        return ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            final MessageDetatails message =
                                snapshot.data![index];
                            final bool isMe =
                                message.menUsuario == currentUser.perId;
                            return _buildMessage(message, isMe);
                          },
                          itemCount: lstMessages.length,
                        );
                    }
                  }),
            ),
            this.widget._isEnviados
                ? Container()
                : Container(
                    child: SafeArea(child: _buildessageComposer()),
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 32,
                              color: Color(0xFF087949).withOpacity(0.08))
                        ]),
                  )
          ],
        ));
  }

  Widget _buildMessage(MessageDetatails mensaje, bool isMe) {
    var document = mensaje.menMensaje;
    String _estudiante = "";

    if (mensaje.estApellidos!.isNotEmpty)
      _estudiante = "(${mensaje.estNombres} ${mensaje.estApellidos})";

    String formattedDate = "";
    //mensaje.menFecha.toString();

    if (mensaje.menFecha != null)
      formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(mensaje.menFecha!);

    return Card(
      color: isMe ? Utilities.hexToColor('#dbf7dc') : Colors.white,
      margin: EdgeInsets.all(5.0),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      radius: 20.0,
                      child: Text(
                          Utilities.inicialesUsuario(
                              mensaje.usuario!.perNombres,
                              mensaje.usuario!.perApellidos),
                          style: TextStyle(color: Colors.white))),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        Text(
                          'De:',
                          textAlign: TextAlign.left,
                          style: TextStyle(),
                        ),
                        Text(
                            '${mensaje.usuario!.perNombres} ${mensaje.usuario!.perApellidos} $_estudiante')
                      ]),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Container(
                child: Html(data: document),
              ),
              if (mensaje.adjuntos != null && mensaje.adjuntos!.length > 0)
                mensaje.adjuntos != null && mensaje.adjuntos!.length > 0
                    ? renderizarAdjuntos(mensaje.adjuntos!)
                    : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildessageComposer() {
    if (_msnCurrent.menBloquearRespuesta == 1)
      return Container();
    else
      return Column(
        children: [
          renderizarAdjuntosEnviar(context, lstAdjuntos, (Adjunto _file) {
            setState(() {
              lstAdjuntos
                  .removeWhere((element) => element.ajdId == _file.ajdId);
            });
          }),
        ],
      );
  }

  Widget loadding() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          enabled: true,
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (_, __) => Card(
                elevation: 1.5,
                child: Container(
                  height: 80,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: 20.0,
                          child: Text('JU')),
                      Expanded(
                          child: Container(
                        child: Text(
                          'sdfsfsd',
                          style: TextStyle(color: Colors.red),
                        ),
                      ))
                    ],
                  ),
                )),
          )),
    );
  }
}
