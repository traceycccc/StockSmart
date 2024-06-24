import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/recipe.dart';

Future<List<Recipe>> fetchRecipes(String query) async {
  const appId = '33b498f1';
  const appKey = 'ae7e0adbf7fa1302726777283527168e';
  final url = 'https://api.edamam.com/api/recipes/v2?type=public&q=$query&app_id=$appId&app_key=$appKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final List recipes = jsonResponse['hits'];

    return recipes.map((data) => Recipe.fromJson(data['recipe'])).toList();
  } else {
    throw Exception('Failed to load recipes');
  }
}
