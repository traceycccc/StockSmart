
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/my_button.dart';
import '../models/category.dart';
import '../components/my_dropdown.dart';
import '../components/my_textfield.dart';
import '../components/date_textfield.dart';

class CreateFoodItemPage extends StatefulWidget {
  const CreateFoodItemPage({Key? key}) : super(key: key);

  @override
  _CreateFoodItemPageState createState() => _CreateFoodItemPageState();
}

class _CreateFoodItemPageState extends State<CreateFoodItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedCategoryId;
  DateTime _buyDate = DateTime.now();
  DateTime _expiryDate = DateTime.now().add(Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Food Item"),
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
                hintText: "geuydw",
                labelText: "Item Name",
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
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
                if (existingFoodItem != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("The food item '$existingFoodItem' already exists")),
                  );
                } else {
                  await FirebaseFirestore.instance.collection('food_items').add({
                    'userId': FirebaseAuth.instance.currentUser?.uid,
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

  Future<String?> getExistingFoodItemName(String name) async {
    // Query existing food items for the current user
    var snapshot = await FirebaseFirestore.instance
        .collection('food_items')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('name', isEqualTo: name)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first['name'];
    }
    return null;
  }
}
