

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/edit_username_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // User profile information
            // Text(
            //   "User Profile",
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            //SizedBox(height: 20),
            // Username section
            ListTile(
              title: Text(
                "Username",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(_user.displayName ?? ""),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  final updatedUsername = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditUsernamePage()),
                  );
                  // Update the username if it's not null
                  if (updatedUsername != null) {
                    setState(() {
                      _user.updateDisplayName(updatedUsername);
                    });
                  }
                },
              ),
            ),
            Divider(),
            // Email section
            ListTile(
              title: Text(
                "Email",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(_user.email ?? ""),
            ),
            Divider(),
            // Add other user information here if needed
          ],
        ),
      ),
    );
  }
}
