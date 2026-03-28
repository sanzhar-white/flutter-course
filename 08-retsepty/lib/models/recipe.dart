enum RecipeCategory {
  soup('Супы'),
  main('Основные блюда'),
  dessert('Десерты'),
  salad('Салаты'),
  snack('Закуски'),
  drink('Напитки');

  final String label;
  const RecipeCategory(this.label);
}

class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final RecipeCategory category;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.category,
    this.isFavorite = false,
  });
}
