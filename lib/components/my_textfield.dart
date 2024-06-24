

import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final Widget? suffixWidget;
  final String? Function(String?)? validator;
  final String hintText;

  const MyTextField({
    Key? key,
    required this.labelText,
    required this.obscureText,
    required this.controller,
    this.suffixWidget,
    this.validator,
    required this.hintText,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextFormField(
        obscureText: widget.obscureText,
        controller: widget.controller,
        validator: widget.validator,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          suffixIcon: widget.suffixWidget,
          errorStyle: TextStyle(color: Colors.red), // Customize error text style
        ),
      ),
    );
  }
}
