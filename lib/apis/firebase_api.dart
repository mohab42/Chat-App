import 'package:backend/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../main.dart';

class FirebaseApi {
  final firebaseMesseging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMesseging.requestPermission();
    final fcmToken = await firebaseMesseging.getToken();
    print('Token: $fcmToken');
    initPushNotifies();
  }

  Future<void> handelBackGroundMessege(RemoteMessage message) async {
    print('Title: ${message.notification!.title}');
    print('Body: ${message.notification!.body}');
    print('Payload: ${message.data}');
  }

  Future initPushNotifies() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void handleMessege(RemoteMessage? message) {
    if (message == null) return;

    navKey.currentState!.pushNamed(
      NotificationScreen.route,
      arguments: message,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessege);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessege);
    FirebaseMessaging.onBackgroundMessage(handelBackGroundMessege);
  }
}
