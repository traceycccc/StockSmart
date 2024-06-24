// import  'package:flutter/material.dart';
//
// class CategoriesPage extends StatelessWidget {
//   const CategoriesPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Categories")),
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// class CategoriesPage extends StatelessWidget {
//   const CategoriesPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Categories"),
//       ),
//       body: ListView.builder(
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: Icon(categories[index].icon),
//             title: Text(categories[index].name),
//             onTap: () {
//               // Navigate to category details page
//               // You can implement this later
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to create category page
//           // You can implement this later
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// // Dummy data for categories (replace with actual data)
// List<Category> categories = [
//   Category(name: "Dairy", icon: Icons.water_drop),
//   Category(name: "Fruits", icon: Icons.apple_rounded),
//   Category(name: "Vegetables", icon: Icons.eco_rounded),
//   Category(name: "Meat", icon: Icons.restaurant),
// ];
//
// // Model class for Category
// class Category {
//   final String name;
//   final IconData icon;
//
//   Category({required this.name, required this.icon});
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'create_category_page.dart';
//
// class CategoriesPage extends StatelessWidget {
//   const CategoriesPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Categories"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('categories').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           final categories = snapshot.data!.docs.map((doc) {
//             return Category(
//               name: doc['name'],
//               icon: IconData(doc['icon'], fontFamily: 'MaterialIcons'),
//             );
//           }).toList();
//
//           return ListView.builder(
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: Icon(categories[index].icon),
//                 title: Text(categories[index].name),
//                 onTap: () {
//                   // Navigate to category details page
//                   // You can implement this later
//                 },
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CreateCategoryPage(),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// // Model class for Category
// class Category {
//   final String name;
//   final IconData icon;
//
//   Category({required this.name, required this.icon});
// }

//can work before adding edit categories page
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'create_category_page.dart';
//
// class CategoriesPage extends StatelessWidget {
//   const CategoriesPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Categories"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('categories')
//             .where('userId', isEqualTo: user?.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           final categories = snapshot.data!.docs.map((doc) {
//             return Category(
//               id: doc.id,
//               name: doc['name'],
//               icon: IconData(doc['icon'], fontFamily: 'MaterialIcons'),
//             );
//           }).toList();
//
//           if (categories.isEmpty) {
//             return Center(child: Text('No categories available.'));
//           }
//
//           return ListView.builder(
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: Icon(categories[index].icon),
//                 title: Text(categories[index].name),
//                 onTap: () {
//                   // Navigate to category details page
//                   // You can implement this later
//                 },
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CreateCategoryPage(),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// // Model class for Category
// class Category {
//   final String id;
//   final String name;
//   final IconData icon;
//
//   Category({required this.id, required this.name, required this.icon});
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'create_category_page.dart';
// import 'edit_category_page.dart';
//
// class CategoriesPage extends StatelessWidget {
//   const CategoriesPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Categories"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('categories')
//             .where('userId', isEqualTo: user?.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final categories = snapshot.data!.docs.map((doc) {
//             return Category(
//               id: doc.id,
//               name: doc['name'],
//               icon: IconData(doc['icon'], fontFamily: 'MaterialIcons'),
//             );
//           }).toList();
//
//           if (categories.isEmpty) {
//             return const Center(child: Text('No categories available.'));
//           }
//
//           return ListView.builder(
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: Icon(categories[index].icon),
//                 title: Text(categories[index].name),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => EditCategoryPage(category: categories[index]),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const CreateCategoryPage(),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// // Model class for Category
// class Category {
//   final String id;
//   final String name;
//   final IconData icon;
//
//   Category({required this.id, required this.name, required this.icon});
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'create_category_page.dart';
// import 'edit_category_page.dart';
// import '../components/rounded_box_list_tile.dart'; // Import the list component
//
// class CategoriesPage extends StatelessWidget {
//   const CategoriesPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Categories"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('categories')
//               .where('userId', isEqualTo: user?.uid)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             final categories = snapshot.data!.docs.map((doc) {
//               return Category(
//                 id: doc.id,
//                 name: doc['name'],
//                 icon: IconData(doc['icon'], fontFamily: 'MaterialIcons'),
//               );
//             }).toList();
//
//             if (categories.isEmpty) {
//               return Center(child: Text('No categories available.'));
//             }
//
//             return ListView.builder(
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//
//                         builder: (context) => EditCategoryPage(category: categories[index]),
//                       ),
//                     );
//                   },
//                   child: RoundedBoxListTile(
//                     title: categories[index].name,
//                     icon: categories[index].icon,
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CreateCategoryPage(),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// // Model class for Category
// class Category {
//   final String id;
//   final String name;
//   final IconData icon;
//
//   Category({required this.id, required this.name, required this.icon});
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/category.dart';
import 'create_category_page.dart';
import 'edit_category_page.dart';
import '../components/rounded_box_list_tile.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 24.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .where('userId', isEqualTo: user?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final categories = snapshot.data!.docs.map((doc) {
              return Category(
                id: doc.id,
                name: doc['name'],
                icon: IconData(doc['icon'], fontFamily: 'MaterialIcons'),
              );
            }).toList();

            if (categories.isEmpty) {
              return Center(child: Text('No categories available.'));
            }

            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCategoryPage(category: categories[index]),
                      ),
                    );
                  },
                  child: RoundedBoxListTile(
                    title: categories[index].name,
                    icon: categories[index].icon,
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCategoryPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      //drawer: MyDrawer(),
    );
  }
}



