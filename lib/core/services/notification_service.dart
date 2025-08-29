// import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await NotificationService.instance.setupFlutterNotifcations();
//   await NotificationService.instance.showNotification(message);
// }
//
// Future<void> initATT() async {
//   final status = await AppTrackingTransparency.trackingAuthorizationStatus;
//   print('.............');
//   print('............${status}');
//   if (status == TrackingStatus.notDetermined) {
//     await AppTrackingTransparency.requestTrackingAuthorization();
//     print('>>>>>>>>>>>>>>${status}');
//
//   }
// }
//
// class NotificationService {
//   NotificationService._();
//   static final NotificationService instance = NotificationService._();
//
//   final _messaging = FirebaseMessaging.instance;
//   final _localNotifications = FlutterLocalNotificationsPlugin();
//   bool _isFlutterLocalNotificationsInitialized = false;
//
//   Future<void> initialize({required Function(Map<String, dynamic>) onNotificationTap}) async {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     await _requestPermission();
//
//     await _setupMessageHandlers(onNotificationTap);
//
//     try {
//       final token = await _messaging.getToken();
//       print('FCM Token: $token');
//     } catch (e) {
//       debugPrint('FCM Token Error: $e');
//     }
//     // debugPrint('FCM Token: $token');
//
//     final apnsToken = await _messaging.getAPNSToken();
//     debugPrint('APNS Token: $apnsToken');
//   }
//
//   Future<void> _requestPermission() async {
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     debugPrint('User granted permission: ${settings.authorizationStatus}');
//   }
//
//   Future<void> setupFlutterNotifcations() async {
//     if (_isFlutterLocalNotificationsInitialized) {
//       return;
//     }
//
//     const channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high,
//       enableVibration: true,
//     );
//
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//
//     const initializationSettingsAndroid = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//
//     const initializationSettingsDarwin = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     const initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );
//
//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (payload) async {
//         debugPrint('Notification payload: $payload');
//       },
//     );
//
//     _isFlutterLocalNotificationsInitialized = true;
//   }
//
//   Future<void> showNotification(
//     RemoteMessage message,
//   ) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification == null && android == null) return;
//
//     await _localNotifications.show(
//       notification.hashCode,
//       notification?.title,
//       notification?.body,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           channelDescription:
//               'This channel is used for important notifications.',
//           icon: '@mipmap/ic_launcher',
//           color: Colors.green,
//           playSound: true,
//           enableVibration: true,
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       payload: message.data.toString(),
//     );
//   }
//
//   Future<void> _setupMessageHandlers(Function(Map<String, dynamic>) onNotificationTap) async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     FirebaseMessaging.onMessage.listen((message) {
//       debugPrint('onMessage: $message');
//       showNotification(message);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
//     // final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     // if (initialMessage != null) {
//     //   _handleBackgroundMessage(initialMessage);
//     // }
//
//     final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       debugPrint('getInitialMessage: ${initialMessage.messageId}');
//       onNotificationTap(initialMessage.data);
//     }
//   }
//
//
//   Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//     if (message.data['type'] == 'chat') {}
//
//     // debugPrint('onMessageOpenedApp: $message');
//     // showNotification(message);
//   }
// }

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await setupFlutterNotifications();
    await _setupMessageHandlers();

    try {
      final token = await _messaging.getToken();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token ?? 'xxxx');
      print('FCM Token: $token');
    } catch (e) {
      debugPrint('FCM Token Error: $e');
    }

    final apnsToken = await _messaging.getAPNSToken();
    debugPrint('APNS Token: $apnsToken');
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'For important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          try {
            final data = jsonDecode(response.payload!);
            debugPrint('Local notification tapped: $data');
            // _handleMessageNavigation(data);
          } catch (e) {
            debugPrint('Error parsing payload: $e');
          }
        }
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification == null && android == null) return;

    final payload = {
      ...message.data,
      'title': notification?.title,
      'body': notification?.body,
    };

    await _localNotifications.show(
      notification.hashCode,
      notification?.title,
      notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(payload),
    );
  }

  Future<void> _setupMessageHandlers() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(showNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final data = {
        ...message.data,
        'title': message.notification?.title,
        'body': message.notification?.body,
      };
      debugPrint('App opened from background tap: $data');
      // _handleMessageNavigation(data);
    });
  }

  void handleInitialMessage(RemoteMessage message) {
    final data = {
      ...message.data,
      'title': message.notification?.title,
      'body': message.notification?.body,
    };
    debugPrint('App opened from terminated state: $data');
    // _handleMessageNavigationForTerminatedState(data);
  }

  // void _handleMessageNavigation(Map<String, dynamic> data) {
  //   final title = data['title']?.toString() ?? '';
  //   if (title.contains('Flutter')) {
  //     navigatorKey.currentState?.pushNamed('/stripe');
  //   }else if(title.contains('Last Call - Don’t Miss Your First Payday!')){
  //     navigatorKey.currentState?.pushNamed('/stripe');
  //   }
  //   else if(title.contains('Offer Passed Up—Snag the Next!')){
  //     navigatorKey.currentState?.pushNamed('/homepage');
  //   }else{
  //     navigatorKey.currentState?.pushNamed('/home');
  //   }
  // }
  //
  // void _handleMessageNavigationForTerminatedState(Map<String, dynamic> data) {
  //   final title = data['title']?.toString() ?? '';
  //   if (title.contains('Stripe = Payday!')) {
  //     navigatorKey.currentState?.pushNamed('/stripe1');
  //   }else if(title.contains('Last Call - Don’t Miss Your First Payday!')){
  //     navigatorKey.currentState?.pushNamed('/stripe1');
  //   }
  //   else if(title.contains('Offer Passed Up—Snag the Next!')){
  //     navigatorKey.currentState?.pushNamed('/homepage1');
  //   }else{
  //     navigatorKey.currentState?.pushNamed('/home');
  //   }
  // }
}
