import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_providers.dart';
import '../../../../core/theme/app_theme.dart';

class FilterChips extends ConsumerWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(todoFilterProvider);

    return Row(
      children: [
        _buildFilterChip(
          label: 'الكل',
          isSelected: currentFilter == TodoFilter.all,
          onSelected: () {
            ref.read(todoFilterProvider.notifier).state = TodoFilter.all;
          },
        ),
        const SizedBox(width: 8),
        _buildFilterChip(
          label: 'النشطة',
          isSelected: currentFilter == TodoFilter.active,
          onSelected: () {
            ref.read(todoFilterProvider.notifier).state = TodoFilter.active;
          },
        ),
        const SizedBox(width: 8),
        _buildFilterChip(
          label: 'المكتملة',
          isSelected: currentFilter == TodoFilter.completed,
          onSelected: () {
            ref.read(todoFilterProvider.notifier).state = TodoFilter.completed;
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected
                ? AppTheme.gradientStart
                : AppTheme.calmLavender.withValues(alpha: 0.2),
            border: Border.all(
              color: isSelected
                  ? AppTheme.gradientStart
                  : AppTheme.textSecondary.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
