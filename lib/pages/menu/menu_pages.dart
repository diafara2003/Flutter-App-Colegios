import 'package:autraliano/models/person.dart';
import 'package:autraliano/pages/common/banner_color.dart';
import 'package:autraliano/pages/login/cambiar_clave_pages.dart';
import 'package:autraliano/pages/login/signin_pages.dart';
import 'package:autraliano/pages/message/home_message_pages.dart';
import 'package:autraliano/providers/Models/message_provider.dart';
import 'package:autraliano/providers/Session/preferencias_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class MenuPages extends StatefulWidget {
  MenuPages({Key? key}) : super(key: key);

  @override
  _MenuPagesState createState() => _MenuPagesState();
}

class _MenuPagesState extends State<MenuPages> {
  ScrollController controller = ScrollController();
  ScrollPhysics physics = ScrollPhysics();
  Usuario _session = Usuario.fromJson(new PreferenciasUsuario().usuario);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ListView(
              controller: controller,
              physics: physics,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: bannerColor())),
                  accountName: Text(
                    "${_session.perNombres} ${_session.perApellidos}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  accountEmail: Text(_session.perDocumento!,
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        'images/kidsAvatar.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Consumer<MessageProvider>(
                  builder: (_, provider, __) => Column(
                    children: [
                      ListTile(
                        trailing: Text(
                          provider.countNoLeidos.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(
                          Icons.mail_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text('Mensajes'),
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, HomeMessagesPages.routeName);
                        },
                      ),
                      //  Expanded(child: Text('ddd'))
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.vpn_key_sharp,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('Cambiar contraseña'),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, CambiarClavePages.routeName);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('Cerrar sesion'),
                  onTap: () {
                    PreferenciasUsuario _prefe = new PreferenciasUsuario();

                    _prefe.clear();

                    Navigator.pushReplacementNamed(
                        context, SignInPages.routeName);
                  },
                ),
                Divider(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(30.0),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Image.asset('images/login.png', fit: BoxFit.fill),
          )
        ],
      ),
    );
  }
}
