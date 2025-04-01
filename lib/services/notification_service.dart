import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    // Request permission for notifications (Android 13+ and iOS)
    if (await Permission.notification.isDenied ||
        await Permission.notification.isPermanentlyDenied) {
      final status = await Permission.notification.request();
      if (!status.isGranted) {
        print('Notification permission denied.');
        return;
      }
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);
  }

  Future<void> showNow(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'instant_channel',
      'Instant Notifications',
      channelDescription: 'Instant notifications for app events',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
    );
  }

  Future<void> scheduleNotification(
      String title, String body, int secondsDelay) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'scheduled_channel_id',
      'Scheduled Notifications',
      channelDescription: 'Notifications for Foodie Finder',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: secondsDelay));

    await _notificationsPlugin.zonedSchedule(
      1,
      title,
      body,
      scheduledTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
