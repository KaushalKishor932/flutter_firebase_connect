import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<String?> getToken() async {
    await _messaging.requestPermission();
    return await _messaging.getToken();
  }
}
