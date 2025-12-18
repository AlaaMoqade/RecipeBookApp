import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/favorites_provider.dart';
import 'recipy_detials_screen.dart';
import '../utils/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    if (favorites.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "لا توجد وصفات مفضلة حتى الآن",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final recipe = favorites[index];

          return InkWell(
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
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      recipe.image,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 300,
                        color: Colors.grey[800],
                        child: const Icon(Icons.image,
                            size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            favoritesProvider.toggleFavorite(recipe);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'التقييم: ${recipe.rating}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
