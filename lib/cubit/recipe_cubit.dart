import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_gsg/models/recipy.dart';
import 'package:recipe_gsg/services/api_service.dart';
import 'package:recipe_gsg/services/recipe_db_service.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
part 'recipe_state.dart';
class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit() : super(RecipeLoaded([]));

  // الوصفات من API
  Future<void> fetchRecipesFromApi() async {
    emit(RecipeLoading());
    try {
      final recipes = await ApiService.getRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError("Failed to load recipes: $e"));
    }
  }

  // الوصفات الي ضافهم اليورز لنفسو  
  Future<void> fetchLocalRecipes() async {
    try {
      final userEmail = await SharedPrefs.getUserToken() ?? 'example@email.com';
      final recipes = await RecipeDBService.getRecipesByUser(userEmail);
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError("Failed to load local recipes: $e"));
    }
  }

  Future<void> deleteRecipe(int id) async {
    await RecipeDBService.deleteRecipe(id);
    await fetchLocalRecipes(); // تحديث بعد الحذف
  }

  Future<void> addOrUpdateRecipe(Recipe recipe) async {
    if (recipe.id != null) {
      await RecipeDBService.updateRecipe(recipe);
    } else {
      await RecipeDBService.insertRecipe(recipe);
    }
    await fetchLocalRecipes(); 
  }
}
