import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:recipe_gsg/cubit/recipe_cubit.dart';
import 'package:recipe_gsg/provider/bottom_nav_provider.dart';
import 'package:recipe_gsg/screens/add_recipy_screen.dart';
import 'package:recipe_gsg/screens/favorites_screen.dart';
import 'package:recipe_gsg/screens/home_content_screen.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAddRecipePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddRecipeScreen(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await SharedPrefs.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'خروج',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomNav = Provider.of<BottomNavProvider>(context);

    return BlocProvider(
      create: (_) => RecipeCubit()..fetchRecipesFromApi(),
      child: Scaffold(
        backgroundColor: Colors.black,

       
        appBar: AppBar(
          title: Text(
            bottomNav.selectedIndex == 0
                ? 'الرئيسية'
                : bottomNav.selectedIndex == 1
                    ? 'المفضلة'
                    : bottomNav.selectedIndex == 2
                        ? 'إضافة وصفة'
                        : '',
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 15, 14, 12),
        ),

        
        body: BlocBuilder<RecipeCubit, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            } else if (state is RecipeError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (state is RecipeLoaded) {
              final recipes = state.recipes;
              final pages = [
                HomeContentScreen(recipes: recipes),
                const FavoritesScreen(),
              ];
              return pages[bottomNav.selectedIndex];
            }
            return const SizedBox.shrink();
          },
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[900],
          currentIndex: bottomNav.selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 2) {
              _openAddRecipePage(context);
            } else if (index == 3) {
              _showLogoutDialog(context);
            } else {
              bottomNav.setIndex(index);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'المفضلة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'إضافة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout_outlined),
              activeIcon: Icon(Icons.logout),
              label: 'خروج',
            ),
          ],
        ),
      ),
    );
  }
}
