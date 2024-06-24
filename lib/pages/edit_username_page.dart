
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_inventory_app/components/my_textfield.dart';
import 'package:food_inventory_app/components/my_button.dart';

class EditUsernamePage extends StatefulWidget {
  const EditUsernamePage({Key? key}) : super(key: key);

  @override
  _EditUsernamePageState createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Fetch the current user's display name and set it in the text field
    User? user = FirebaseAuth.instance.currentUser;
    _usernameController.text = user?.displayName ?? '';
  }

  Future<bool> _isUsernameUnique(String username) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('displayName', isEqualTo: username)
          .limit(1)
          .get();
      return result.docs.isEmpty;
    } catch (e) {
      print('Error checking username uniqueness: $e');
      return false;
    }
  }

  Future<void> _saveUsername() async {
    if (_formKey.currentState!.validate()) {
      String newUsername = _usernameController.text.trim();
      bool isUnique = await _isUsernameUnique(newUsername);

      if (isUnique) {
        try {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await user.updateDisplayName(newUsername);
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'displayName': newUsername});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Updated username successfully!"),
              ),
            );
            Navigator.pop(context, _usernameController.text);

          }
        } catch (e) {
          print('Error saving username: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to update username"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Username '$newUsername' is already taken"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Username"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your new username:",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              MyTextField(
                labelText: 'New Username',
                obscureText: false,
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new username';
                  }
                  return null;
                }, hintText: '',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 82.0, // Adjust this value as needed
        child: Center(
          child: MyButton(
            text: 'Save',
            onTap: _saveUsername,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
