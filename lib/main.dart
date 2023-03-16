import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_demo/helper/DatabaseHelper.dart';
import 'package:firebase_demo/screen/EditPage.dart';
import 'package:firebase_demo/screen/homePage.dart';
import 'package:firebase_demo/screen/signInScreen.dart';
import 'package:firebase_demo/utils/global.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "My_Channel",
    "Notification Chennel",
    description: "Thsi Channel Is Used For Important notification",
    importance: Importance.max
);

final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//
//   print("Handling a background message: ${message.messageId}");
// }


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification!;
    AndroidNotification? android = notification.android;
    if(notification != null || android != null){
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        "${notification.title} Hello",
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.high,
            playSound: true,
            icon: "@mipmap/ic_launcher",
          ),
        ),
      );
    }
  });
  runApp(
    MaterialApp(
      routes: {
        '/' : (context) => const MyApp(),
        'signIn' : (context) => const SignIn(),
        'home' : (context) => const HomePage(),
        'edit' : (context) => const EditPage()
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return HomePage();
          }
          else{
            return SignIn();
          }
        },
      ),
    );
  }
}


