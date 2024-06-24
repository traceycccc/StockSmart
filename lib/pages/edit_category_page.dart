
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/my_textfield.dart';
import '../components/my_button.dart';
import '../models/category.dart';
import '../constants/icon_list.dart';

class EditCategoryPage extends StatefulWidget {
  final Category category;

  const EditCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late TextEditingController _nameController;
  IconData? _selectedIcon; // Nullable IconData
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _selectedIcon = widget.category.icon;
  }

  Future<void> _confirmDeleteCategory(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this category?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Delete category
                await FirebaseFirestore.instance
                    .collection('categories')
                    .doc(widget.category.id)
                    .delete();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Category deleted successfully!"),
                    ));
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the edit category page
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDeleteCategory(context), // Call the delete confirmation dialog
          ),
        ],
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
                  // Icon selected, proceed with category update
                  String categoryName = _nameController.text.trim();
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final existingCategory = await FirebaseFirestore.instance
                        .collection('categories')
                        .where('name', isEqualTo: categoryName.toLowerCase())
                        .where('userId', isEqualTo: user.uid)
                        .get();

                    if (existingCategory.docs.isNotEmpty &&
                        existingCategory.docs.first.id != widget.category.id) {
                      // Category name already exists and it's not the current category
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Category '$categoryName' already exists"),
                        ),
                      );
                    } else {
                      await FirebaseFirestore.instance
                          .collection('categories')
                          .doc(widget.category.id)
                          .update({
                        'name': categoryName,
                        'icon': _selectedIcon!.codePoint,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Category updated successfully"),
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

