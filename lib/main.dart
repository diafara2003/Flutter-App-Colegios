import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/message.dart';
import 'models/person.dart';
import 'pages/home/start_up_pages.dart';
import 'pages/message/chat_pages.dart';
import 'providers/Models/destinatarios_provider.dart';
import 'providers/Models/login_provider.dart';
import 'providers/Models/message_provider.dart';
import 'providers/Session/preferencias_provider.dart';
import 'providers/routes/routes.dart';
import 'services/message/messaje_services.dart';
import 'services/push/push_notificacions_services.dart';

void main() async {
//check version

  WidgetsFlutterBinding.ensureInitialized();

  await PushNotificacionService.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DestinatariosProvider>(
        create: (context) => DestinatariosProvider()),
    ChangeNotifierProvider<MessageProvider>(
        create: (context) => MessageProvider()),
    ChangeNotifierProvider<LoggedProvider>(
        create: (context) => LoggedProvider())
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
//  final VersionStatus _statusApp;

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      new GlobalKey<ScaffoldMessengerState>();

  _updateMessage() async {
    PreferenciasUsuario _prefe = new PreferenciasUsuario();

    Map<String, dynamic> _user = _prefe.usuario;

    Usuario currentUser = Usuario.fromJson(_user);

    List<MessageDTO> _msn =
        await new MessageServices().getMessages(0, currentUser.perId!);

    List<MessageModelProvider> _lst = MessageModelProvider.map(_msn);

    final messageProv = Provider.of<MessageProvider>(context, listen: false);

    messageProv.messages = _lst;
    MessageModelProvider _message = _lst.firstWhere(
        (element) => element.id == PushNotificacionService.idMensaje);

    navigatorKey.currentState?.push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChatPages(
          message: _message,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //new CheckVersionApp().statusCheck().then((value) {
    // if (value.canUpdate)
    //   navigatorKey.currentState
    //       ?.pushNamed(UpdateAppPages.routeName, arguments: value);
    // });

    final snackbar = MaterialBanner(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 0.0),
      leading: new Tab(
          icon: new Image.asset(
        "images/icon/logo.png",
        width: 44,
        height: 44,
      )),
      content: Text(
        "Llego un nuevo mensaje!!!",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
      ),
      elevation: 10.0,
      actions: [
        TextButton(
          onPressed: () {
            scaffoldKey.currentState?.hideCurrentMaterialBanner();
            _updateMessage();
          },
          child: Text('Ver'),
        ),
        TextButton(
          onPressed: () {
            scaffoldKey.currentState?.hideCurrentMaterialBanner();
          },
          child: Text('Ocultar'),
        )
      ],
    );

    // LocalNotificacionServices.initialize(context);

    PushNotificacionService.messageStream.listen((message) {
      print('main $message');

      if (PushNotificacionService.showBanner) {
        scaffoldKey.currentState?.showMaterialBanner(snackbar);
        new Future.delayed(const Duration(seconds: 5), () {
          scaffoldKey.currentState?.hideCurrentMaterialBanner();
        });
      } else
        _updateMessage();
      PushNotificacionService.showBanner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comunicate CC',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldKey,
      // theme: MyTheme.lighttheme,
      // themeMode: ThemeMode.system,
      // darkTheme: MyTheme.darktheme,
      home: StartUpPages(),

      routes: routesApp,
      debugShowCheckedModeBanner: false,
    );
  }
}
