import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required super.id,
    required super.title,
    super.description,
    super.isCompleted,
    super.createdAt,
    super.startTime,
    super.deadline,
    super.completedAt,
    super.priority,
    super.category,
    super.reminderMinutesBefore,
    super.notifyOnStart,
    super.notifyOnDeadline,
  });

  // من JSON
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : null,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      priority: json['priority'] != null
          ? TodoPriority.values.firstWhere(
              (e) => e.name == json['priority'],
              orElse: () => TodoPriority.medium,
            )
          : TodoPriority.medium,
      category: json['category'] as String?,
      reminderMinutesBefore: json['reminderMinutesBefore'] != null
          ? List<int>.from(json['reminderMinutesBefore'])
          : const [10],
      notifyOnStart: json['notifyOnStart'] as bool? ?? false,
      notifyOnDeadline: json['notifyOnDeadline'] as bool? ?? true,
    );
  }

  // إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'priority': priority.name,
      'category': category,
      'reminderMinutesBefore': reminderMinutesBefore,
      'notifyOnStart': notifyOnStart,
      'notifyOnDeadline': notifyOnDeadline,
    };
  }

  // من Entity
  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
      createdAt: todo.createdAt,
      startTime: todo.startTime,
      deadline: todo.deadline,
      completedAt: todo.completedAt,
      priority: todo.priority,
      category: todo.category,
      reminderMinutesBefore: todo.reminderMinutesBefore,
      notifyOnStart: todo.notifyOnStart,
      notifyOnDeadline: todo.notifyOnDeadline,
    );
  }
}
