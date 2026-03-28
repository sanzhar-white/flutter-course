import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_sheet.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DoDone',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        scrolledUnderElevation: 2,
      ),
      body: Column(
        children: [
          // Filter chips
          Consumer<TaskModel>(
            builder: (context, taskModel, _) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Все (${taskModel.allTasks.length})',
                      isSelected: taskModel.filter == TaskFilter.all,
                      onTap: () => taskModel.setFilter(TaskFilter.all),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Активные (${taskModel.activeCount})',
                      isSelected: taskModel.filter == TaskFilter.active,
                      onTap: () => taskModel.setFilter(TaskFilter.active),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Готовые (${taskModel.completedCount})',
                      isSelected: taskModel.filter == TaskFilter.completed,
                      onTap: () => taskModel.setFilter(TaskFilter.completed),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),
          // Task list
          Expanded(
            child: Consumer<TaskModel>(
              builder: (context, taskModel, _) {
                final tasks = taskModel.filteredTasks;

                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          taskModel.filter == TaskFilter.completed
                              ? Icons.check_circle_outline
                              : Icons.inbox_outlined,
                          size: 80,
                          color: colorScheme.onSurface.withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          taskModel.filter == TaskFilter.completed
                              ? 'Нет завершённых задач'
                              : taskModel.filter == TaskFilter.active
                                  ? 'Все задачи выполнены!'
                                  : 'Нет задач\nНажмите + чтобы добавить',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskTile(task: tasks[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (_) => ChangeNotifierProvider.value(
              value: context.read<TaskModel>(),
              child: const AddTaskSheet(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected
              ? colorScheme.onSecondaryContainer
              : colorScheme.onSurfaceVariant,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
