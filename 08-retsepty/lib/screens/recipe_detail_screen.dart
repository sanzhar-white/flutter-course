import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final VoidCallback onToggleFavorite;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.onToggleFavorite,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- SliverAppBar с изображением ---
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                recipe.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                ),
              ),
              background: Container(
                color: colorScheme.primaryContainer,
                child: Center(
                  child: Icon(
                    _iconForCategory(recipe.category),
                    size: 80,
                    color: colorScheme.onPrimaryContainer.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: recipe.isFavorite ? Colors.redAccent : null,
                ),
                onPressed: () {
                  widget.onToggleFavorite();
                  setState(() {});
                },
              ),
            ],
          ),

          // --- Описание ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Категория
                  Chip(
                    avatar: Icon(
                      _iconForCategory(recipe.category),
                      size: 18,
                    ),
                    label: Text(recipe.category.label),
                    backgroundColor: colorScheme.secondaryContainer,
                    side: BorderSide.none,
                  ),
                  const SizedBox(height: 12),

                  // Описание
                  Text(
                    recipe.description,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Ингредиенты ---
                  Text(
                    'Ингредиенты',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Список ингредиентов
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          recipe.ingredients[index],
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: recipe.ingredients.length,
            ),
          ),

          // --- Шаги приготовления ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Text(
                'Приготовление',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          '${index + 1}',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            recipe.steps[index],
                            style: textTheme.bodyMedium?.copyWith(height: 1.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: recipe.steps.length,
            ),
          ),

          // Нижний отступ
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  IconData _iconForCategory(RecipeCategory category) {
    switch (category) {
      case RecipeCategory.soup:
        return Icons.soup_kitchen;
      case RecipeCategory.main:
        return Icons.dinner_dining;
      case RecipeCategory.dessert:
        return Icons.cake;
      case RecipeCategory.salad:
        return Icons.eco;
      case RecipeCategory.snack:
        return Icons.bakery_dining;
      case RecipeCategory.drink:
        return Icons.local_cafe;
    }
  }
}
