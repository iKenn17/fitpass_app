import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'pages/login.dart';
import 'pages/dashboard.dart';
import 'pages/checkins.dart' as checkins;
import 'pages/members.dart' as members;
import 'pages/manual_time.dart' as manual_time;
import 'pages/notifications.dart';
import 'pages/scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FitpassApp());
}

class FitpassApp extends StatelessWidget {
  const FitpassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FITPASS GYM',

      initialRoute: '/login',

      routes: {
        '/login': (context) => LoginPage(),

        '/dashboard': (context) => DashboardPage(),

        '/checkins': (context) => checkins.CheckInsPage(),

        '/members': (context) => members.MembersPage(),

        '/manual-time': (context) => manual_time.ManualTimePage(),

        '/notifications': (context) => NotificationsPage(),

        '/scanner': (context) => ScannerPage(),
      },
    );
  }
}
