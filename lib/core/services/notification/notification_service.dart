import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future init() async {
    // Permission (Android 13+)
    await _messaging.requestPermission(sound: true, badge: true, alert: true);

    // Get token
    String? token = await _messaging.getToken();
    print("FCM Token: $token");

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Message: ${message.notification?.title}");
    });
  }
}
