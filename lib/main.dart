import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pmhfoodrecipe/Provider/history_provider.dart';
import 'package:pmhfoodrecipe/Provider/save_provider.dart';
import 'package:pmhfoodrecipe/View/MainMenu/mainmenu.dart';
import 'package:pmhfoodrecipe/View/MainMenu/notification_item.dart';
import 'package:pmhfoodrecipe/View/splashscreen.dart';
import 'package:pmhfoodrecipe/firebase_options.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SaveProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider())
      ],
      child: MaterialApp(
        title: 'PMH Food Recipe',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade400),
          useMaterial3: true,
        ),
        home: _auth.currentUser != null ? MainMenu() : SplashScreen(),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        routes: {
          '/notification_item': (context) => NotificationItem()
        },
      ),
    );
  }
}

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print("Token: $token");
    initPushNotifications();
  }
  void handleMessage(RemoteMessage? message){
    if (message == null){
      return;
    }else{
      navigatorKey.currentState?.pushNamed('/notification_item', arguments: message);
    }
  }
  Future initPushNotifications() async{
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      if (message.notification != null){
        _saveNotification(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
  Future<void> _saveNotification(RemoteMessage message) async{
    await FirebaseFirestore.instance.collection("notifications").add({
      "title": message.notification?.title,
      "body": message.notification?.body,
      "timestamp": Timestamp.now()
    });
  }
}