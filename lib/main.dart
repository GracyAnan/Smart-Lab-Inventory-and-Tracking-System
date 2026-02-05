import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'login_page.dart';
import 'signup_page.dart';
import 'dashboard_page.dart';
import 'borrowed_items_page.dart';
import 'alerts_page.dart';
import 'logs_page.dart';
import 'students_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Safe Firebase initialization with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    // If Firebase initialization fails, show a simple error UI
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            '⚠️ Firebase initialization failed:\n$e',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Lab Inventory',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
        ),
      ),

      // ✅ Start with login (or auto-navigate later if logged in)
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/borrowed': (context) => const BorrowedItemsPage(),
        '/alerts': (context) => const AlertsPage(),
        '/logs': (context) => const LogsPage(),
      },
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          "$title Page",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
