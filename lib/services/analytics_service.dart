import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final _analytics = FirebaseAnalytics.instance;

  static Future<void> logView(String screenName) async {
    await _analytics.logEvent(
      name: "view_screen",
      parameters: {"screen": screenName},
    );
  }
}
