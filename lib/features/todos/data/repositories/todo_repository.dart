import '../../domain/entities/todo.dart';
import '../datasources/todo_local_datasource.dart';
import '../datasources/todo_remote_datasource.dart';
import '../models/todo_model.dart';

class TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;

  TodoRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<List<Todo>> getTodos() async {
    try {
      // جرب جلب البيانات من السيرفر
      final remoteTodos = await remoteDataSource.getTodos();

      // احفظها محلياً
      await localDataSource.cacheTodos(remoteTodos);

      return remoteTodos;
    } catch (e) {
      // إذا فشل، استخدم البيانات المحلية
      return await localDataSource.getCachedTodos();
    }
  }

  Future<Todo> createTodo(String title) async {
    final todoModel = await remoteDataSource.createTodo(title);
    return todoModel;
  }

  Future<void> updateTodo(Todo todo) async {
    final todoModel = TodoModel.fromEntity(todo);
    await remoteDataSource.updateTodo(todoModel);
  }

  Future<void> deleteTodo(String id) async {
    await remoteDataSource.deleteTodo(id);
  }
}
