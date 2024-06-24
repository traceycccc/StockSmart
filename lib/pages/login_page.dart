
import 'package:flutter/material.dart';
import 'package:food_inventory_app/components/my_button.dart';
import 'package:food_inventory_app/components/my_textfield.dart';
import 'package:food_inventory_app/components/password_textfield.dart';
import '../auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Email and password text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // Login method
  void login(BuildContext context) async {
    final authService = AuthService();

    if (_formKey.currentState!.validate()) {
      try {
        await authService.signInWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged In successfully'),
          ),
        );
      } catch (e) {
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text(e.toString()),
        //   ),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password, try again!'),
          ),
        );
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Icon(
                    Icons.inventory_rounded,
                    size: 100,
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(height: 50),
                  // Welcome back message
                  Text(
                    "Welcome to StockSmart!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Email textfield
                  MyTextField(
                    labelText: 'Email',
                    obscureText: false,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      final emailRegExp = RegExp(
                        r'^[^@]+@[^@]+\.[^@]+',
                      );
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    }, hintText: '',
                  ),
                  const SizedBox(height: 10),
                  // Password textfield
                  PasswordTextField(
                    labelText: 'Password',
                    controller: _pwController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  // Login button
                  MyButton(
                    text: "Log In",
                    onTap: () => login(context),
                  ),
                  const SizedBox(height: 25),
                  // Register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New User? ",
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Register now!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

