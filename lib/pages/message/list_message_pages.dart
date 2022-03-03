import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/providers/Models/message_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_pages.dart';

class ListMessagesPages extends StatefulWidget {
  final bool sinLeer;
  ListMessagesPages(this.sinLeer);

  @override
  _ListMessagesPagesState createState() => _ListMessagesPagesState();
}

class _ListMessagesPagesState extends State<ListMessagesPages> {
  @override
  void initState() {
    super.initState();
  }

  bool showSearch = false;

  Future<void> getdata() async {
    final messageProv = Provider.of<MessageProvider>(context, listen: false);

    messageProv.getMessages(0, this.widget.sinLeer);
  }

  void abrirMensaje(MessageModelProvider modelo, MessageProvider prov) {
    if (modelo.banHoraLeido == null && !prov.readOnly) {
      prov.countNoLeidos -= 1;
      modelo.banHoraLeido = DateTime.now();
      prov.update(modelo);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPages(
                  isEnviados: false,
                  message: modelo,
                )));
  }

  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _textController.text = "";
    getdata();
    return
        // buscarMensajes(),
        RefreshIndicator(
      onRefresh: () async {
        getdata();
      },
      child: Column(
        children: [
          buscarMensajes(),
          Expanded(child: composerMessage()),
        ],
      ),
    );
  }

  Widget composerMessage() {
    return Consumer<MessageProvider>(builder: (_, prov, __) {
      if (!prov.isCompletedfetch)
        return Center(child: CircularProgressIndicator()); //loading();
      else {
        if (prov.messages.length == 0)
          return Container(
              child: Column(
            children: [
              emptyMessage(),
            ],
          ));
        else
          return SafeArea(
            //https://www.youtube.com/watch?v=oFZIwBudIj0
            child: ListView.builder(
                // scrollDirection: Axis.vertical,
                //shrinkWrap: true,
                padding: EdgeInsets.only(top: 7.0, right: 5.0, left: 2.0),
                itemCount: prov.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  MessageModelProvider modelo = prov.messages[index];

                  String? fecha = modelo.fecha;
                  DateTime tempDate = DateFormat('d/M/yyyy hh:mm').parse(fecha);

                  // setState(() {
                  //   showSearch = true;
                  // });
                  return ListTile(
                    //  minVerticalPadding: 2.0,
                    contentPadding: EdgeInsets.only(left: 2.0, right: 0.0),
                    onTap: () {
                      abrirMensaje(modelo, prov);
                    },
                    trailing: Text(
                      timeago.format(tempDate, locale: 'es'),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: modelo.banHoraLeido == null
                            ? FontWeight.w600
                            : FontWeight.w300,
                        // color: Colors.black54
                      ),
                    ),
                    leading: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          //  backgroundColor: Colors.transparent,
                          radius: 22.0,
                          child: Text(
                            Utilities.inicialesUsuario(
                                modelo.nombre, modelo.apellido),
                            style: TextStyle(
                                color: Colors.white70, fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          renderMessage(modelo),
                          Divider(
                            //color: Colors.black
                            color: Colors.grey.shade300,
                          )
                        ]),
                  );
                }),
          );
      }
    });
  }

  Widget buscarMensajes() {
    return Container(
      padding: EdgeInsets.only(right: 10.0, left: 10.0),
      child: TextField(
        controller: _textController,
        autocorrect: true,
        // maxLength: 15,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search_rounded),
            hintText: 'Buscar mensajes'),
        onChanged: (String value) {
          Provider.of<MessageProvider>(context, listen: false)
              .changeSearchString(value.trim());
        },
      ),
    );
  }

  Widget emptyMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 3.0,
          child: Container(
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail, color: Theme.of(context).primaryColor),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'No tenemos mensajes para mostrar',
                  style: TextStyle(
                      fontSize: 17.0, color: Theme.of(context).primaryColor),
                ),
              ],
            )),
            width: MediaQuery.of(context).size.width,
            height: 100,
          )),
    );
  }

  Widget renderMessage(MessageModelProvider modelo) {
    String? nombre = modelo.nombre;
    String? apellido = modelo.apellido;

    String acudiente = "";

    if (modelo.estNombre.isNotEmpty)
      acudiente = "(${modelo.estNombre} ${modelo.estApellido}) ";

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          renderizarText("$apellido $nombre", 16.0, modelo.banHoraLeido),
          if (acudiente.isNotEmpty)
            Text(
              acudiente,
              style: TextStyle(fontSize: 13, color: Colors.black38),
            ),
          Container(
            child: renderizarText(modelo.menAsunto, 14.0, modelo.banHoraLeido),
          ),
          Container(
              child: renderizarText(
                  modelo.textoMensaje, 12.0, modelo.banHoraLeido))
        ],
      ),
    );
  }

  Widget renderizarText(String msn, double fontSize, DateTime? horaleido) {
    return Text(
      Utilities.parseHtmlString(msn),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: horaleido == null ? FontWeight.w600 : FontWeight.w300),
    );
  }
}
