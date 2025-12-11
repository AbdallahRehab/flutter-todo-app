import '../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> createTodo(String title);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  // يمكنك استخدام Dio أو http هنا

  @override
  Future<List<TodoModel>> getTodos() async {
    // محاكاة API call
    await Future.delayed(const Duration(seconds: 2));

    return [
      TodoModel(id: '1', title: 'تعلم Flutter'),
      TodoModel(id: '2', title: 'تعلم Riverpod'),
      TodoModel(id: '3', title: 'بناء تطبيق', isCompleted: true),
    ];
  }

  @override
  Future<TodoModel> createTodo(String title) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return TodoModel(id: DateTime.now().toString(), title: title);
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> deleteTodo(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
