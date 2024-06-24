
import 'package:flutter/material.dart';

class RoundedBoxListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle; // Add subtitle property

  const RoundedBoxListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.subtitle, // Initialize subtitle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF739D84).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold, // Make title bold
            fontSize: 16.0, // Adjust font size
          ),
        ),subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(color: Theme.of(context).colorScheme.primary)) : null, // Display subtitle if provided
      ),
    );
  }
}


