
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/food_item.dart';
import 'create_food_item_page.dart';
import '../pages/edit_food_page.dart';
import '../components/rounded_box_list_tile.dart';
import 'package:food_inventory_app/components/my_drawer.dart';
import '../models/category.dart';

class FoodItemsPage extends StatefulWidget {
  const FoodItemsPage({Key? key}) : super(key: key);

  @override
  _FoodItemsPageState createState() => _FoodItemsPageState();
}

class _FoodItemsPageState extends State<FoodItemsPage> {
  String? selectedCategoryId;

  // Function to get the category icon
  Future<IconData> getCategoryIcon(String categoryId) async {
    final categoryDoc = await FirebaseFirestore.instance.collection('categories').doc(categoryId).get();
    if (categoryDoc.exists) {
      return IconData(categoryDoc['icon'], fontFamily: 'MaterialIcons');
    } else {
      return Icons.fastfood; // Default icon if category is not found
    }
  }

  // Function to get the list of categories
  // Future<List<Category>> getCategories() async {
  //   final snapshot = await FirebaseFirestore.instance.collection('categories').get();
  //   return snapshot.docs.map((doc) => Category(
  //     id: doc.id,
  //     name: doc['name'],
  //     icon: IconData(doc['icon'], fontFamily: 'MaterialIcons'),
  //   )).toList();
  // }

  Future<List<Category>> getCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle case where user is not logged in (though ideally, user should always be logged in here)
      return [];
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('userId', isEqualTo: user.uid) // Filter by userId to get categories created by the current user
        .get();

    return snapshot.docs.map((doc) => Category(
      id: doc.id,
      name: doc['name'],
      icon: IconData(doc['icon'], fontFamily: 'MaterialIcons'),
    )).toList();
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Food Items"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Column(
          children: [
            // Filter bar
            FutureBuilder<List<Category>>(
              future: getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final categories = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedCategoryId = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedCategoryId == null
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                          ),
                          child: Text("All", style: TextStyle(color: selectedCategoryId == null ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary)),
                        ),
                      ),
                      ...categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedCategoryId = category.id;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedCategoryId == category.id
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                            ),
                            child: Text(category.name,style: TextStyle(color: selectedCategoryId == category.id ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary)),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            // Food items list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('food_items')
                    .where('userId', isEqualTo: user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final foodItems = snapshot.data!.docs.map((doc) {
                    return FoodItem(
                      id: doc.id,
                      name: doc['name'],
                      categoryId: doc['categoryId'],
                      buyDate: (doc['buyDate'] as Timestamp).toDate(),
                      expiryDate: (doc['expiryDate'] as Timestamp).toDate(),
                    );
                  }).toList();

                  // Filter food items by selected category
                  final filteredFoodItems = selectedCategoryId == null
                      ? foodItems
                      : foodItems.where((item) => item.categoryId == selectedCategoryId).toList();

                  if (filteredFoodItems.isEmpty) {
                    return Center(child: Text('No food items available.'));
                  }

                  // Sort food items by expiry date
                  filteredFoodItems.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

                  return ListView.builder(
                    itemCount: filteredFoodItems.length,
                    itemBuilder: (context, index) {
                      final foodItem = filteredFoodItems[index];
                      return FutureBuilder<IconData>(
                        future: getCategoryIcon(foodItem.categoryId),
                        builder: (context, iconSnapshot) {
                          if (iconSnapshot.connectionState == ConnectionState.waiting) {
                            return ListTile(
                              title: Text(foodItem.name),
                              leading: CircularProgressIndicator(),
                            );
                          }
                          if (iconSnapshot.hasError) {
                            return ListTile(
                              title: Text(foodItem.name),
                              leading: Icon(Icons.error),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditFoodItemPage(
                                    foodItem: filteredFoodItems[index],
                                  ),
                                ),
                              );
                            },
                            child: RoundedBoxListTile(
                              title: foodItem.name,
                              icon: iconSnapshot.data ?? Icons.fastfood,
                              subtitle: 'Expiry Date: ${DateFormat.yMd().format(foodItem.expiryDate)}',
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateFoodItemPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      drawer: MyDrawer(),
    );
  }
}
