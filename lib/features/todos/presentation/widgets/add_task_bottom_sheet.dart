import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/todo.dart';
import '../providers/todo_providers.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class AddTaskBottomSheet extends ConsumerStatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  ConsumerState<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends ConsumerState<AddTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startTime;
  DateTime? _deadline;
  TodoPriority _priority = TodoPriority.medium;
  String? _category;
  final List<int> _reminderMinutes = [10];
  bool _notifyOnStart = false;
  bool _notifyOnDeadline = true;

  final List<String> _categories = [
    'عمل',
    'شخصي',
    'دراسة',
    'صحة',
    'تسوق',
    'عائلة',
  ];

  final List<int> _availableReminders = [5, 10, 15, 30, 60];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'مهمة جديدة',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),

                  // Task Title Input
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'عنوان المهمة *',
                      hintText: 'ماذا تريد أن تنجز؟',
                      prefixIcon: const Icon(Icons.task_alt_rounded),
                      border: OutlineInputBorder(
                        borderRadius: AppTheme.buttonRadius,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),

                  // Description Input
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'الوصف (اختياري)',
                      hintText: 'أضف تفاصيل إضافية...',
                      prefixIcon: const Icon(Icons.notes_rounded),
                      border: OutlineInputBorder(
                        borderRadius: AppTheme.buttonRadius,
                      ),
                    ),
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                  ),
                  const SizedBox(height: 24),

                  // Priority Selection
                  Text(
                    'الأولوية',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildPriorityChips(),
                  const SizedBox(height: 24),

                  // Category Selection
                  Text(
                    'التصنيف',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryChips(),
                  const SizedBox(height: 24),

                  // Time Settings
                  Text(
                    'الوقت والموعد',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeCard(
                          label: 'وقت البدء',
                          icon: Icons.play_circle_outline_rounded,
                          time: _startTime,
                          onTap: () => _selectStartTime(context),
                          onClear: _startTime != null
                              ? () => setState(() => _startTime = null)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTimeCard(
                          label: 'الموعد النهائي',
                          icon: Icons.flag_rounded,
                          time: _deadline,
                          onTap: () => _selectDeadline(context),
                          onClear: _deadline != null
                              ? () => setState(() => _deadline = null)
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Reminder Settings
                  if (_deadline != null) ...[
                    Text(
                      'التذكيرات',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildReminderSettings(),
                    const SizedBox(height: 24),
                  ],

                  // Submit Button
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.buttonRadius,
                      ),
                      backgroundColor: AppTheme.gradientMiddle,
                      foregroundColor: Colors.white,
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_task_rounded),
                        const SizedBox(width: 8),
                        Text(
                          'إضافة المهمة',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ).animate().scale(delay: 100.ms, duration: 300.ms),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriorityChips() {
    return Wrap(
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
          side: BorderSide(
            color: isSelected ? chipColor : chipColor.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((category) {
        final isSelected = _category == category;

        return ChoiceChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (selected) {
            setState(() => _category = selected ? category : null);
          },
          selectedColor: AppTheme.gradientStart.withValues(alpha: 0.3),
          backgroundColor: AppTheme.calmLavender.withValues(alpha: 0.1),
          labelStyle: TextStyle(
            color: isSelected ? AppTheme.gradientStart : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeCard({
    required String label,
    required IconData icon,
    required DateTime? time,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: time != null
              ? AppTheme.gradientStart.withValues(alpha: 0.1)
              : AppTheme.backgroundLight,
          borderRadius: AppTheme.cardRadius,
          border: Border.all(
            color: time != null
                ? AppTheme.gradientStart.withValues(alpha: 0.5)
                : AppTheme.dividerColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: time != null
                      ? AppTheme.gradientStart
                      : AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (onClear != null)
                  GestureDetector(
                    onTap: onClear,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              time != null
                  ? DateFormat('d MMM, h:mm a', 'ar').format(time)
                  : 'اضغط للتحديد',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: time != null
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('إشعار عند البدء'),
            value: _notifyOnStart,
            onChanged: _startTime != null
                ? (value) => setState(() => _notifyOnStart = value)
                : null,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('إشعار عند الموعد النهائي'),
            value: _notifyOnDeadline,
            onChanged: (value) => setState(() => _notifyOnDeadline = value),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
          const SizedBox(height: 12),
          Text(
            'تذكير قبل الموعد النهائي',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _availableReminders.map((minutes) {
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

  void _selectStartTime(BuildContext context) {
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

  void _selectDeadline(BuildContext context) {
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

  void _addTask() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى إدخال عنوان المهمة'),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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

    ref.read(todosProvider.notifier).addTodo(newTodo);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تمت إضافة المهمة بنجاح! 🎉'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
