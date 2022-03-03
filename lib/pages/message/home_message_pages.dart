import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/person.dart';
import 'package:autraliano/models/profesor_models.dart';
import 'package:autraliano/pages/common/banner_color.dart';
import 'package:autraliano/pages/menu/menu_pages.dart';
import 'package:autraliano/providers/Models/destinatarios_provider.dart';
import 'package:autraliano/providers/Models/message_provider.dart';
import 'package:autraliano/providers/Session/preferencias_provider.dart';
import 'package:autraliano/services/person/profesor_services.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';

import 'list_enviados_pages.dart';
import 'list_message_pages.dart';
import 'new_message.dart';

class HomeMessagesPages extends StatefulWidget {
  static final String routeName = "message";

  HomeMessagesPages({Key? key}) : super(key: key);

  @override
  _HomeMessagesPagesState createState() => _HomeMessagesPagesState();
}

class _HomeMessagesPagesState extends State<HomeMessagesPages> {
  int _currentIndex = 0;
  Usuario _user = Usuario.empty();
  List<Widget> tabs = [ListMessagesPages(false)];
  List<Profesor> lstProfesor = [];
  String selectedDdlUsuario = "";
  bool readOnly = false;

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    PreferenciasUsuario _session = new PreferenciasUsuario();

    _user = Usuario.fromJson(_session.usuario);

    selectedDdlUsuario = _user.perId.toString();
    final messageProv = Provider.of<MessageProvider>(context, listen: false);

    messageProv.idUserMensaje = _user.perId;
  }

  void bandejaProfesores(List<Profesor> data) {
    if (lstProfesor.length == 0) {
      lstProfesor.add(new Profesor(
          apellido: _user.perApellidos!,
          celular: "",
          email: _user.perEmail!,
          nombre: _user.perNombres!,
          id: _user.perId!));

      data.forEach((element) {
        lstProfesor.add(element);
      });

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lstProfesor.length == 0)
      new ProfesorServices()
          .getData()
          .then((value) => {bandejaProfesores(value)});

    return Scaffold(
        appBar: NewGradientAppBar(
          elevation: 1.0,
          title: ddlUsuario(),
          // Text(
          //   nombreUsuario,
          //   style: TextStyle(color: Colors.black54),
          // ),
          gradient: LinearGradient(
              // end: Alignment.bottomRight,
              // begin: Alignment.topLeft,
              colors: bannerColor()),

          actions: readOnly
              ? []
              : [
                  IconButton(
                    color: Colors.black54,
                    icon: Icon(Icons.outgoing_mail, size: 30.0),
                    onPressed: () {
                      DestinatariosProvider obj =
                          Provider.of<DestinatariosProvider>(context,
                              listen: false);

                      obj.destinatarios = [];
                      obj.sentTo = [];
                      showBarModalBottomSheet(
                        context: context,
                        builder: (context) => Scaffold(
                          body: Container(
                            //  padding: EdgeInsets.all(5.0),
                            child: Container(
                              height: 800.0,
                              child: NewMessagePages(),
                            ),
                          ),
                        ),
                        expand: true,
                      );
                    },
                  ),
                ],
        ),
        drawer: MenuPages(),
        bottomNavigationBar: bottomNavigationBar(),
        body: tabs[_currentIndex]);
  }

  Widget ddlUsuario() {
    if (_user.perTipoPerfil == 0)
      return Container(
        // color: Colors.red,
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedDdlUsuario,
          items: lstProfesor.map((ele) {
            return DropdownMenuItem<String>(
              value: ele.id.toString(),
              child: Container(
                // padding: new EdgeInsets.only(right: 13.0),
                child: Text(
                  "${ele.nombre} ${ele.apellido}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      // overflow: TextOverflow.ellipsis,
                      fontWeight: ele.id == _user.perId
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ),
            );
          }).toList(),
          onChanged: (_value) {
            int _userSelected = int.parse(_value!);
            if (selectedDdlUsuario != _value) {
              selectedDdlUsuario = _value;
              final messageProv =
                  Provider.of<MessageProvider>(context, listen: false);
              messageProv.idUserMensaje = _userSelected;

              if (_user.perId == _userSelected)
                readOnly = false;
              else
                readOnly = true;

              messageProv.readOnly = readOnly;

              setState(() {});
            }
          },
        ),
      );
    else
      return Text(
        "${_user.perNombres!} ${_user.perApellidos!}",
        style:
            TextStyle(fontSize: 17.0, color: Utilities.hexToColor('#0B2739')),
      );
  }

  List<BottomNavigationBarItem> iconosMensajes(MessageProvider prov) {
    List<BottomNavigationBarItem> lstIconos = [];
    tabs = [];

    lstIconos.add(BottomNavigationBarItem(
        icon: Icon(Icons.send_rounded), label: "Recibidos"));

    if (prov.countNoLeidos > 0)
      lstIconos.add(BottomNavigationBarItem(
          icon: Badge(
              badgeColor: Theme.of(context).colorScheme.primary,
              shape: BadgeShape.circle,
              borderRadius: BorderRadius.circular(100),
              badgeContent: Consumer<MessageProvider>(
                builder: (_, prov, __) {
                  return Text(prov.countNoLeidos.toString(),
                      style: TextStyle(color: Colors.white));
                },
              ),
              child: Icon(Icons.check_circle)),
          label: 'Sin leer'));

    lstIconos.add(
        BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Enviados'));

    tabs.add(ListMessagesPages(false));

    if (prov.countNoLeidos > 0) tabs.add(ListMessagesPages(true));

    tabs.add(ListEnvaidosPages());

    DestinatariosProvider _prov =
        Provider.of<DestinatariosProvider>(context, listen: false);

    if (_prov.destinatarios.length > 0) _prov.destinatarios = [];
    return lstIconos;
  }

  Widget bottomNavigationBar() {
    return Consumer<MessageProvider>(builder: (_, prov, __) {
      return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTap,
        items: iconosMensajes(prov),
      );
    });
  }
}
