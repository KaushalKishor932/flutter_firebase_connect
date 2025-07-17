import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final _remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    await _remoteConfig.setDefaults({
      "welcome_message": "Welcome to SocialBuzz!"
    });

    await _remoteConfig.fetchAndActivate();
  }

  static String get welcomeMessage =>
      _remoteConfig.getString("welcome_message");
}
