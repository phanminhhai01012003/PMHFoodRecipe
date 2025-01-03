// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCl4_uuUU8bgjXomTjoD_oge2T2VQt3RAU',
    appId: '1:410001911097:web:8b5fefae63bc2f4c9dcce8',
    messagingSenderId: '410001911097',
    projectId: 'foodapp-bd5b0',
    authDomain: 'foodapp-bd5b0.firebaseapp.com',
    storageBucket: 'foodapp-bd5b0.appspot.com',
    measurementId: 'G-NVS17EZ7WS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcHBreFWvuWYDOIJUG-E1ZwRHh73qQhLs',
    appId: '1:410001911097:android:dbb9aaa0566e823b9dcce8',
    messagingSenderId: '410001911097',
    projectId: 'foodapp-bd5b0',
    storageBucket: 'foodapp-bd5b0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABm_I7PJisBx1A9A_I5yWiylsQlAIl42I',
    appId: '1:410001911097:ios:dcb6c31a9775bac99dcce8',
    messagingSenderId: '410001911097',
    projectId: 'foodapp-bd5b0',
    storageBucket: 'foodapp-bd5b0.appspot.com',
    iosBundleId: 'com.example.pmhfoodrecipe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyABm_I7PJisBx1A9A_I5yWiylsQlAIl42I',
    appId: '1:410001911097:ios:dcb6c31a9775bac99dcce8',
    messagingSenderId: '410001911097',
    projectId: 'foodapp-bd5b0',
    storageBucket: 'foodapp-bd5b0.appspot.com',
    iosBundleId: 'com.example.pmhfoodrecipe',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCl4_uuUU8bgjXomTjoD_oge2T2VQt3RAU',
    appId: '1:410001911097:web:22b864a2db62cbc69dcce8',
    messagingSenderId: '410001911097',
    projectId: 'foodapp-bd5b0',
    authDomain: 'foodapp-bd5b0.firebaseapp.com',
    storageBucket: 'foodapp-bd5b0.appspot.com',
    measurementId: 'G-S2BM2CZY6D',
  );
}
