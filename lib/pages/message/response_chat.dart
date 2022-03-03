import 'package:autraliano/models/adjunto_models.dart';
import 'package:autraliano/models/destinatarios_message_modeles.dart';
import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/models/message_details_models.dart';
import 'package:autraliano/models/person.dart';
import 'package:autraliano/models/reply_message.dart';
import 'package:autraliano/models/sent_message.dart';
import 'package:autraliano/models/sent_to_models.dart';
import 'package:autraliano/pages/common/alert.dart';
import 'package:autraliano/pages/common/banner_color.dart';
import 'package:autraliano/pages/common/common_message.dart';
import 'package:autraliano/pages/common/iu_destinatario.dart';
import 'package:autraliano/providers/Session/preferencias_provider.dart';
import 'package:autraliano/services/message/messaje_services.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:notustohtml/notustohtml.dart';
import 'package:zefyr/zefyr.dart';

import 'home_message_pages.dart';

// ignore: must_be_immutable
class ResponserChatPages extends StatefulWidget {
  List<DestinatarioModel> _destinatarios = [];
  MessageDetatails _msnCurrent = MessageDetatails.empty();
  String _asunto = "";
  ResponserChatPages(
      {Key? key,
      required List<DestinatarioModel> destinatarios,
      required MessageDetatails msnCurrent,
      required enabledSender,
      required String asunto})
      : super(key: key) {
    _destinatarios = destinatarios;
    _asunto = asunto;

    _msnCurrent = msnCurrent;
  }

  @override
  State<ResponserChatPages> createState() => _ResponserChatPagesState();
}

class _ResponserChatPagesState extends State<ResponserChatPages> {
  List<Adjunto> _adjuntos = [];
  TextEditingController _asuntotext = new TextEditingController();
  Usuario currentUser = new Usuario();
  bool focus = false;
  final formkey = GlobalKey<FormState>();
  ZefyrController _controller = ZefyrController();
  PreferenciasUsuario _prefe = new PreferenciasUsuario();
  MessageServices _messagesProvider = new MessageServices();

  @override
  void initState() {
    super.initState();

    _asuntotext.text = this.widget._asunto;

    Map<String, dynamic> _user = _prefe.usuario;
    currentUser = Usuario.fromJson(_user);
    _controller = ZefyrController();
  }

  void _enviarMensaje() async {
    EnviarMensajeDto _msn = new EnviarMensajeDto();
    final converter = NotusHtmlCodec();
    final html = converter.encode(_controller.document.toDelta());

    if (html == '' || html.replaceAll('<br>', '') == '') return;

    _msn.destinatarios = [];
    _msn.destinatarios!.add(DestinatariosMessageModels(
        id: this.widget._msnCurrent.usuario!.perTipoPerfil == 3
            ? this.widget._msnCurrent.idEstudiante!
            : this.widget._msnCurrent.menUsuario!,
        tipo: this.widget._msnCurrent.usuario!.perTipoPerfil == 3 ? -28 : -35,
        estudiante: this.widget._msnCurrent.idEstudiante!));

    _msn.adjuntos = [];
    _adjuntos.forEach((element) {
      _msn.adjuntos!.add(element.ajdId!);
    });

    _msn.mensaje = new ReplicaMsnDto(
        menId: 0,
        menUsuario: currentUser.perId!,
        menClase: 0,
        menTipoMsn: 'E',
        menAsunto: this.widget._msnCurrent.menAsunto!,
        menMensaje: html,
        menOkRecibido: 0,
        menSendTo: setSentTo(),
        menEmpId: currentUser.perIdEmpresa,
        menCategoriaId: -1,
        menBloquearRespuesta: 0,
        menReplicaIdMsn: this.widget._msnCurrent.menId!);

    _messagesProvider.enviarMensaje(_msn);

    dialogCustom(
        context: context,
        header: "Mensaje enviado",
        msn: "Mensaje enviado correctamente.",
        ok: () {
          Navigator.of(context).pushNamed(HomeMessagesPages.routeName);
        });
  }

  String setSentTo() {
    List<SentToModels> obj = [];

    obj.add(new SentToModels(
        id: this.widget._msnCurrent.menUsuario!,
        tipo: -35,
        bg: this.widget._msnCurrent.usuario!.perTipoPerfil == 1
            ? '#43AC34'
            : this.widget._msnCurrent.usuario!.perTipoPerfil == 0
                ? 'red'
                : '#09BBF9',
        apellido: this.widget._msnCurrent.usuario!.perApellidos!,
        nombre: this.widget._msnCurrent.usuario!.perNombres!,
        ocupacion: ''));

    return senToToMap(obj);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close)),
          actions: [
            IconButton(
                icon: Icon(Icons.attach_file_outlined, color: Colors.black54),
                onPressed: () {
                  adjuntosUI(context, (Adjunto file) {
                    setState(() {
                      _adjuntos.add(file);
                    });
                  });
                }),
            IconButton(
                icon: Icon(Icons.send, color: Colors.black54),
                onPressed: () {
                  _enviarMensaje();
                })
          ],
          gradient: LinearGradient(colors: bannerColor()),
          title: Text(
            'Responder Mensaje',
            style: TextStyle(color: Colors.black54),
          )),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                para(),
                asunto(_asuntotext, false),
                escribirMensaje(),
                renderizarAdjuntosEnviar(context, _adjuntos, (_file) {
                  setState(() {
                    _adjuntos
                        .removeWhere((element) => element.ajdId == _file.ajdId);
                  });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget para() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 4.0),
          child: Text(
            'Para:',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        Expanded(
          child: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: uiDestinatario(this.widget._destinatarios)),
        ),
      ],
    );
  }

  Widget escribirMensaje() {
    FocusNode _focusNode = FocusNode();

    return SingleChildScrollView(
      // isAlwaysShown: true,
      child: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    focus = true;
                  });
                },
                child: Card(
                    margin: EdgeInsets.only(
                        top: 5.0, left: 0.0, right: 0.0, bottom: 5.0),
                    color: Colors.white,
                    child: Container(
                        padding: EdgeInsets.only(left: 5.0),
                        child: SingleChildScrollView(
                          child: ZefyrField(
                            toolbar:
                                ZefyrToolbar.basic(controller: _controller),
                            // padding: EdgeInsets.all(16),
                            controller: _controller,
                            focusNode: _focusNode,
                            autofocus: focus,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Escribir mensaje...',
                            ),
                          ),
                        ))))),
      ),
    );
  }
}
