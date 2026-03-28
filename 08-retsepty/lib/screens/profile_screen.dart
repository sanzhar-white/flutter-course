import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final int totalRecipes;
  final int favoriteCount;
  final VoidCallback onToggleTheme;

  const ProfileScreen({
    super.key,
    required this.totalRecipes,
    required this.favoriteCount,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Светлая тема' : 'Тёмная тема',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- Аватар ---
            CircleAvatar(
              radius: 56,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 56,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Домашний повар',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Любитель вкусной еды',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // --- Статистика ---
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.restaurant_menu,
                    label: 'Всего рецептов',
                    value: '$totalRecipes',
                    color: colorScheme.primaryContainer,
                    onColor: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.favorite,
                    label: 'В избранном',
                    value: '$favoriteCount',
                    color: colorScheme.tertiaryContainer,
                    onColor: colorScheme.onTertiaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Настройки ---
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: colorScheme.primary,
                    ),
                    title: const Text('Тема оформления'),
                    subtitle: Text(isDark ? 'Тёмная тема' : 'Светлая тема'),
                    trailing: Switch(
                      value: isDark,
                      onChanged: (_) => onToggleTheme(),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                    ),
                    title: const Text('О приложении'),
                    subtitle: const Text('Книга рецептов v1.0'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Рецепты',
                        applicationVersion: '1.0.0',
                        children: [
                          const Text(
                            'Приложение с коллекцией домашних рецептов. '
                            'Создано в рамках курса по Flutter.',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color onColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 32, color: onColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: onColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(color: onColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
