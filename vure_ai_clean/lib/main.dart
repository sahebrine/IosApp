import 'package:flutter/material.dart';
import 'package:vure_dashboard/services/api_client.dart';
import 'screens/login_screen.dart';

void main() {
  ApiClient.init();
  runApp(const VureApp());
}

class VureApp extends StatelessWidget {
  const VureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Vure Ai Dashboard",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F1E),
        dialogBackgroundColor: const Color(0xFF111829),
        primaryColor: const Color(0xFF6C5CE7),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
