import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/todo.dart';
import '../providers/todo_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/motivational_service.dart';

class TodoDetailPage extends ConsumerStatefulWidget {
  final String todoId;

  const TodoDetailPage({super.key, required this.todoId});

  @override
  ConsumerState<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends ConsumerState<TodoDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TodoPriority _priority;
  late String? _category;
  late DateTime? _startTime;
  late DateTime? _deadline;
  late List<int> _reminderMinutes;
  late bool _notifyOnStart;
  late bool _notifyOnDeadline;

  final _motivationalService = MotivationalService();

  @override
  void initState() {
    super.initState();
    final todo = ref.read(todoProvider(widget.todoId));
    if (todo != null) {
      _initializeFields(todo);
    }
  }

  void _initializeFields(Todo todo) {
    _titleController = TextEditingController(text: todo.title);
    _descriptionController = TextEditingController(
      text: todo.description ?? '',
    );
    _priority = todo.priority;
    _category = todo.category;
    _startTime = todo.startTime;
    _deadline = todo.deadline;
    _reminderMinutes = List.from(todo.reminderMinutesBefore);
    _notifyOnStart = todo.notifyOnStart;
    _notifyOnDeadline = todo.notifyOnDeadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todo = ref.watch(todoProvider(widget.todoId));

    if (todo == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('مهمة غير موجودة')),
        body: const Center(child: Text('لم يتم العثور على المهمة')),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () => _deleteTodo(context, todo),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(gradient: AppTheme.subtleGradient),
          ),

          // Content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 60,
              left: 16,
              right: 16,
              bottom: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Card
                _buildStatusCard(todo),
                const SizedBox(height: 24),

                // Title & Description
                _buildTitleSection(),
                const SizedBox(height: 24),

                // Priority & Category
                _buildPriorityAndCategory(),
                const SizedBox(height: 24),

                // Time Settings
                _buildTimeSettings(),
                const SizedBox(height: 24),

                // Reminder Settings
                if (_deadline != null) _buildReminderSettings(),

                // Task Statistics
                if (todo.isCompleted) _buildStatistics(todo),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveChanges,
        icon: const Icon(Icons.save_rounded),
        label: const Text('حفظ التغييرات'),
        backgroundColor: AppTheme.gradientStart,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildStatusCard(Todo todo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: todo.isCompleted
            ? LinearGradient(
                colors: [
                  AppTheme.successGreen,
                  AppTheme.successGreen.withValues(alpha: 0.7),
                ],
              )
            : todo.isOverdue
            ? LinearGradient(
                colors: [
                  AppTheme.errorRed,
                  AppTheme.errorRed.withValues(alpha: 0.7),
                ],
              )
            : AppTheme.primaryGradient,
        borderRadius: AppTheme.cardRadius,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Icon(
            todo.isCompleted
                ? Icons.check_circle_rounded
                : todo.isOverdue
                ? Icons.warning_rounded
                : Icons.schedule_rounded,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.isCompleted
                      ? 'مكتملة! 🎉'
                      : todo.isOverdue
                      ? 'متأخرة!'
                      : 'قيد التنفيذ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  todo.isCompleted
                      ? _motivationalService.getCompletionMessage()
                      : todo.isOverdue
                      ? _motivationalService.getOverdueEncouragement()
                      : _motivationalService.getUrgencyMessage(
                          todo.remainingTime,
                        ),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: AppTheme.cardRadius,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'العنوان',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            style: Theme.of(context).textTheme.titleLarge,
            decoration: const InputDecoration(
              hintText: 'عنوان المهمة',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'الوصف',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'أضف تفاصيل المهمة...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityAndCategory() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: AppTheme.cardRadius,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الأولوية', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: TodoPriority.values.map((priority) {
              final isSelected = _priority == priority;
              Color chipColor;
              switch (priority) {
                case TodoPriority.urgent:
                  chipColor = AppTheme.errorRed;
                  break;
                case TodoPriority.high:
                  chipColor = AppTheme.warningAmber;
                  break;
                case TodoPriority.medium:
                  chipColor = AppTheme.playfulOrange;
                  break;
                case TodoPriority.low:
                  chipColor = AppTheme.calmLavender;
                  break;
              }

              return ChoiceChip(
                label: Text(priority.displayName),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _priority = priority);
                },
                selectedColor: chipColor.withValues(alpha: 0.3),
                backgroundColor: chipColor.withValues(alpha: 0.1),
                labelStyle: TextStyle(
                  color: chipColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('التصنيف', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: TextEditingController(text: _category ?? ''),
            onChanged: (value) => _category = value.isEmpty ? null : value,
            decoration: const InputDecoration(
              hintText: 'مثال: عمل، شخصي، دراسة...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.label_outline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: AppTheme.cardRadius,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الوقت والموعد', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          // Start Time
          _buildTimeRow(
            label: 'وقت البدء',
            icon: Icons.play_circle_outline_rounded,
            time: _startTime,
            onTap: () => _selectStartTime(),
            onClear: () => setState(() => _startTime = null),
          ),
          const Divider(height: 24),

          // Deadline
          _buildTimeRow(
            label: 'الموعد النهائي',
            icon: Icons.flag_rounded,
            time: _deadline,
            onTap: () => _selectDeadline(),
            onClear: () => setState(() => _deadline = null),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow({
    required String label,
    required IconData icon,
    required DateTime? time,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.gradientStart),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                time != null
                    ? DateFormat('d MMMM yyyy, h:mm a', 'ar').format(time)
                    : 'غير محدد',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: time != null
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (time != null)
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onClear,
          ),
        IconButton(
          icon: const Icon(Icons.edit_calendar_rounded),
          onPressed: onTap,
        ),
      ],
    );
  }

  Widget _buildReminderSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: AppTheme.cardRadius,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('التذكيرات', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('إشعار عند البدء'),
            value: _notifyOnStart,
            onChanged: _startTime != null
                ? (value) => setState(() => _notifyOnStart = value)
                : null,
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text('إشعار عند الموعد النهائي'),
            value: _notifyOnDeadline,
            onChanged: (value) => setState(() => _notifyOnDeadline = value),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          Text(
            'تذكير قبل الموعد النهائي',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [5, 10, 15, 30, 60].map((minutes) {
              final isSelected = _reminderMinutes.contains(minutes);

              return FilterChip(
                label: Text(
                  '$minutes دقيقة',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                elevation: 0,
                pressElevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.gradientStart
                        : AppTheme.textSecondary.withValues(alpha: 0.4),
                    width: 1.4,
                  ),
                ),
                backgroundColor: AppTheme.calmLavender.withValues(alpha: 0.15),
                selectedColor: AppTheme.gradientStart,
                checkmarkColor: Colors.white,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _reminderMinutes.add(minutes);
                      _reminderMinutes.sort();
                    } else {
                      _reminderMinutes.remove(minutes);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(Todo todo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withValues(alpha: 0.1),
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات المهمة',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'تاريخ الإنشاء',
            DateFormat('d MMM yyyy', 'ar').format(todo.createdAt),
          ),
          if (todo.completedAt != null)
            _buildStatRow(
              'تاريخ الإكمال',
              DateFormat('d MMM yyyy, h:mm a', 'ar').format(todo.completedAt!),
            ),
          if (todo.actualDuration != null)
            _buildStatRow(
              'المدة الفعلية',
              _formatDuration(todo.actualDuration!),
            ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppTheme.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
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

  void _selectStartTime() {
    picker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(const Duration(days: 365)),
      onConfirm: (date) {
        setState(() => _startTime = date);
      },
      currentTime: _startTime ?? DateTime.now(),
      locale: picker.LocaleType.ar,
    );
  }

  void _selectDeadline() {
    picker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: _startTime ?? DateTime.now(),
      maxTime: DateTime.now().add(const Duration(days: 365)),
      onConfirm: (date) {
        setState(() => _deadline = date);
      },
      currentTime: _deadline ?? (_startTime ?? DateTime.now()),
      locale: picker.LocaleType.ar,
    );
  }

  void _saveChanges() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال عنوان المهمة'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    final todo = ref.read(todoProvider(widget.todoId));
    if (todo == null) return;

    final updatedTodo = todo.copyWith(
      title: title,
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      priority: _priority,
      category: _category,
      startTime: _startTime,
      deadline: _deadline,
      reminderMinutesBefore: _reminderMinutes,
      notifyOnStart: _notifyOnStart && _startTime != null,
      notifyOnDeadline: _notifyOnDeadline && _deadline != null,
    );

    ref.read(todosProvider.notifier).updateTodo(widget.todoId, updatedTodo);

    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ التغييرات بنجاح! ✓'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _deleteTodo(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف "${todo.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(todosProvider.notifier).removeTodo(widget.todoId);
              Navigator.of(context).pop(); // Close dialog
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف "${todo.title}"'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
