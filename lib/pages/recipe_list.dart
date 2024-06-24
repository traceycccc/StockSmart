import 'package:flutter/material.dart';

import '../api/recipe_service.dart';
import '../models/recipe.dart';
import 'recipe_detail_page.dart';
import '../components/my_textfield.dart';

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final TextEditingController _controller = TextEditingController();
  late Future<List<Recipe>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = fetchRecipes('chicken');
  }

  void _search() {
    setState(() {
      futureRecipes = fetchRecipes(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      labelText: 'Search Recipe',
                      controller: _controller,
                      obscureText: false,
                      hintText: 'E.g. chicken',
                      suffixWidget: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.primary,

                        ),
                        onPressed: _search,
                      ),


                    ),
                  ),
                  // const SizedBox(width: 10),
                  // IconButton(
                  //   icon: Icon(Icons.search),
                  //   onPressed: _search,
                  // ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Recipe>>(
                future: futureRecipes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final recipe = snapshot.data![index];
                        return ListTile(
                          title: Text(
                            recipe.label,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                            )
                          ),
                          subtitle: Text(
                            recipe.source,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inverseSurface,
                              )
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailPage(recipe: recipe),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../api/recipe_service.dart';
// import '../models/recipe.dart';
// import 'recipe_detail_page.dart';
// import '../components/my_textfield.dart';
// import '../models/food_item.dart';
//
// class RecipeList extends StatefulWidget {
//   @override
//   _RecipeListState createState() => _RecipeListState();
// }
//
// class _RecipeListState extends State<RecipeList> {
//   final TextEditingController _controller = TextEditingController();
//   late Future<List<Recipe>> futureRecipes;
//   List<FoodItem> userFoodItems = [];
//   String? _selectedFoodItem;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserFoodItems();
//   }
//
//   Future<void> _fetchUserFoodItems() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('food_items')
//           .where('userId', isEqualTo: user.uid)
//           .get();
//       setState(() {
//         userFoodItems = snapshot.docs.map((doc) {
//           return FoodItem(
//             id: doc.id,
//             name: doc['name'],
//             categoryId: doc['categoryId'],
//             buyDate: (doc['buyDate'] as Timestamp).toDate(),
//             expiryDate: (doc['expiryDate'] as Timestamp).toDate(),
//           );
//         }).toList();
//       });
//     }
//   }
//
//   void _search() {
//     if (_selectedFoodItem != null) {
//       setState(() {
//         futureRecipes = fetchRecipes(_selectedFoodItem!);
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select an ingredient')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recipes'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                         labelText: 'Select Ingredient',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: _selectedFoodItem,
//                       items: userFoodItems.map((item) {
//                         return DropdownMenuItem<String>(
//                           value: item.name,
//                           child: Text(item.name),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedFoodItem = value;
//                         });
//                       },
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: _search,
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: FutureBuilder<List<Recipe>>(
//                 future: futureRecipes,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         final recipe = snapshot.data![index];
//                         return ListTile(
//                           title: Text(
//                             recipe.label,
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                           subtitle: Text(
//                             recipe.source,
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.inverseSurface,
//                             ),
//                           ),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => RecipeDetailPage(recipe: recipe),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }
//
//                   return Center(child: CircularProgressIndicator());
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
