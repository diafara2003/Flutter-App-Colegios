import 'package:autraliano/models/adjunto_models.dart';
import 'package:autraliano/models/destinatarios_message_modeles.dart';
import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/models/new_messge.dart';
import 'package:autraliano/models/sent_to_models.dart';
import 'package:autraliano/pages/common/alert.dart';
import 'package:autraliano/pages/common/banner_color.dart';
import 'package:autraliano/pages/common/common_message.dart';
import 'package:autraliano/pages/common/iu_destinatario.dart';
import 'package:autraliano/pages/message/sent_to_pages.dart';
import 'package:autraliano/providers/Models/destinatarios_provider.dart';
import 'package:autraliano/services/message/messaje_services.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:notustohtml/notustohtml.dart';
import 'package:provider/provider.dart';
import 'package:zefyr/zefyr.dart';

class NewMessagePages extends StatefulWidget {
  NewMessagePages({Key? key}) : super(key: key);

  @override
  _NewMessagePagesState createState() => _NewMessagePagesState();
}

class _NewMessagePagesState extends State<NewMessagePages> {
  final formkey = GlobalKey<FormState>();
  ZefyrController _controller = ZefyrController();

  TextEditingController _asuntotext = new TextEditingController();
  List<String> tags = [];
  List<Adjunto> _adjuntos = [];
  List<DestinatarioModel> _destinatarios = [];
  bool focus = false;

  @override
  void initState() {
    super.initState();
    _controller = ZefyrController();
  }

  String setSentTo() {
    List<SentToModels> obj = [];

    _destinatarios.forEach((element) {
      obj.add(new SentToModels(
          id: element.perId,
          tipo: element.tipo,
          bg: element.grEnColorRgb,
          apellido: element.perApellidos,
          nombre: element.perNombres,
          ocupacion: element.graDescripcion));
    });

    return senToToMap(obj);
  }

  void _enviarMensaje(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      final converter = NotusHtmlCodec();
      final html = converter.encode(_controller.document.toDelta());

      MessageServices _provider = new MessageServices();
      NewMessage _mensaje = new NewMessage(adjuntos: [], destinatarios: []);
      NewMessajeDto _objMensaje = new NewMessajeDto();

      _objMensaje.menMensaje = html;
      _objMensaje.menAsunto = _asuntotext.text;
      _objMensaje.menOkRecibido = 0;
      _objMensaje.menBloquearRespuesta = 0;
      _objMensaje.menId = 0;
      _objMensaje.menFechaMaxima = null;
      _objMensaje.menEstado = 0;
      _objMensaje.menTipoMsn = "E";
      _objMensaje.menCategoriaId = -1;
      _objMensaje.menSendTo = setSentTo();

      _adjuntos.forEach((element) {
        _mensaje.adjuntos.add(element.ajdId!);
      });

      _mensaje.destinatarios = [];

      _destinatarios.forEach((element) {
        _mensaje.destinatarios.add(new DestinatariosMessageModels(
            id: element.perId, tipo: element.tipo, estudiante: element.idEst));
      });

      _mensaje.mensaje = _objMensaje;

      _provider.nuevoMensaje(_mensaje);

      dialogCustom(
          context: context,
          header: "Mensaje enviado",
          msn: "Mensaje enviado correctamente.",
          ok: () {
            Navigator.of(context).pop(true);
            //back
            Navigator.of(context).pop(true);
          });

      //dimiss modal

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
          gradient: LinearGradient(colors: bannerColor()),
          title: Text(
            'Nuevo Mensaje',
            style: TextStyle(color: Colors.black54),
          ),
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
                  _enviarMensaje(context);
                }),
          ]),
      body: Container(
        child: Form(
          key: formkey,
          child: Container(
            //  height: 500.0,
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  para(),
                  asunto(_asuntotext, true),
                  renderizarAdjuntosEnviar(context, _adjuntos, (_file) {
                    setState(() {
                      _adjuntos.removeWhere(
                          (element) => element.ajdId == _file.ajdId);
                    });
                  }),
                  escribirMensaje(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget para() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SentToPages()));
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 4.0),
            child: Text(
              'Para:',
              style: TextStyle(fontSize: 14.0),
            ),
          ),
          Expanded(
            child: Consumer<DestinatariosProvider>(builder: (_, prov, __) {
              _destinatarios = prov.sentTo;
              return Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: uiDestinatario(_destinatarios));
            }),
          ),
          FittedBox(
            child: IconButton(
              iconSize: 30.0,
              icon: Icon(Icons.add_circle),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SentToPages()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget escribirMensaje() {
    FocusNode _focusNode = FocusNode();

    return SingleChildScrollView(
      // isAlwaysShown: true,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
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
                          toolbar: ZefyrToolbar.basic(controller: _controller),
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
    );
  }
}
