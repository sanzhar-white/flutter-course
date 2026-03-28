import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../services/auth_service.dart';
import '../services/notes_service.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final AuthService _authService = AuthService();
  final NotesService _notesService = NotesService();

  static const Color _primaryColor = Color(0xFFFFA726);
  static const Color _bgColor = Color(0xFFF8F9FA);

  String? get _userId => _authService.currentUserId;

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  void _confirmDelete(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить заметку'),
        content: Text('Вы уверены, что хотите удалить «${note.title}»?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _notesService.deleteNote(note.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Заметка удалена'),
                  backgroundColor: Colors.grey.shade800,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              );
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Только что';
    } else if (difference.inHours < 1) {
      final mins = difference.inMinutes;
      return '$mins мин. назад';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours ч. назад';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days дн. назад';
    } else {
      return DateFormat('d MMM yyyy', 'ru').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: const Text(
          'Мои заметки',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Выйти',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Выход'),
                  content: const Text('Вы уверены, что хотите выйти?'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logout();
                      },
                      child: const Text(
                        'Выйти',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      // FAB для добавления заметки
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/edit');
        },
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Новая заметка',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: _userId == null
          ? const Center(child: Text('Необходимо авторизоваться'))
          : StreamBuilder<List<Note>>(
              stream: _notesService.getNotesStream(_userId!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48.0, color: Colors.red.shade300),
                        const SizedBox(height: 12.0),
                        Text(
                          'Ошибка загрузки заметок',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.red.shade300,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: _primaryColor),
                  );
                }

                final notes = snapshot.data ?? [];

                if (notes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add_outlined,
                          size: 72.0,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Пока нет заметок',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Нажмите кнопку ниже, чтобы\nсоздать первую заметку',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return _NoteCard(
                      note: note,
                      formattedDate: _formatDate(note.updatedAt),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/edit',
                          arguments: note,
                        );
                      },
                      onDismissed: () => _confirmDelete(note),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  final String formattedDate;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const _NoteCard({
    required this.note,
    required this.formattedDate,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key(note.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          onDismissed();
          return false; // Подтверждение через диалог
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: const Icon(
            Icons.delete_rounded,
            color: Colors.white,
            size: 28.0,
          ),
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          elevation: 1,
          shadowColor: Colors.black.withOpacity(0.08),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title.isEmpty ? 'Без названия' : note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      color: note.title.isEmpty
                          ? const Color(0xFF9E9E9E)
                          : const Color(0xFF212121),
                    ),
                  ),
                  if (note.content.isNotEmpty) ...[
                    const SizedBox(height: 6.0),
                    Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF757575),
                        height: 1.4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14.0,
                        color: Color(0xFFBDBDBD),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
