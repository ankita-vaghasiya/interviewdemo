import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

ValueNotifier<String> notificationBody = ValueNotifier<String>('');

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('receiveNotification _firebaseMessagingBackgroundHandler data: ${message.data}');
}

class FireBaseNotification {
  static final FireBaseNotification _fireBaseNotification = FireBaseNotification.init();

  factory FireBaseNotification() {
    return _fireBaseNotification;
  }

  FireBaseNotification.init();

  late FirebaseMessaging firebaseMessaging;
  late AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    // importance: Importance.high,
    importance: Importance.max,
  );

  final _selectNotificationSubject = BehaviorSubject<String?>();
  // final SyncPhotosController _photosController = Get.put(SyncPhotosController());

  Stream<String?> get selectNotificationStream => _selectNotificationSubject.stream;

  final _didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

  Stream<ReceivedNotification> get didReceiveLocalNotificationStream => _didReceiveLocalNotificationSubject.stream;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static bool isNotification = false;

  void firebaseCloudMessagingLSetup() async {
    firebaseMessaging = FirebaseMessaging.instance;
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    iOSPermission(firebaseMessaging);

    await firebaseMessaging.getToken().then((token) {
      String firebaseToken = token ?? '';
      log('FCM TOKEN to be Registered: $token');
      debugPrint('FCM TOKEN to be Registered: $token');
    });

    // Fired when app is coming from a terminated state
    // var initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // if (initialMessage != null) _showLocalNotification(initialMessage);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // If the message also contains a data property with a “type” of “chat”,
    // navigate to a chat screen
    if (initialMessage != null) {
      selectNotification(json.encode(initialMessage.data));

      // Constants.notificationNavigationName = initialMessage.data['redirect'].toString();
      // log("NavigationUtils.notificationNavigationName  : ${Constants.notificationNavigationName}");
      // NavigationUtils.notificationKlokmateId = initialMessage.data['klokmateid'].toString();
    }

    // Fired when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('receiveNotification onAppOpen onMessage data: ${message.toMap()}');
      log('receiveNotification onAppOpen onMessage data: ${message.toMap()}');

      // AppSnackBar.showErrorSnackBar(message: 'You can add more photos!!!', title: 'success');
      // await _photosController.addMore().then((value) => _photosController.addPhotoApi());

      showLocalNotification(message);
      notificationBody.value = message.notification?.title?.toString() ?? '';
    });

    // Fired when app is in foreground
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('receiveNotification onAppBackgroundOrClose onMessageOpenedApp data: ${message.toMap()}');
      selectNotification(json.encode(message.data));
      debugPrint('Got a message, app is in the foreground! ${message.data.toString()}');
    });
  }

  Future<void> setUpLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
            ) async {
          _didReceiveLocalNotificationSubject.add(
            ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ),
          );
        });

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings, /*onSelectNotification: (String? payload) => selectNotification(payload)*/
    );
    print("flutterLocalNotificationsPlugin Complete");
  }

  Future selectNotification(String? notificationPayload) async {
    if (notificationPayload != null && notificationPayload.isNotEmpty) {
      debugPrint('receiveNotification getInitialMessage 00');
      _selectNotificationSubject.add(notificationPayload);
    }
  }

  void iOSPermission(firebaseMessaging) {
    firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        largeIcon: DrawableResourceAndroidBitmap('@drawable/ic_launcher' /*'@mipmap/launcher_icon'*/),
        icon: '@drawable/ic_launcher' /*'@mipmap/launcher_icon'*/,
        priority: Priority.max,
        color: Colors.black,
        ticker: 'ticker');
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    if (notification?.title != null) {
      await flutterLocalNotificationsPlugin.show(0, notification?.title, notification?.body, platformChannelSpecifics,
          payload: json.encode(message.data));
    }

    // AndroidNotification? android = message.notification?.android;
    // flutterLocalNotificationsPlugin.show(
    //   notification.hashCode,
    //   notification!.title,
    //   notification.body,
    //   NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       channel.id,
    //       channel.name,
    //       // channel.description,
    //       // TODO add a proper drawable resource to android, for now using
    //       //      one that already exists in example app.
    //       icon: 'launch_background',
    //     ),
    //   ),
    // );
  }

  void localNotificationRequestPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void configureDidReceiveLocalNotificationSubject() {
    print('configureDidReceiveLocalNotificationSubject stream listen');
    didReceiveLocalNotificationStream.listen((ReceivedNotification receivedNotification) async {
      print("payloadNotification 01: $receivedNotification");
      // notificationToNavigate();
    });
  }

  void configureSelectNotificationSubject() async {
    selectNotificationStream.listen((String? payload) async {
      print('receiveNotification configureSelectNotificationSubject 00 :$payload');
      Map<String, dynamic> data = payload != null ? json.decode(payload) : {};
      print('decode Data -->>>${data}   data redict :--> ${data['redirect']}');
/*        Map<String, dynamic> newData = json.decode(data['data']);
        print('decode Data -->>>:${newData}');*/
      // log('routes : $routes');
      await Future.delayed(Duration(milliseconds: 300));
      // Navigation.pushNamed(data['redirect'],arg: {"bot" : data['botId']});
      if (data['botId'] != null) {
        //Navigation.pushNamed(data['redirect'], arg: {"bot": data['botId']});
        // Navigation.pushNamed("/my_bots/martingle", arg: {"bot": 139});
      }
      // NavigationUtils.navigationSwitch(data);
    });
  }

  void localNotificationDispose() {
    _didReceiveLocalNotificationSubject.close();
    _selectNotificationSubject.close();
  }
}

class Navigation {
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
