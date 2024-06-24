
import 'package:food_inventory_app/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/auth_gate.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAaQXWrh9GB_URzb16CpCWxfksd4AXlqHE',
      appId: '1:199999375946:android:26a2a042b174390a4574b3',
      messagingSenderId: '199999375946',
      projectId: 'food-inventory-app-9939e',
      storageBucket: 'food-inventory-app-9939e.appspot.com',
    ),
  );
  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: lightMode,
    );
  }
}