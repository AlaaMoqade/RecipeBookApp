import 'package:flutter/material.dart';
import '../models/recipy.dart';
import 'recipy_detials_screen.dart';

class HomeContentScreen extends StatelessWidget {
  final List<Recipe> recipes;

  const HomeContentScreen({super.key, required this.recipes});

  List<Recipe> reorderRecipes(List<Recipe> original) {
    if (original.isEmpty) return [];

    List<Recipe> reordered = [];
    int mid = (original.length / 2).floor();
    int left = mid - 1;
    int right = mid + 1;

    reordered.add(original[mid]); 

    bool turnLeft = true;
    while (left >= 0 || right < original.length) {
      if (turnLeft && left >= 0) {
        reordered.add(original[left]);
        left--;
      } else if (!turnLeft && right < original.length) {
        reordered.add(original[right]);
        right++;
      }
      turnLeft = !turnLeft;
    }

    return reordered;
  }

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'لا توجد وصفات حتى الآن',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    }

    final displayedRecipes = reorderRecipes(recipes);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,          
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,     
        ),
        itemCount: displayedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = displayedRecipes[index];

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(recipe: recipe),
                ),
              );
            },
            child: Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      recipe.image,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 140,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      recipe.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
