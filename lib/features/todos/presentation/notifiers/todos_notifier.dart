import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/repositories/todo_repository.dart';
import '../../domain/entities/todo.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/hive_service.dart';
import '../../data/models/todo_model.dart';

class TodosNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  final TodoRepository repository;
  final NotificationService _notificationService = NotificationService();
  final HiveService _hiveService = HiveService();

  TodosNotifier({required this.repository}) : super(const AsyncValue.data([])) {
    _notificationService.initialize();
  }

  Future<void> loadTodos() async {
    state = const AsyncValue.loading();
    try {
      // 1) Try local (Hive)
      final localTodos = _hiveService.getAllTodos();
      if (localTodos.isNotEmpty) {
        state = AsyncValue.data(localTodos);
        return;
      }

      // 2) Fallback to repository (mock remote) then cache
      final todos = await repository.getTodos();
      await _hiveService.saveTodos(todos.map(TodoModel.fromEntity).toList());
      state = AsyncValue.data(todos);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void addTodo(Todo todo) {
    state.whenData((todos) {
      state = AsyncValue.data([...todos, todo]);

      // Persist
      _hiveService.saveTodo(TodoModel.fromEntity(todo));

      // Schedule notifications for the new todo
      if (todo.deadline != null) {
        _notificationService.scheduleTaskNotifications(todo);
      }
    });
  }

  void toggleTodo(String id) {
    state.whenData((todos) {
      final todo = todos.firstWhere((t) => t.id == id);
      final updatedTodo = todo.copyWith(
        isCompleted: !todo.isCompleted,
        completedAt: !todo.isCompleted ? DateTime.now() : null,
      );

      state = AsyncValue.data([
        for (final t in todos)
          if (t.id == id) updatedTodo else t,
      ]);

      // Persist
      _hiveService.saveTodo(TodoModel.fromEntity(updatedTodo));

      // If completed, cancel notifications and show completion notification
      if (updatedTodo.isCompleted) {
        _notificationService.cancelTaskNotifications(id);
        _notificationService.showCompletionNotification(updatedTodo);
      } else {
        // If uncompleted, reschedule notifications
        if (updatedTodo.deadline != null) {
          _notificationService.scheduleTaskNotifications(updatedTodo);
        }
      }
    });
  }

  void removeTodo(String id) {
    state.whenData((todos) {
      state = AsyncValue.data(todos.where((todo) => todo.id != id).toList());

      // Cancel all notifications for this todo
      _notificationService.cancelTaskNotifications(id);

      // Persist
      _hiveService.deleteTodo(id);
    });
  }

  void editTodo(String id, String newTitle) {
    state.whenData((todos) {
      state = AsyncValue.data([
        for (final todo in todos)
          if (todo.id == id) todo.copyWith(title: newTitle) else todo,
      ]);
    });
  }

  void updateTodo(String id, Todo updatedTodo) {
    state.whenData((todos) {
      state = AsyncValue.data([
        for (final todo in todos)
          if (todo.id == id) updatedTodo else todo,
      ]);

      // Persist
      _hiveService.saveTodo(TodoModel.fromEntity(updatedTodo));

      // Update notifications
      _notificationService.cancelTaskNotifications(id);
      if (updatedTodo.deadline != null && !updatedTodo.isCompleted) {
        _notificationService.scheduleTaskNotifications(updatedTodo);
      }
    });
  }

  void setTodos(List<Todo> todos) {
    state = AsyncValue.data(todos);
  }

  void setLoading() {
    state = const AsyncValue.loading();
  }

  void setError(Object error, StackTrace stackTrace) {
    state = AsyncValue.error(error, stackTrace);
  }

  // Check if all incomplete tasks are now completed and show celebration
  void checkAllTasksCompleted() {
    state.whenData((todos) {
      final incompleteTodos = todos.where((t) => !t.isCompleted).toList();
      if (incompleteTodos.isEmpty && todos.isNotEmpty) {
        _notificationService.showCelebrationNotification(todos.length);
      }
    });
  }
}
