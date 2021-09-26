
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/Models/Daos/chat_room.dart';
import 'package:my_chat_app/Models/Daos/user_dao.dart';
import 'package:my_chat_app/Models/app_user.dart';
import 'package:my_chat_app/Widgets/my_drawer.dart';
import 'package:my_chat_app/Widgets/single_chat_head.dart';
import 'package:my_chat_app/screens/current_users_list_screen.dart';

class ConversationsListScreen extends StatelessWidget {

  late final AppUser appUser;


  ///Firebase messaging notifications handling
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //
  //
  //
  //   LocalNotificationService.initialize(context);
  //
  //   ///gives you the message on which user taps
  //   ///and it opened the app from terminated state
  //   FirebaseMessaging.instance.getInitialMessage().then((message) {
  //     // if(message != null){
  //     //   final routeFromMessage = message.data["route"];
  //     //
  //     //   Navigator.of(context).pushNamed(routeFromMessage);
  //     // }
  //
  //     Fluttertoast.showToast(msg: "Notification is working when app is in terminated state!!");
  //
  //
  //   });
  //
  //   ///forground work
  //   FirebaseMessaging.onMessage.listen((message) {
  //     if(message.notification != null){
  //       print(message.notification!.body);
  //       print(message.notification!.title);
  //     }
  //
  //     LocalNotificationService.display(message);
  //   });
  //
  //   ///When the app is in background but opened and user taps
  //   ///on the notification
  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     // final routeFromMessage = message.data["route"];
  //     //
  //     // Navigator.of(context).pushNamed(routeFromMessage);
  //
  //     Fluttertoast.showToast(msg: "Notification is working!!");
  //
  //   });
  //
  //
  //
  // }




  Future<void> setAppUser() async {
    final currUserId = FirebaseAuth.instance.currentUser!.uid;
    appUser = await UserDao().returnAppUser(currUserId);
//    configOneSignel();
    // Future.delayed(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setAppUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text("My Chat App"),
            ),
            drawer: MyDrawer(appUser : appUser),

            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('AllChatRooms')
                    .where('users', arrayContains: appUser.toMap())
                    .orderBy('lastMsgDateTimeMilis', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final ChatRoom tempChatRoom = ChatRoom.fromMap(
                              snapshot.data!.docs[index].data());
                          List<AppUser> tempUsers = tempChatRoom.users;

                          AppUser? otherAppUser;

                          if (tempUsers[0].uid ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            otherAppUser = tempUsers[1];
                          } else {
                            otherAppUser = tempUsers[0];
                          }

                          return SingleChatHead(
                            otherUser: otherAppUser,
                            msg: tempChatRoom.lastMsg!,
                            // msg: Message.fromMap(snapshot.data!.docs[index].get('lastMsg')),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            //   }
            // ),

            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.message),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CurrentUsersList(),
                  ),
                );
              },
            ),
          );
        });
  }
}
