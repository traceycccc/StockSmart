
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/my_button.dart';
import '../models/food_item.dart';
import '../models/category.dart';
import '../components/my_textfield.dart';
import '../components/my_dropdown.dart';
import '../components/date_textfield.dart';
import 'package:intl/intl.dart';

class EditFoodItemPage extends StatefulWidget {
  final FoodItem foodItem;

  const EditFoodItemPage({Key? key, required this.foodItem}) : super(key: key);

  @override
  _EditFoodItemPageState createState() => _EditFoodItemPageState();
}

class _EditFoodItemPageState extends State<EditFoodItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedCategoryId;
  DateTime _buyDate = DateTime.now();
  DateTime _expiryDate = DateTime.now().add(Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.foodItem.name;
    _selectedCategoryId = widget.foodItem.categoryId;
    _buyDate = widget.foodItem.buyDate;
    _expiryDate = widget.foodItem.expiryDate;
  }

  Future<String?> getExistingFoodItemName(String name) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('food_items')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('name', isEqualTo: name.toLowerCase())
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first['name'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Food Item"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _confirmDeleteFoodItem(context), // Call the delete confirmation dialog
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
                controller: _nameController,
                labelText: "Item Name",
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                }, hintText: '',
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  var categories = snapshot.data!.docs.map((doc) {
                    return Category(
                      id: doc.id,
                      name: doc['name'],
                      icon: IconData(doc['icon'], fontFamily: 'MaterialIcons'),
                    );
                  }).toList();

                  return MyDropdown<String>(
                    labelText: 'Category',
                    value: _selectedCategoryId,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              DateTextField(
                labelText: "Buy Date",
                initialDate: _buyDate,
                onDateChanged: (date) {
                  setState(() {
                    _buyDate = date;
                  });
                },
              ),
              SizedBox(height: 20),
              DateTextField(
                labelText: "Expiry Date",
                initialDate: _expiryDate,
                onDateChanged: (date) {
                  setState(() {
                    _expiryDate = date;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 82.0,
        child: Center(
          child: MyButton(
            text: 'Save',
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                String name = _nameController.text.trim().toLowerCase();
                String? existingFoodItem = await getExistingFoodItemName(name);
                if (existingFoodItem != null && existingFoodItem != widget.foodItem.name) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("The food item '$existingFoodItem' already exists")),
                  );
                } else {
                  await FirebaseFirestore.instance
                      .collection('food_items')
                      .doc(widget.foodItem.id)
                      .update({
                    'name': name,
                    'categoryId': _selectedCategoryId,
                    'buyDate': _buyDate,
                    'expiryDate': _expiryDate,
                  });
                  Navigator.pop(context);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteFoodItem(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this food item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Delete food item
                await FirebaseFirestore.instance
                    .collection('food_items')
                    .doc(widget.foodItem.id)
                    .delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Food item deleted successfully!"),
                  ),
                );
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the edit food item page
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
