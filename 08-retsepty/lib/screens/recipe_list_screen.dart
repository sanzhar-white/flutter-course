import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatelessWidget {
  final List<Recipe> recipes;
  final ValueChanged<Recipe> onToggleFavorite;

  const RecipeListScreen({
    super.key,
    required this.recipes,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Все рецепты'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCard(
            recipe: recipe,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(
                    recipe: recipe,
                    onToggleFavorite: () => onToggleFavorite(recipe),
                  ),
                ),
              );
            },
            onToggleFavorite: () => onToggleFavorite(recipe),
          );
        },
      ),
    );
  }
}
