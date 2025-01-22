import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/logo');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    tz.initializeTimeZones();

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        // Handle notification tap
      },
    );

    _isInitialized = true;
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String id,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    try {
      await _notifications.zonedSchedule(
        id.hashCode,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        NotificationDetails(
          android: const AndroidNotificationDetails(
            'kb_channel',
            'KB Notifications',
            channelDescription: 'Notifications for KB schedules',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
      rethrow;
    }
  }

  Future<void> cancelNotification(String id) async {
    if (!_isInitialized) {
      await init();
    }

    try {
      await _notifications.cancel(id.hashCode);
    } catch (e) {
      print('Error cancelling notification: $e');
      rethrow;
    }
  }

  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) {
      await init();
    }

    try {
      await _notifications.cancelAll();
    } catch (e) {
      print('Error cancelling all notifications: $e');
      rethrow;
    }
  }
}