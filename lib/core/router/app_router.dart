import 'package:go_router/go_router.dart';
import '../../features/todos/presentation/pages/splash_page.dart';
import '../../features/todos/presentation/pages/todo_list_page.dart';
import '../../features/todos/presentation/pages/todo_detail_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashPage()),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: TodoListPage()),
      ),
      GoRoute(
        path: '/todo/:id',
        name: 'todoDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TodoDetailPage(todoId: id);
        },
      ),
    ],
  );
}
