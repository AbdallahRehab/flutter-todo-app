import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../../features/todos/domain/entities/todo.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - can navigate to task details
    // TODO: Implement navigation to task details
  }

  Future<bool> requestPermissions() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android != null) {
      await android.requestNotificationsPermission();
    }

    final ios = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (ios != null) {
      await ios.requestPermissions(alert: true, badge: true, sound: true);
    }

    return true;
  }

  // Schedule all notifications for a task
  Future<void> scheduleTaskNotifications(Todo todo) async {
    if (!_initialized) await initialize();

    // Cancel existing notifications for this task
    await cancelTaskNotifications(todo.id);

    // 1. Start time notification
    if (todo.notifyOnStart && todo.startTime != null) {
      final startTime = todo.startTime!;
      if (startTime.isAfter(DateTime.now())) {
        await _scheduleNotification(
          id: _getNotificationId(todo.id, 'start'),
          title: '⏰ وقت البدء!',
          body: 'حان وقت البدء في: ${todo.title}',
          scheduledDate: startTime,
          payload: todo.id,
        );
      }
    }

    // 2. Reminder notifications (before deadline)
    if (todo.deadline != null && todo.reminderMinutesBefore.isNotEmpty) {
      for (final minutes in todo.reminderMinutesBefore) {
        final reminderTime = todo.deadline!.subtract(
          Duration(minutes: minutes),
        );

        if (reminderTime.isAfter(DateTime.now())) {
          await _scheduleNotification(
            id: _getNotificationId(todo.id, 'reminder_$minutes'),
            title: '⏳ تذكير بالمهمة',
            body: 'متبقي $minutes دقيقة على: ${todo.title}',
            scheduledDate: reminderTime,
            payload: todo.id,
          );
        }
      }
    }

    // 3. Deadline notification
    if (todo.notifyOnDeadline && todo.deadline != null) {
      if (todo.deadline!.isAfter(DateTime.now())) {
        await _scheduleNotification(
          id: _getNotificationId(todo.id, 'deadline'),
          title: '🔔 الموعد النهائي!',
          body: 'انتهى الوقت المحدد لـ: ${todo.title}',
          scheduledDate: todo.deadline!,
          payload: todo.id,
        );
      }
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'todo_reminders',
      'مهام التذكير',
      channelDescription: 'إشعارات لتذكيرك بمهامك',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  // Show immediate notification (for completed tasks)
  Future<void> showCompletionNotification(Todo todo) async {
    if (!_initialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'todo_completion',
      'إكمال المهام',
      channelDescription: 'إشعارات عند إكمال المهام',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      _getNotificationId(todo.id, 'completed'),
      '✅ أحسنت!',
      'لقد أكملت: ${todo.title}',
      details,
      payload: todo.id,
    );
  }

  // Show celebration notification when all tasks completed
  Future<void> showCelebrationNotification(int completedCount) async {
    if (!_initialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'todo_celebration',
      'احتفالات',
      channelDescription: 'إشعارات احتفالية عند إكمال جميع المهام',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999999,
      '🎉 رائع! أكملت جميع المهام!',
      'لقد أنجزت $completedCount مهمة اليوم. أنت بطل!',
      details,
    );
  }

  // Cancel all notifications for a specific task
  Future<void> cancelTaskNotifications(String todoId) async {
    await _notifications.cancel(_getNotificationId(todoId, 'start'));
    await _notifications.cancel(_getNotificationId(todoId, 'deadline'));

    // Cancel reminder notifications (try common reminder times)
    for (final minutes in [5, 10, 15, 30, 60]) {
      await _notifications.cancel(
        _getNotificationId(todoId, 'reminder_$minutes'),
      );
    }

    await _notifications.cancel(_getNotificationId(todoId, 'completed'));
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Generate unique notification ID from todo ID and type
  int _getNotificationId(String todoId, String type) {
    final combined = '$todoId-$type';
    return combined.hashCode.abs() % 2147483647; // Keep within int32 range
  }

  // Get all pending notifications (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
