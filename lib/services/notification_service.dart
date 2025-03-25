import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);
  }

  Future<void> scheduleNotification(
      String title, String body, int secondsDelay) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
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
      1, // Notification ID
      title,
      body,
      scheduledTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // Removed the dateInterpretation parameter completely
    );
  }
}