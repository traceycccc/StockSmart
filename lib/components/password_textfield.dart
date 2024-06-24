
import 'package:flutter/material.dart';
import 'my_textfield.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;

  const PasswordTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      labelText: widget.labelText,
      obscureText: _obscureText,
      controller: widget.controller,
      validator: widget.validator,
      suffixWidget: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ), hintText: '',
    );
  }
}

