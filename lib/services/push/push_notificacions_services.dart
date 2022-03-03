//sha-1 4C:43:1B:AB:F6:3B:D4:52:4D:0F:1F:FD:DB:84:92:B0:13:12:00:AC
//p8 Key ID:U96GA292JH
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificacionService {
  static FirebaseMessaging messaing = FirebaseMessaging.instance;

  static String token = "";
  static int idMensaje = 0;
  static bool showBanner = false;
  static StreamController<String> _messageStream =
      new StreamController.broadcast();

  static Stream<String> get messageStream => _messageStream.stream;

  static closeStreams() {
    _messageStream.close();
  }

  static void _displayNotificacionChannel(RemoteMessage message) {
    if (message.data["mensaje"] != null)
      idMensaje = int.parse(message.data['mensaje']);

    _messageStream.add(message.data["mensaje"] ?? '');
    // LocalNotificacionServices.display(message);
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    showBanner = false;
    _displayNotificacionChannel(message);
  }

  static Future<void> _onMessagedHandler(RemoteMessage message) async {
    showBanner = true;
    _displayNotificacionChannel(message);
  }

  static Future<void> _onMessageOpenApp(RemoteMessage message) async {
    showBanner = false;
    _displayNotificacionChannel(message);
  }

  static requestPermission() async {
    NotificationSettings _settings = await messaing.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print("status ${_settings.authorizationStatus}");
  }

  static Future initializeApp() async {
//push notificacions

    await Firebase.initializeApp();

    await requestPermission();

    token = await FirebaseMessaging.instance.getToken() ?? '';

    print('token: $token');

    //handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessagedHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((value) => _onMessageOpenApp(value!));

//local notificacions
  }
}
