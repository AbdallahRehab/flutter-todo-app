import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import '../providers/computed_providers.dart';
import '../providers/filter_providers.dart';
import '../providers/todo_providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/filter_chips.dart';
import '../widgets/todo_item.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/motivational_service.dart';

class TodoListPage extends ConsumerStatefulWidget {
  const TodoListPage({super.key});

  @override
  ConsumerState<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TodoListPage> {
  bool _hasLoadedInitial = false;
  late ConfettiController _confettiController;
  final ScrollController _listController = ScrollController();
  final _motivationalService = MotivationalService();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Load initial todos only once, after first frame
    if (!_hasLoadedInitial) {
      _hasLoadedInitial = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(todosProvider.notifier).loadTodos();
      });
    }

    // Listen for completion of all tasks
    ref.listen<int>(uncompletedTodosCountProvider, (previous, next) {
      if (previous != null && previous > 0 && next == 0) {
        _confettiController.play();
        ref.read(todosProvider.notifier).checkAllTasksCompleted();

        _showCelebrationDialog(context);
      }
    });

    final filteredTodos = ref.watch(filteredTodosProvider);
    final uncompletedCount = ref.watch(uncompletedTodosCountProvider);
    final totalCount = ref.watch(todosProvider).value?.length ?? 0;
    final todosAsync = ref.watch(todosProvider);
    final motivationalQuote = _motivationalService.getGreeting();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مهامي',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (totalCount > 0)
              Text(
                _motivationalService.getProgressMessage(
                  totalCount - uncompletedCount,
                  totalCount,
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          if (uncompletedCount > 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    ref.read(todoFilterProvider.notifier).state =
                        TodoFilter.active;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_listController.hasClients) {
                        _listController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.floatingButtonShadow,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.pending_actions,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$uncompletedCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(gradient: AppTheme.subtleGradient),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.3,
              shouldLoop: false,
              colors: const [
                AppTheme.gradientStart,
                AppTheme.gradientMiddle,
                AppTheme.gradientEnd,
                AppTheme.successGreen,
                AppTheme.playfulOrange,
              ],
            ),
          ),

          // Main Content
          todosAsync.when(
            data: (_) => Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 70),

                // Motivational Quote Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: AppTheme.cardRadius,
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          motivationalQuote,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Filter Chips
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: FilterChips(),
                ),

                const SizedBox(height: 8),

                // Task List
                Expanded(
                  child: filteredTodos.isEmpty
                      ? const EmptyState()
                      : AnimationLimiter(
                          child: ListView.builder(
                            controller: _listController,
                            padding: const EdgeInsets.only(bottom: 100),
                            itemCount: filteredTodos.length,
                            itemBuilder: (context, index) {
                              final todo = filteredTodos[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: TodoItem(todoId: todo.id),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Lottie.asset(
                      'assets/animations/loading.json',
                      errorBuilder: (context, error, stackTrace) {
                        return const CircularProgressIndicator(
                          color: AppTheme.gradientStart,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'جاري التحميل...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: AppTheme.errorRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'لا تقلق، دعنا نحاول مرة أخرى',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => ref.refresh(loadInitialTodosProvider),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: AppTheme.gradientStart,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskBottomSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('مهمة جديدة'),
        backgroundColor: AppTheme.gradientMiddle,
        elevation: 8,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTaskBottomSheet(),
    );
  }

  void _showCelebrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Lottie.asset(
                  'assets/animations/celebration.json',
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.celebration,
                      size: 100,
                      color: Colors.white,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _motivationalService.getCelebrationMessage(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'لقد أنجزت جميع مهام اليوم!\nأنت حقاً رائع! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.gradientStart,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'شكراً! 💪',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
