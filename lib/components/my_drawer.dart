

import 'package:flutter/material.dart';
import 'package:food_inventory_app/pages/recipe_list.dart';
import '../auth/auth_service.dart';
import '../pages/categories_page.dart';
import '../pages/favorites_page.dart';
import '../pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  // Logout function
  void logout(BuildContext context) {
    // Get auth service
    final auth = AuthService();
    auth.signOut();
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.inventory_rounded,
                size: 70,
                color: Colors.deepOrange,
              ),

            ),
          ),
          // List tile
          Column(
            children: [
              // Food Items (Main Page)
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: ListTile(
                  title: const Text("F O O D  I T E M S"),
                  leading: const Icon(Icons.inventory_2_rounded),
                  onTap: () {
                    // Pop the drawer
                    Navigator.pop(context);

                  },
                ),
              ),
              // Categories
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: ListTile(
                  title: const Text("C A T E G O R I E S"),
                  leading: const Icon(Icons.category),
                  onTap: () {
                    // Pop the drawer
                    Navigator.pop(context);
                    // Navigate to the categories page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoriesPage(),
                      ),
                    );
                  },
                ),
              ),
              // Explore Recipes
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: ListTile(
                  title: const Text("R E C I P E S"),
                  leading: const Icon(Icons.book),
                  onTap: () {
                    // Pop the drawer
                    Navigator.pop(context);
                    // Navigate to the profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeList(),
                      ),
                    );
                  },
                ),
              ),
              // Favorites
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: ListTile(
                  title: const Text("F A V O R I T E S"),
                  leading: const Icon(Icons.favorite),
                  onTap: () {
                    // Pop the drawer
                    Navigator.pop(context);
                    // Navigate to the profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesPage(),
                      ),
                    );
                  },
                ),
              ),
              // Profile
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: ListTile(
                  title: const Text("P R O F I L E"),
                  leading: const Icon(Icons.person_3),
                  onTap: () {
                    // Pop the drawer
                    Navigator.pop(context);
                    // Navigate to the profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Logout
          //SizedBox(height: 250),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: const Text("L O G  O U T"),
              leading: const Icon(Icons.logout_rounded),
              onTap: () => logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
