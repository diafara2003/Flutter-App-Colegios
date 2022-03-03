import 'package:autraliano/pages/home/start_up_pages.dart';
import 'package:autraliano/pages/home/update_app_pages.dart';
import 'package:autraliano/pages/login/cambiar_clave_pages.dart';
import 'package:autraliano/pages/login/signin_pages.dart';
import 'package:autraliano/pages/message/chat_pages.dart';
import 'package:autraliano/pages/message/home_message_pages.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> routesApp = {
  StartUpPages.routeName: (BuildContext context) => StartUpPages(),
  SignInPages.routeName: (BuildContext context) => SignInPages(),
  HomeMessagesPages.routeName: (BuildContext context) => HomeMessagesPages(),
  UpdateAppPages.routeName: (BuildContext context) => UpdateAppPages(),
  ChatPages.routeName: (BuildContext context) => ChatPages(),
  CambiarClavePages.routeName: (BuildContext context) => CambiarClavePages(),
};
