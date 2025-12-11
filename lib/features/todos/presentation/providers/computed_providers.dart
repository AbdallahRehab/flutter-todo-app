import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo_providers.dart';

// Uncompleted Todos Count
final uncompletedTodosCountProvider = Provider<int>((ref) {
  final todosAsync = ref.watch(todosProvider);

  return todosAsync.when(
    data: (todos) => todos.where((todo) => !todo.isCompleted).length,
    loading: () => 0,
    error: (_, _) => 0,
  );
});

// Total Todos Count
final totalTodosCountProvider = Provider<int>((ref) {
  final todosAsync = ref.watch(todosProvider);

  return todosAsync.when(
    data: (todos) => todos.length,
    loading: () => 0,
    error: (_, _) => 0,
  );
});

// Completion Percentage
final completionPercentageProvider = Provider<double>((ref) {
  final total = ref.watch(totalTodosCountProvider);
  final uncompleted = ref.watch(uncompletedTodosCountProvider);

  if (total == 0) return 0;
  return ((total - uncompleted) / total) * 100;
});
