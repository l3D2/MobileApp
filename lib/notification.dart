import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(android: AndroidInitializationSettings("notiicon"));
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // เพิ่มเติม: ฟังก์ชันสำหรับแสดงการแจ้งเตือน
  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformSpecifics =
        AndroidNotificationDetails('1000', 'Noti',
            channelDescription: 'Your channel description',
            importance: Importance.max,
            priority: Priority.high);
    const NotificationDetails platformSpecifics =
        NotificationDetails(android: androidPlatformSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, body, platformSpecifics);
  }
}