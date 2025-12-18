import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_gsg/cubit/recipe_cubit.dart';
import 'package:recipe_gsg/screens/recipe_input_screen.dart';
import 'package:recipe_gsg/screens/recipy_detials_screen.dart';
import 'package:recipe_gsg/utils/app_colors.dart';

class AddRecipeScreen extends StatelessWidget {
  const AddRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipeCubit()..fetchLocalRecipes(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.orange),
          title: const Center(
            child: Text(
              'وصفاتي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 17, 16, 15),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            final recipeCubit = context.read<RecipeCubit>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeInputScreen(
                  onSave: () => recipeCubit.fetchLocalRecipes(),
                ),
              ),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: BlocBuilder<RecipeCubit, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoaded) {
              final recipes = state.recipes;
              if (recipes.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد وصفات حتى الآن',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15)),
                            child: Image.network(
                              recipe.image,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 200,
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.image,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: AppColors.primary, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      recipe.rating.toString(),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () async {
                                        if (recipe.id != null) {
                                          await context
                                              .read<RecipeCubit>()
                                              .deleteRecipe(recipe.id!);
                                        }
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: AppColors.primary),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                RecipeInputScreen(
                                              recipeToEdit: recipe,
                                              onSave: () => context
                                                  .read<RecipeCubit>()
                                                  .fetchLocalRecipes(),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit,
                                          color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'لا توجد وصفات حتى الآن',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
