import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Web configuration
    return const FirebaseOptions(
      apiKey: 'AIzaSyCPi_2y1D-i0irV9y5LSdi-wHgs30tS7u0',
      appId: '1:539105617590:web:9f941eaf34b742fbea6817',
      messagingSenderId: '539105617590',
      projectId: 'ctechfinals',
      authDomain: 'ctechfinals.firebaseapp.com',
      storageBucket: 'ctechfinals.firebasestorage.app',
      measurementId: 'G-VRLM3GGPC2',
    );
  }
}
