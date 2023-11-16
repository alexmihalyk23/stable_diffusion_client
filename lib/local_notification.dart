import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification{

  static Future initialize (FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitilize =const AndroidInitializationSettings('mipmap/ic_launcher');



    var initilizationSettings= InitializationSettings(android: androidInitilize);

    await flutterLocalNotificationsPlugin.initialize(initilizationSettings);

  }
  static Future showBigTextNotification({

    var id=0,
    required String title,
    required String body,
    var payload,
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
}) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(

        'Mychannel_id',
      'channel_name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,


    );
    var not = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(0, title, body, not);

  }


}