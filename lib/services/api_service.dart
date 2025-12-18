import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipy.dart';

class ApiService {
  static Future<List<Recipe>> getRecipes() async {
    final url = Uri.parse('https://dummyjson.com/recipes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List recipesJson = data['recipes'];
      return recipesJson.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
