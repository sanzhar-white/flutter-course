import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _notesCollection = 'notes';

  /// Получить ссылку на коллекцию заметок
  CollectionReference get _notesRef =>
      _firestore.collection(_notesCollection);

  /// Получить поток заметок текущего пользователя (отсортированы по дате обновления)
  Stream<List<Note>> getNotesStream(String userId) {
    return _notesRef
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
    });
  }

  /// Добавить новую заметку
  Future<DocumentReference> addNote({
    required String title,
    required String content,
    required String userId,
  }) async {
    final now = DateTime.now();
    final noteData = {
      'title': title,
      'content': content,
      'userId': userId,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    };
    return await _notesRef.add(noteData);
  }

  /// Обновить существующую заметку
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    await _notesRef.doc(noteId).update({
      'title': title,
      'content': content,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Удалить заметку
  Future<void> deleteNote(String noteId) async {
    await _notesRef.doc(noteId).delete();
  }

  /// Получить одну заметку по ID
  Future<Note?> getNoteById(String noteId) async {
    final doc = await _notesRef.doc(noteId).get();
    if (doc.exists) {
      return Note.fromFirestore(doc);
    }
    return null;
  }
}
