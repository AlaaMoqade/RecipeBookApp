import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_gsg/cubit/recipe_cubit.dart';
import 'package:recipe_gsg/screens/recipe_input_screen.dart';

class RecipeInputScreenFull extends StatelessWidget {
  final VoidCallback? onSave; 
  const RecipeInputScreenFull({super.key, this.onSave});

  @override
  Widget build(BuildContext context) {
    final recipeCubit = context.read<RecipeCubit>(); 

    return Scaffold(
      body: RecipeInputScreen(
        onSave: () {
          recipeCubit.fetchLocalRecipes(); // بحدث  الوصفات و بزيدها بالdp 
          if (onSave != null) {
            onSave!();
          }
        },
      ),
    );
  }
}
