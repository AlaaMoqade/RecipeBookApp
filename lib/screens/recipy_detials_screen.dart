import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipy.dart';
import '../provider/favorites_provider.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool showIngredients = false;
  bool showInstructions = false;

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favoritesProvider.isFavorite(widget.recipe);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
         iconTheme: const IconThemeData(color: Colors.orange),
        title: Text(
          widget.recipe.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 10, 9),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red),
            onPressed: () {
              favoritesProvider.toggleFavorite(widget.recipe);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// ---- Image ----
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.recipe.image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[900],
                  child: const Icon(Icons.image, size: 60, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 16),

           
            GestureDetector(
              onTap: () {
                setState(() {
                  showIngredients = !showIngredients;
                  if (showIngredients) showInstructions = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'المكونات',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // جهة اليسار
                ),
              ),
            ),
            const SizedBox(height: 8),

           
            if (showIngredients)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.recipe.ingredients
                      .map((i) => Text(
                            '- $i',
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                          ))
                      .toList(),
                ),
              ),

            const SizedBox(height: 16),

            
            GestureDetector(
              onTap: () {
                setState(() {
                  showInstructions = !showInstructions;
                  if (showInstructions) showIngredients = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'طريقة التحضير',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // جهة اليمين
                ),
              ),
            ),
            const SizedBox(height: 8),

            
            if (showInstructions)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.recipe.instructions
                      .map((i) => Text(
                            '- $i',
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
