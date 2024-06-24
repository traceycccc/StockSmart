import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/my_textfield.dart';

class DateTextField extends StatelessWidget {
  final String labelText;
  final DateTime initialDate;
  final Function(DateTime) onDateChanged;

  const DateTextField({
    Key? key,
    required this.labelText,
    required this.initialDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      labelText: labelText,
      controller: TextEditingController(text: DateFormat.yMd().format(initialDate)),
      obscureText: false,
      suffixWidget: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null && pickedDate != initialDate) {
            onDateChanged(pickedDate);
          }
        },
        child: Icon(
          Icons.calendar_today,
          color: Theme.of(context).colorScheme.primary,
        ),
      ), hintText: '',
    );
  }
}
