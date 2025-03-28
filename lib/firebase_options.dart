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
    apiKey: 'AIzaSyBOdBA2oLohJnNu6wDPBKhminHXCWc88o0',
    appId: '1:494330343840:web:d145a352c1c1b4e1a4b4c5',
    messagingSenderId: '494330343840',
    projectId: 'subjects-14749',
    authDomain: 'subjects-14749.firebaseapp.com',
    storageBucket: 'subjects-14749.firebasestorage.app',
    measurementId: 'G-334DBHYFVZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYfs6Rs6-o64enzAcNfLgJGnfSbQqMqUw',
    appId: '1:494330343840:android:ab491f6f38dc04e9a4b4c5',
    messagingSenderId: '494330343840',
    projectId: 'subjects-14749',
    storageBucket: 'subjects-14749.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOKzUTA_EwcjlInusWCZuJEAPftniOnTA',
    appId: '1:494330343840:ios:61771cc45683172aa4b4c5',
    messagingSenderId: '494330343840',
    projectId: 'subjects-14749',
    storageBucket: 'subjects-14749.firebasestorage.app',
    iosBundleId: 'com.example.aabbb',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOKzUTA_EwcjlInusWCZuJEAPftniOnTA',
    appId: '1:494330343840:ios:61771cc45683172aa4b4c5',
    messagingSenderId: '494330343840',
    projectId: 'subjects-14749',
    storageBucket: 'subjects-14749.firebasestorage.app',
    iosBundleId: 'com.example.aabbb',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBOdBA2oLohJnNu6wDPBKhminHXCWc88o0',
    appId: '1:494330343840:web:405841b5b7c1af64a4b4c5',
    messagingSenderId: '494330343840',
    projectId: 'subjects-14749',
    authDomain: 'subjects-14749.firebaseapp.com',
    storageBucket: 'subjects-14749.firebasestorage.app',
    measurementId: 'G-H2579EHNTV',
  );
}
