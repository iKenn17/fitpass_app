import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCBtG6wdYb9yxJ2TID5nDDSUO5UclTUkc4',
      appId: '1:749564370972:android:317aa7f53a46a0f8a27fd9',
      messagingSenderId: '749564370972',
      projectId: 'fitpass-app-3f52e',
      storageBucket: 'fitpass-app-3f52e.firebasestorage.app',
    ),
  );

  runApp(const FitPassApp());
}

class FitPassApp extends StatelessWidget {
  const FitPassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitPass',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}
