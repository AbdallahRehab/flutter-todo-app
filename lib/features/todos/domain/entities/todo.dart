enum TodoPriority {
  low,
  medium,
  high,
  urgent;

  String get displayName {
    switch (this) {
      case TodoPriority.low:
        return 'منخفض';
      case TodoPriority.medium:
        return 'متوسط';
      case TodoPriority.high:
        return 'عالي';
      case TodoPriority.urgent:
        return 'عاجل';
    }
  }
}

class Todo {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? startTime;
  final DateTime? deadline;
  final DateTime? completedAt;
  final TodoPriority priority;
  final String? category;
  final List<int>
  reminderMinutesBefore; // [5, 10, 30] means reminders 5, 10, 30 mins before deadline
  final bool notifyOnStart;
  final bool notifyOnDeadline;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    DateTime? createdAt,
    this.startTime,
    this.deadline,
    this.completedAt,
    this.priority = TodoPriority.medium,
    this.category,
    this.reminderMinutesBefore = const [10],
    this.notifyOnStart = false,
    this.notifyOnDeadline = true,
  }) : createdAt = createdAt ?? DateTime.now();

  // Calculate remaining time until deadline
  Duration? get remainingTime {
    if (deadline == null || isCompleted) return null;
    final now = DateTime.now();
    if (deadline!.isBefore(now)) return Duration.zero;
    return deadline!.difference(now);
  }

  // Check if task is overdue
  bool get isOverdue {
    if (deadline == null || isCompleted) return false;
    return DateTime.now().isAfter(deadline!);
  }

  // Calculate actual duration (start to completion)
  Duration? get actualDuration {
    if (startTime == null || completedAt == null) return null;
    return completedAt!.difference(startTime!);
  }

  // Calculate progress percentage based on time
  double get timeProgressPercentage {
    if (startTime == null || deadline == null) return 0.0;
    final now = DateTime.now();
    if (now.isBefore(startTime!)) return 0.0;
    if (now.isAfter(deadline!)) return 1.0;

    final totalDuration = deadline!.difference(startTime!);
    final elapsed = now.difference(startTime!);
    return elapsed.inSeconds / totalDuration.inSeconds;
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? startTime,
    DateTime? deadline,
    DateTime? completedAt,
    TodoPriority? priority,
    String? category,
    List<int>? reminderMinutesBefore,
    bool? notifyOnStart,
    bool? notifyOnDeadline,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      startTime: startTime ?? this.startTime,
      deadline: deadline ?? this.deadline,
      completedAt: completedAt ?? this.completedAt,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      notifyOnStart: notifyOnStart ?? this.notifyOnStart,
      notifyOnDeadline: notifyOnDeadline ?? this.notifyOnDeadline,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Todo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
