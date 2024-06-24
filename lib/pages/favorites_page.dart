

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';
import 'favorite_recipe_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Future<List<Recipe>> fetchFavoriteRecipes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .get();

    return snapshot.docs.map((doc) {
      return Recipe(
        label: doc['label'],
        source: doc['source'],
        url: doc['url'],
        ingredientLines: List<String>.from(doc['ingredientLines']),
      );
    }).toList();
  }

  Future<void> _refreshFavorites() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: fetchFavoriteRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite recipes found.'));
          }

          final favoriteRecipes = snapshot.data!;

          return ListView.builder(
            itemCount: favoriteRecipes.length,
            itemBuilder: (context, index) {
              final recipe = favoriteRecipes[index];
              return ListTile(
                title: Text(recipe.label),
                subtitle: Text(recipe.source),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteRecipeDetailPage(recipe: recipe),
                    ),
                  );
                  if (result == 'deleted') {
                    _refreshFavorites();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
