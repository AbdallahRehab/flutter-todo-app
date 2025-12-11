import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/todo_local_datasource.dart';
import '../../data/datasources/todo_remote_datasource.dart';
import '../../data/repositories/todo_repository.dart';
import '../../domain/entities/todo.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/todos_notifier.dart';

// Data Sources Providers
final todoRemoteDataSourceProvider = Provider<TodoRemoteDataSource>((ref) {
  return TodoRemoteDataSourceImpl();
});

final todoLocalDataSourceProvider = Provider<TodoLocalDataSource>((ref) {
  return TodoLocalDataSourceImpl();
});

// Repository Provider
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository(
    remoteDataSource: ref.watch(todoRemoteDataSourceProvider),
    localDataSource: ref.watch(todoLocalDataSourceProvider),
  );
});

// Todos Provider
final todosProvider =
    StateNotifierProvider<TodosNotifier, AsyncValue<List<Todo>>>((ref) {
      final repository = ref.watch(todoRepositoryProvider);
      return TodosNotifier(repository: repository);
    });

// Initial Load Provider - safely loads todos without triggering provider modifications
final loadInitialTodosProvider = FutureProvider<void>((ref) async {
  final notifier = ref.read(todosProvider.notifier);
  await notifier.loadTodos();
});

// Single Todo Provider (Family)
final todoProvider = Provider.family<Todo?, String>((ref, id) {
  return ref.watch(todosProvider).whenData((todos) {
    try {
      return todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }).value;
});
