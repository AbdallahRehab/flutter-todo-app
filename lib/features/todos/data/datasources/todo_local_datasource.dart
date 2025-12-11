import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getCachedTodos();
  Future<void> cacheTodos(List<TodoModel> todos);
  Future<void> clearCache();
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  // يمكنك استخدام SharedPreferences أو Hive هنا

  final List<TodoModel> _cache = [];

  @override
  Future<List<TodoModel>> getCachedTodos() async {
    return _cache;
  }

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    _cache.clear();
    _cache.addAll(todos);
  }

  @override
  Future<void> clearCache() async {
    _cache.clear();
  }
}
