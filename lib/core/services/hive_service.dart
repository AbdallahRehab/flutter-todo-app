import 'package:hive_flutter/hive_flutter.dart';
import '../../features/todos/data/models/todo_model.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  static const String _todosBoxName = 'todos';
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Register adapters if needed (for custom types)
    // For now, we'll use JSON serialization

    await Hive.openBox<Map>(_todosBoxName);

    _initialized = true;
  }

  Box<Map> get _todosBox => Hive.box<Map>(_todosBoxName);

  // Save todo
  Future<void> saveTodo(TodoModel todo) async {
    await _todosBox.put(todo.id, todo.toJson());
  }

  // Save multiple todos
  Future<void> saveTodos(List<TodoModel> todos) async {
    final Map<String, Map<String, dynamic>> todosMap = {
      for (var todo in todos) todo.id: todo.toJson(),
    };
    await _todosBox.putAll(todosMap);
  }

  // Get all todos
  List<TodoModel> getAllTodos() {
    final todos = <TodoModel>[];

    for (var entry in _todosBox.toMap().entries) {
      try {
        final todoMap = Map<String, dynamic>.from(entry.value);
        todos.add(TodoModel.fromJson(todoMap));
      } catch (e) {
        // Silently skip malformed todos
      }
    }

    // Sort by creation date (newest first)
    todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return todos;
  }

  // Get todo by ID
  TodoModel? getTodoById(String id) {
    final todoData = _todosBox.get(id);
    if (todoData == null) return null;

    try {
      final todoMap = Map<String, dynamic>.from(todoData);
      return TodoModel.fromJson(todoMap);
    } catch (e) {
      // Return null for malformed todos
      return null;
    }
  }

  // Delete todo
  Future<void> deleteTodo(String id) async {
    await _todosBox.delete(id);
  }

  // Delete all todos
  Future<void> deleteAllTodos() async {
    await _todosBox.clear();
  }

  // Check if box is empty
  bool get isEmpty => _todosBox.isEmpty;

  // Get todo count
  int get todoCount => _todosBox.length;

  // Watch todos for changes (stream)
  Stream<BoxEvent> watchTodos() {
    return _todosBox.watch();
  }

  // Backup todos (export as JSON)
  Map<String, dynamic> exportTodos() {
    return _todosBox.toMap().map(
      (key, value) => MapEntry(key.toString(), value),
    );
  }

  // Restore todos (import from JSON)
  Future<void> importTodos(Map<String, dynamic> data) async {
    await _todosBox.clear();
    for (var entry in data.entries) {
      await _todosBox.put(entry.key, entry.value);
    }
  }

  // Clean up (close box)
  Future<void> dispose() async {
    await _todosBox.close();
    _initialized = false;
  }
}
