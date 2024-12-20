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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAnI4OUWI46_NW8LMGSsBDPuFuBo_H1atA',
    appId: '1:59613272521:web:267c8a47758a86ec98f018',
    messagingSenderId: '59613272521',
    projectId: 'taruma-cash',
    authDomain: 'taruma-cash.firebaseapp.com',
    storageBucket: 'taruma-cash.firebasestorage.app',
    measurementId: 'G-GKQJ60QH72',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDvOTeTTNQ8jTwrVvGX-Ed270AULNcQoks',
    appId: '1:59613272521:android:b7f7a90c86846f2c98f018',
    messagingSenderId: '59613272521',
    projectId: 'taruma-cash',
    storageBucket: 'taruma-cash.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAL-zk7IzVJgj1iwkoDNKFIEgmt_GUMYgk',
    appId: '1:59613272521:ios:9ba0bb7aa7a301d698f018',
    messagingSenderId: '59613272521',
    projectId: 'taruma-cash',
    storageBucket: 'taruma-cash.firebasestorage.app',
    androidClientId: '59613272521-f21ubkmisp3259rj7qq4e6q2n0sgh61q.apps.googleusercontent.com',
    iosClientId: '59613272521-h73dvpqujop8ti3apcukiuneiu508aqh.apps.googleusercontent.com',
    iosBundleId: 'com.example.fintar',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAnI4OUWI46_NW8LMGSsBDPuFuBo_H1atA',
    appId: '1:59613272521:web:330a96ec4e42413298f018',
    messagingSenderId: '59613272521',
    projectId: 'taruma-cash',
    authDomain: 'taruma-cash.firebaseapp.com',
    storageBucket: 'taruma-cash.firebasestorage.app',
    measurementId: 'G-46NR4PZJ11',
  );
}
