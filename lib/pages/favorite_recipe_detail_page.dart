
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/my_button.dart';
import '../models/recipe.dart';

class FavoriteRecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  FavoriteRecipeDetailPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.label),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _confirmDeleteFavoriteRecipe(context), // Call the delete confirmation dialog
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            SizedBox(height: 16),
            Text(
              recipe.label,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Source: ${recipe.source}',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Ingredients:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            ...recipe.ingredientLines.map<Widget>((line) {
              return Text(
                line,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }).toList(),
            SizedBox(height: 16),
            MyButton(
              text: "View Instructions",
              onTap: () => _launchURL(recipe.url),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _confirmDeleteFavoriteRecipe(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this favorite recipe?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteFavoriteRecipe(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteFavoriteRecipe(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('favorites')
            .where('userId', isEqualTo: user.uid)
            .where('label', isEqualTo: recipe.label)
            .get();

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        Navigator.of(context).pop(); // Close the confirmation dialog
        Navigator.of(context).pop('deleted'); // Return 'deleted' result to the previous screen

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe removed from favorites!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete the recipe: $e')),
      );
    }
  }
}
