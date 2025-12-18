import 'package:flutter/material.dart';
import 'package:recipe_gsg/models/recipy.dart';
import 'package:recipe_gsg/services/recipe_db_service.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/widget/app_buttom.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';

class RecipeInputScreen extends StatefulWidget {
  final VoidCallback onSave;
  final Recipe? recipeToEdit;

  const RecipeInputScreen({super.key, required this.onSave, this.recipeToEdit});

  @override
  State<RecipeInputScreen> createState() => _RecipeInputScreenState();
}

class _RecipeInputScreenState extends State<RecipeInputScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _imageController;
  late TextEditingController _ratingController;
  late TextEditingController _ingredientsController;
  late TextEditingController _instructionsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.recipeToEdit?.name ?? '',
    );
    _imageController = TextEditingController(
      text: widget.recipeToEdit?.image ?? '',
    );
    _ratingController = TextEditingController(
      text: widget.recipeToEdit != null
          ? widget.recipeToEdit!.rating.toString()
          : '',
    );
    _ingredientsController = TextEditingController(
      text: widget.recipeToEdit?.ingredients.join(',') ?? '',
    );
    _instructionsController = TextEditingController(
      text: widget.recipeToEdit?.instructions.join(',') ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _ratingController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final userEmail = await SharedPrefs.getUserToken() ?? 'example@email.com';

    final recipe = Recipe(
      id: widget.recipeToEdit?.id,
      name: _nameController.text.trim(),
      image: _imageController.text.trim(),
      rating: double.tryParse(_ratingController.text.trim()) ?? 0,
      ingredients: _ingredientsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      instructions: _instructionsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      userEmail: widget.recipeToEdit?.userEmail ?? userEmail,
    );

    if (widget.recipeToEdit != null) {
      await RecipeDBService.updateRecipe(recipe);
    } else {
      await RecipeDBService.insertRecipe(recipe);
    }

    widget.onSave();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.recipeToEdit != null ? 'تعديل الوصفة' : 'إضافة وصفة',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 10, 10, 8),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'اسم الوصفة',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'أدخل اسم الوصفة' : null,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _imageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'رابط الصورة',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'أدخل رابط الصورة' : null,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _ratingController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'التقييم',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'أدخل التقييم' : null,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _ingredientsController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'المكونات (مفصولة بفاصلة)',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _instructionsController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'طريقة التحضير (مفصولة بفاصلة)',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  text: widget.recipeToEdit != null
                      ? 'تحديث الوصفة'
                      : 'حفظ الوصفة',
                  onPressed: _saveRecipe,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
