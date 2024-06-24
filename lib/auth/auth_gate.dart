import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_inventory_app/auth/login_or_register.dart';
import 'package:food_inventory_app/pages/food_item_page.dart';

//check if user is logged in or not
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return const FoodItemsPage();
          }
          //user is NOT logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),

    );
  }
}
