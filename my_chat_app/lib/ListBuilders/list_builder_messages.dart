import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/Models/Daos/chat_room.dart';
import 'package:my_chat_app/Models/message.dart';
import 'package:my_chat_app/Widgets/single_message.dart';

//This widget will provide listView of single messages for chat room screen

class MessagesList extends StatefulWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> chatRoomDocSS;

  const MessagesList({required this.chatRoomDocSS});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.chatRoomDocSS,
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (!(snapshot.data!.exists)) {
            return Center(child: Text("No messages to show here."));
          }

          // // final x = snapshot.data!["messageList"].map();
          // final Map<String,dynamic> x = snapshot.data!();

          final DocumentSnapshot<Map<String, dynamic>> documentSS =
              snapshot.data!;
          final Map<String, dynamic> map = documentSS.data()!;

          final tempChatRoom = ChatRoom.fromMap(map);

          if (tempChatRoom.messageList.length == 0) {
            return Center(child: Text("No messages to show here."));
          }
          return ListView.builder(
              itemCount: tempChatRoom.messageList.length,
              itemBuilder: (context, index) {
                if(index==tempChatRoom.messageList.length-1) {
                  return SingleMessage(msg: tempChatRoom.messageList[tempChatRoom.messageList.length-index-1],showDate:  true,);
                }
                bool showDate = false;
                //
                final int currMsgTimeInMilis = tempChatRoom.messageList[tempChatRoom.messageList.length-index-1].msgDateTimeInMilis;
                final int nextMsgTimeInMilis = tempChatRoom.messageList[tempChatRoom.messageList.length-index-2].msgDateTimeInMilis;

                final nextMsgDateTime = DateTime.fromMillisecondsSinceEpoch(nextMsgTimeInMilis);
                final currMsgDateTime = DateTime.fromMillisecondsSinceEpoch(currMsgTimeInMilis);

                if(
                    nextMsgDateTime.day != currMsgDateTime.day ||
                    nextMsgDateTime.month != currMsgDateTime.month ||
                    nextMsgDateTime.year != currMsgDateTime.year )
                {
                  showDate = true;
                }

                return SingleMessage(msg: tempChatRoom.messageList[tempChatRoom.messageList.length-index-1],showDate:  showDate,);

              },
            reverse: true,
          );
        });
  }
}
