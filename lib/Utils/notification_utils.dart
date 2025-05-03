import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:spires_app/Utils/shared_prefs.dart';

class NotificationUtils {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Get FCM token and save it to shared preferences
  static Future<String> getFcmToken() async {
    // Get the token
    String? token = await _firebaseMessaging.getToken();
    
    if (token != null) {
      // Save the token to shared preferences
      await SharedPrefs.saveFcmToken(token);
      print('FCM Token: $token');
      return token;
    } else {
      print('Failed to get FCM token');
      return '';
    }
  }

  // Configure FCM listeners for foreground messages
  static void configureFirebaseMessaging() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Handle token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      SharedPrefs.saveFcmToken(token);
      print('FCM Token refreshed: $token');
    });
  }
} 