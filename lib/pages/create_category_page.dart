
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/my_textfield.dart';
import '../components/my_button.dart';
import '../constants/icon_list.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({Key? key}) : super(key: key);

  @override
  _CreateCategoryPageState createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  IconData? _selectedIcon; // Nullable IconData
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextField(
                labelText: 'Category Name',
                controller: _nameController,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                }, hintText: '',
              ),
              SizedBox(height: 20),
              Text("Select Icon:"),
              SizedBox(height: 10),
              Wrap(
                children: [
                  for (var icon in availableIcons)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          icon,
                          size: 40,
                          color: _selectedIcon == icon
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                      ),
                    ),
                ],
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
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                if (_selectedIcon == null) {
                  // No icon selected, show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please select an icon"),
                    ),
                  );
                } else {
                  // Icon selected, proceed with category creation
                  String categoryName = _nameController.text.trim();
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final existingCategory = await FirebaseFirestore.instance
                        .collection('categories')
                        .where('name', isEqualTo: categoryName.toLowerCase())
                        .where('userId', isEqualTo: user.uid)
                        .get();

                    if (existingCategory.docs.isNotEmpty) {
                      // Category name already exists
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Category '$categoryName' already exists"),
                        ),
                      );
                    } else {
                      await FirebaseFirestore.instance.collection('categories').add({
                        'name': categoryName,
                        'icon': _selectedIcon!.codePoint, // Use ! to access the non-null IconData
                        'userId': user.uid,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Category created successfully"),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }
}


