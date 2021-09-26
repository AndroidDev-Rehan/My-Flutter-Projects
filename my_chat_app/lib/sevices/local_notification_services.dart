import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';




class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
    ///this onSelectNotification is for when notifications show in foreground
    //     onSelectNotification: (String? route) async{
    //   if(route != null){
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (context) => ConversationsListScreen(
    //         ),
    //       ),
    //     );
    //   }
    // }

    );
  }

  static void display(RemoteMessage message) async {

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "chatapp",
            "chatapp channel",
            "this is our channel",
            importance: Importance.max,
            priority: Priority.high,
          )
      );


      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        ///payload will trigger onSelected of [_notificationsPlugin.initialize]
//        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }

}