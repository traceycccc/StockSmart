
import 'package:flutter/material.dart';
import 'package:food_inventory_app/components/my_button.dart';
import 'package:food_inventory_app/components/my_textfield.dart';
import 'package:food_inventory_app/components/password_textfield.dart';
import '../auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  // Email, password, and username text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  // Tap to go to register page
  final void Function()? onTap;

  RegisterPage({Key? key, required this.onTap}) : super(key: key);

  // Register method
  void register(BuildContext context) async {
    final _auth = AuthService();

    if (_pwController.text == _confirmPwController.text) {
      try {
        await _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
          _userNameController.text, // Pass the username to the sign-up method
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                  // Welcome message
                  Text(
                    "Let's create a new account for you!",
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
                  // Username textfield
                  MyTextField(
                    labelText: 'Username',
                    obscureText: false,
                    controller: _userNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
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
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      // Check for at least one uppercase letter
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      // Check for at least one lowercase letter
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'Password must contain at least one lowercase letter';
                      }
                      // Check for at least one special character
                      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return 'Password must contain at least one special character';
                      }
                      // Check for at least one digit
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Password must contain at least one digit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Confirm password textfield
                  PasswordTextField(
                    labelText: 'Confirm Password',
                    controller: _confirmPwController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _pwController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  // Register button
                  MyButton(
                    text: "Register",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        register(context);
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  // Already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: Text(
                          "Log In!",
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
