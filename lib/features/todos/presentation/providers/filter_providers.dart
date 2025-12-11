import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo.dart';
import 'todo_providers.dart';
import 'package:flutter_riverpod/legacy.dart';

enum TodoFilter { all, active, completed }

// Filter Provider
final todoFilterProvider = StateProvider<TodoFilter>((ref) {
  return TodoFilter.all;
});

// Filtered Todos Provider
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoFilterProvider);
  final todosAsync = ref.watch(todosProvider);

  return todosAsync.when(
    data: (todos) {
      switch (filter) {
        case TodoFilter.active:
          return todos.where((todo) => !todo.isCompleted).toList();
        case TodoFilter.completed:
          return todos.where((todo) => todo.isCompleted).toList();
        case TodoFilter.all:
          return todos;
      }
    },
    loading: () => [],
    error: (_, _) => [],
  );
});
