// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
//   static const String _notificationEnabledKey = 'notifications_enabled';

//   Future<void> initialize() async {
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
    
//     const initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _notifications.initialize(initSettings);
//   }

//   Future<bool> isNotificationsEnabled() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_notificationEnabledKey) ?? true;
//   }

//   Future<void> setNotificationsEnabled(bool enabled) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_notificationEnabledKey, enabled);
//   }

//   Future<void> showNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     if (!await isNotificationsEnabled()) return;

//     const androidDetails = AndroidNotificationDetails(
//       'ctech_channel',
//       'CTech Notifications',
//       channelDescription: 'Notifications for CTech app',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notifications.show(
//       DateTime.now().millisecond,
//       title,
//       body,
//       details,
//       payload: payload,
//     );
//   }

//   Future<void> showQuizReminder() async {
//     await showNotification(
//       title: 'Time for a Quiz!',
//       body: 'Take a quick quiz to discover your tech career path.',
//       payload: '/quiz',
//     );
//   }

//   Future<void> showCareerUpdate() async {
//     await showNotification(
//       title: 'New Career Opportunities',
//       body: 'Check out the latest tech career profiles.',
//       payload: '/careers',
//     );
//   }

//   Future<void> showTechWordOfTheDay() async {
//     await showNotification(
//       title: 'Tech Word of the Day',
//       body: 'Learn a new tech term to expand your knowledge.',
//       payload: '/tech-words',
//     );
//   }
// } 