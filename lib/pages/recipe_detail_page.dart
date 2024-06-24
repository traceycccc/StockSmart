
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/my_button.dart';
import '../models/recipe.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.label),
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
      bottomNavigationBar: BottomAppBar(
        height: 82.0,
        child: Center(
          child: MyButton(
            text: 'Add to Favorites',
            onTap: () async {
              await _addToFavorites(context);
            },
          ),
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

  Future<void> _addToFavorites(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docRef = FirebaseFirestore.instance.collection('favorites').doc();
        await docRef.set({
          'userId': user.uid,
          'label': recipe.label,
          'source': recipe.source,
          'url': recipe.url,
          'ingredientLines': recipe.ingredientLines,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe added to favorites!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to favorites: $e')),
      );
    }
  }
}
