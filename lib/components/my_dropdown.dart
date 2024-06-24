import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class MyDropdown<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  const MyDropdown({
    Key? key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: DropdownButtonFormField2<T>(
        value: value,
        items: items,
        onChanged: onChanged,
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
          labelText: labelText,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          errorStyle: TextStyle(color: Colors.red),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
        validator: (value) => validator!(value), // Call the provided validator function
      ),
    );
  }
}
