import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/firebase_options.dart';
import 'package:spires_app/Utils/notification_utils.dart';

// Initialize Firebase Messaging background handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Initialize FCM
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Request notification permissions
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } else {
      Firebase.app(); // If already initialized, use the existing one
    }
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue with the app regardless of Firebase initialization error
  }
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configure Firebase Messaging
    NotificationUtils.configureFirebaseMessaging();
    
    return GetMaterialApp(
      theme: myTheme(),
      title: appName,
      debugShowCheckedModeBanner: false,
      home: autoLoginSystem(),
      // home: const ProgramsScreen(),
    );
  }

  FutureBuilder<bool> autoLoginSystem() {
    return FutureBuilder(
      future: SharedPrefs.autoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.data == true) {
            return const SplashScreen();
          } else {
            return const WelcomeScreen();
          }
        }
      },
    );
  }

  ThemeData myTheme() {
    return ThemeData(
      primarySwatch: mycolor,
      visualDensity: VisualDensity.standard,
      scaffoldBackgroundColor: bgColor,
      primaryColor: primaryColor,
      appBarTheme: const AppBarTheme(
        elevation: 1,
        centerTitle: true,
        backgroundColor: whiteColor,
        foregroundColor: blackColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          elevation: 0,
          shape: const StadiumBorder(),
          maximumSize: const Size(double.infinity, 45),
          minimumSize: const Size(double.infinity, 45),
        ),
      ),
      checkboxTheme: const CheckboxThemeData(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      inputDecorationTheme: InputDecorationTheme(
          iconColor: primaryColor,
          fillColor: whiteColor,
          filled: true,
          hintStyle: smallLightText,
          prefixIconColor: primaryColor,
          contentPadding: const EdgeInsets.all(defaultPadding),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: primaryColor),
          )),
    );
  }
}
