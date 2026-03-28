import 'package:flutter/material.dart';

void main() {
  runApp(const VizitkaApp());
}

class VizitkaApp extends StatelessWidget {
  const VizitkaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Визитка',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1565C0),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const VizitkaScreen(),
    );
  }
}

class VizitkaScreen extends StatelessWidget {
  const VizitkaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Моя визитка'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Верхний блок с фото и именем
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 32,
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: colorScheme.primary,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: colorScheme.secondaryContainer,
                      child: Text(
                        'АИ',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Александр Иванов',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Flutter-разработчик',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'г. Москва, Россия',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // О себе
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_outline,
                              color: colorScheme.primary, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'О себе',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Опытный мобильный разработчик с 5-летним стажем. '
                        'Специализируюсь на создании кроссплатформенных приложений '
                        'с использованием Flutter и Dart. Люблю чистый код и '
                        'красивый дизайн.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                              color: colorScheme.onSurface.withOpacity(0.8),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Контактная информация
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Row(
                        children: [
                          Icon(Icons.contacts_outlined,
                              color: colorScheme.primary, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Контакты',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    _buildContactTile(
                      context,
                      icon: Icons.phone_outlined,
                      title: 'Телефон',
                      subtitle: '+7 (999) 123-45-67',
                      color: Colors.green,
                    ),
                    _buildDivider(),
                    _buildContactTile(
                      context,
                      icon: Icons.email_outlined,
                      title: 'Электронная почта',
                      subtitle: 'alex.ivanov@example.com',
                      color: Colors.orange,
                    ),
                    _buildDivider(),
                    _buildContactTile(
                      context,
                      icon: Icons.language_outlined,
                      title: 'Веб-сайт',
                      subtitle: 'www.alex-ivanov.dev',
                      color: Colors.blue,
                    ),
                    _buildDivider(),
                    _buildContactTile(
                      context,
                      icon: Icons.send_outlined,
                      title: 'Телеграм',
                      subtitle: '@alex_ivanov_dev',
                      color: Colors.lightBlue,
                    ),
                    _buildDivider(),
                    _buildContactTile(
                      context,
                      icon: Icons.code_outlined,
                      title: 'GitHub',
                      subtitle: 'github.com/alex-ivanov',
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1),
    );
  }
}
