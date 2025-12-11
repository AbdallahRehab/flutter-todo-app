import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/todo.dart';
import '../providers/todo_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/motivational_service.dart';

class TodoItem extends ConsumerStatefulWidget {
  final String todoId;

  const TodoItem({super.key, required this.todoId});

  @override
  ConsumerState<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends ConsumerState<TodoItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _checkAnimationController;
  final _motivationalService = MotivationalService();

  @override
  void initState() {
    super.initState();
    _checkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _checkAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todo = ref.watch(todoProvider(widget.todoId));

    if (todo == null) return const SizedBox.shrink();

    return Slidable(
      key: Key(todo.id),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _showEditDialog(context, todo),
            backgroundColor: AppTheme.gradientStart,
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
            label: 'تعديل',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          SlidableAction(
            onPressed: (_) => _deleteTodo(context, todo),
            backgroundColor: AppTheme.errorRed,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'حذف',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: AppTheme.cardRadius,
          boxShadow: AppTheme.cardShadow,
          border: todo.isOverdue
              ? Border.all(
                  color: AppTheme.errorRed.withValues(alpha: 0.3),
                  width: 2,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _navigateToDetails(context, todo),
            borderRadius: AppTheme.cardRadius,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Progress Ring with Checkbox
                  _buildProgressRing(todo),
                  const SizedBox(width: 16),

                  // Task Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with Priority Badge
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                todo.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      decoration: todo.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: todo.isCompleted
                                          ? AppTheme.textSecondary
                                          : AppTheme.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildPriorityBadge(todo.priority),
                          ],
                        ),

                        if (todo.description != null &&
                            todo.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            todo.description!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        const SizedBox(height: 8),

                        // Time Info
                        _buildTimeInfo(todo),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildProgressRing(Todo todo) {
    if (todo.deadline == null) {
      // Simple checkbox without progress ring
      return GestureDetector(
        onTap: () => _toggleTodo(todo),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: todo.isCompleted ? AppTheme.primaryGradient : null,
            color: todo.isCompleted ? null : Colors.grey.shade200,
            border: !todo.isCompleted
                ? Border.all(color: AppTheme.gradientStart, width: 2)
                : null,
          ),
          child: Icon(
            todo.isCompleted ? Icons.check_rounded : Icons.circle_outlined,
            color: todo.isCompleted ? Colors.white : AppTheme.textSecondary,
            size: 28,
          ),
        ),
      );
    }

    // Progress ring for tasks with deadline
    final progress = todo.isCompleted ? 1.0 : todo.timeProgressPercentage;
    final remainingPercent = todo.isCompleted
        ? 1.0
        : (1.0 - progress).clamp(0.0, 1.0);

    Color progressColor;
    if (todo.isCompleted) {
      progressColor = AppTheme.successGreen;
    } else if (todo.isOverdue) {
      progressColor = AppTheme.errorRed;
    } else if (remainingPercent < 0.25) {
      progressColor = AppTheme.warningAmber;
    } else {
      progressColor = AppTheme.gradientStart;
    }

    return GestureDetector(
      onTap: () => _toggleTodo(todo),
      child: CircularPercentIndicator(
        radius: 28,
        lineWidth: 4,
        percent: remainingPercent,
        center: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: todo.isCompleted ? AppTheme.primaryGradient : null,
            color: todo.isCompleted ? null : Colors.white,
          ),
          child: Icon(
            todo.isCompleted ? Icons.check_rounded : Icons.circle_outlined,
            color: todo.isCompleted ? Colors.white : AppTheme.textSecondary,
            size: 24,
          ),
        ),
        progressColor: progressColor,
        backgroundColor: progressColor.withValues(alpha: 0.2),
        circularStrokeCap: CircularStrokeCap.round,
        animation: true,
        animationDuration: 500,
      ),
    );
  }

  Widget _buildPriorityBadge(TodoPriority priority) {
    final emoji = _motivationalService.getPriorityEmoji(priority.name);

    if (priority == TodoPriority.low) return const SizedBox.shrink();

    Color badgeColor;
    switch (priority) {
      case TodoPriority.urgent:
        badgeColor = AppTheme.errorRed;
        break;
      case TodoPriority.high:
        badgeColor = AppTheme.warningAmber;
        break;
      case TodoPriority.medium:
        badgeColor = AppTheme.playfulOrange;
        break;
      default:
        badgeColor = AppTheme.calmLavender;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            priority.displayName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(Todo todo) {
    final List<Widget> timeWidgets = [];

    // Remaining time or overdue
    if (todo.deadline != null && !todo.isCompleted) {
      final remaining = todo.remainingTime;

      if (remaining != null) {
        final isOverdue = remaining.isNegative || remaining == Duration.zero;
        final displayTime = _formatDuration(remaining.abs());

        timeWidgets.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isOverdue
                  ? AppTheme.errorRed.withValues(alpha: 0.15)
                  : AppTheme.gradientStart.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOverdue ? Icons.warning_rounded : Icons.schedule_rounded,
                  size: 14,
                  color: isOverdue ? AppTheme.errorRed : AppTheme.gradientStart,
                ),
                const SizedBox(width: 4),
                Text(
                  isOverdue ? 'متأخر $displayTime' : 'متبقي $displayTime',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOverdue
                        ? AppTheme.errorRed
                        : AppTheme.gradientStart,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    // Category
    if (todo.category != null && todo.category!.isNotEmpty) {
      if (timeWidgets.isNotEmpty) {
        timeWidgets.add(const SizedBox(width: 12));
      }

      timeWidgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.calmLavender.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.label_outline,
                size: 12,
                color: AppTheme.calmLavender,
              ),
              const SizedBox(width: 4),
              Text(
                todo.category!,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.calmLavender,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (timeWidgets.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 8, runSpacing: 4, children: timeWidgets);
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} يوم';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ساعة';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} دقيقة';
    } else {
      return 'أقل من دقيقة';
    }
  }

  void _toggleTodo(Todo todo) {
    ref.read(todosProvider.notifier).toggleTodo(todo.id);

    if (!todo.isCompleted) {
      _checkAnimationController.forward().then((_) {
        _checkAnimationController.reverse();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_motivationalService.getCompletionMessage()),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _deleteTodo(BuildContext context, Todo todo) {
    ref.read(todosProvider.notifier).removeTodo(todo.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حذف "${todo.title}"'),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'تراجع',
          textColor: Colors.white,
          onPressed: () {
            // Add undo functionality if needed
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Todo todo) {
    // Navigate to detail page for editing
    _navigateToDetails(context, todo);
  }

  void _navigateToDetails(BuildContext context, Todo todo) {
    context.go('/todo/${todo.id}');
  }
}
