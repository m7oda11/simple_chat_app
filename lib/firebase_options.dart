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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDhNfmbpvr-HOTVSkwhSSdDisAcKpSJhAE',
    appId: '1:435276204404:web:51ac5a1c12af92ddcc4421',
    messagingSenderId: '435276204404',
    projectId: 'educatly-task',
    authDomain: 'educatly-task.firebaseapp.com',
    storageBucket: 'educatly-task.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZZyv8lr8ioNxT6ALDuCpBqRfefkc7DBM',
    appId: '1:435276204404:android:825ffc8de4c025b0cc4421',
    messagingSenderId: '435276204404',
    projectId: 'educatly-task',
    storageBucket: 'educatly-task.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4LJ8OgMBpfOMptR6BNG7fD8DJt3qyS40',
    appId: '1:435276204404:ios:ecad2d6b2fd746bdcc4421',
    messagingSenderId: '435276204404',
    projectId: 'educatly-task',
    storageBucket: 'educatly-task.appspot.com',
    iosBundleId: 'com.example.educatlyTask',
  );
}
