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
    apiKey: 'AIzaSyAqCqHoXhCPGy6OozjXEnsr6wIJkS6gN5k',
    appId: '1:116999090862:web:591293cb83a931d016f33f',
    messagingSenderId: '116999090862',
    projectId: 'tratourapp',
    authDomain: 'tratourapp.firebaseapp.com',
    storageBucket: 'tratourapp.appspot.com',
    measurementId: 'G-PGSV04HVZ0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAK22ZFHSqKT6kD24e3cBDT717u4HP6h-c',
    appId: '1:116999090862:android:c2cad520368f645616f33f',
    messagingSenderId: '116999090862',
    projectId: 'tratourapp',
    storageBucket: 'tratourapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbYFMA8BLhVBNKUDHlefE8Rl8jYVr4sSo',
    appId: '1:116999090862:ios:27cc9ac0016bf81616f33f',
    messagingSenderId: '116999090862',
    projectId: 'tratourapp',
    storageBucket: 'tratourapp.appspot.com',
    iosBundleId: 'com.example.tratour',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbYFMA8BLhVBNKUDHlefE8Rl8jYVr4sSo',
    appId: '1:116999090862:ios:27cc9ac0016bf81616f33f',
    messagingSenderId: '116999090862',
    projectId: 'tratourapp',
    storageBucket: 'tratourapp.appspot.com',
    iosBundleId: 'com.example.tratour',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAqCqHoXhCPGy6OozjXEnsr6wIJkS6gN5k',
    appId: '1:116999090862:web:38446a763b95110616f33f',
    messagingSenderId: '116999090862',
    projectId: 'tratourapp',
    authDomain: 'tratourapp.firebaseapp.com',
    storageBucket: 'tratourapp.appspot.com',
    measurementId: 'G-8GK5RSGWZE',
  );

}