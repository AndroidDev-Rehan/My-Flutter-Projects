import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat_app/ListBuilders/list_builder_messages.dart';
import 'package:my_chat_app/Models/Daos/single_user_all_convos.dart';
import 'package:my_chat_app/Models/Daos/user_dao.dart';
import 'package:my_chat_app/Models/app_user.dart';
import 'package:my_chat_app/Models/message.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart';

class ChatRoomScreen extends StatelessWidget {
  final AppUser user2;

  ChatRoomScreen({required this.user2});

  String docIdGenerator() {
    final currUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currUserId.compareTo(user2.uid) == -1) {
      return "$currUserId-${user2.uid}";
    }
    return "${user2.uid}-$currUserId";
  }

  final List<AppUser> users = [];

  Future<void> fillUsersList() async {
    final currUser = FirebaseAuth.instance.currentUser;
    final currAppUser = await UserDao().returnAppUser(currUser!.uid);

    if (currAppUser.uid.compareTo(user2.uid) == -1) {
//      users = [currAppUser,user2];
      users.insert(0, currAppUser);
      users.insert(1, user2);
    } else {
      users.insert(0, user2);
      users.insert(1, currAppUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "ChatRoom Screen has received ${user2.userName} as user2 and forwarding the exact same to Create Message");
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(user2.imgUrl), fit: BoxFit.cover),
              color: Colors.deepPurple,
            ),
          ),
        ),
        title: Text(user2.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: fillUsersList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return MessagesList(
                      // chatRoom: singleUserAllConversations.returnChatRoom(users),
                      chatRoomDocSS: FirebaseFirestore.instance
                          .collection('AllChatRooms')
                          .doc(docIdGenerator())
                          .snapshots(),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ),
          CreateMsg(
            otherUser: user2,
          ),
        ],
      ),
      // bottomNavigationBar: CreateMsg(),
    );
  }
}



class CreateMsg extends StatelessWidget {
  final myController = TextEditingController();
  final AppUser otherUser;
//  XFile? _xFileImage;
  final ImagePicker picker = ImagePicker();



  CreateMsg({required this.otherUser});

  String docIdGenerator() {
    final currUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currUserId.compareTo(otherUser.uid) == -1) {
      return "$currUserId-${otherUser.uid}";
    }
    return "${otherUser.uid}-$currUserId";
  }

  Future<String> uploadImageToFirebaseAndReturnUrl(String xFileImagePath) async {

    Fluttertoast.showToast(msg: "Sending Image. Please wait.");

    File imgFile = File(xFileImagePath);


    FirebaseStorage storage = FirebaseStorage.instance;

    final ref = storage.ref(Uuid().v4().toString());

    await ref.putFile(imgFile);
    return await ref.getDownloadURL();

  }


  _imgFromCamera() async{
    XFile? image = await  picker.pickImage(
        source: ImageSource.camera, imageQuality: 20);

    if(image!=null)
    {
      String imgUrl = await uploadImageToFirebaseAndReturnUrl(image.path);
      await sendImgMessage(imgUrl);
    }

  }

  _imgFromGallery() async {
    XFile? image = await  picker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);

    if(image!=null)
    {
      String imgUrl = await uploadImageToFirebaseAndReturnUrl(image.path);
      await sendImgMessage(imgUrl);
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery '),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<void> sendMessage() async{
    final currUser = FirebaseAuth.instance.currentUser;
    final DateTime msgDateTime = DateTime.now();
    if ((myController.text != "")) {
      final Message msg = Message(
        authorId: currUser!.uid,
        msgDateTimeInMilis: msgDateTime.millisecondsSinceEpoch,
        text: myController.text,
        //TODO IMG URL NULL
        imgUrl: null,
      );
      final currAppUser = await UserDao().returnAppUser(currUser.uid);
      List<AppUser> users = [];
      if (currAppUser.uid.compareTo(otherUser.uid) == -1) {
        users = [currAppUser, otherUser];
      } else {
        users = [otherUser, currAppUser];
      }

      SingleUserAllConversations()
          .addMessageToChatRoom(msg, docIdGenerator(), users);

      myController.text = "";
      await sendNotification([otherUser.userToken], msg.text , currAppUser.userName);
    }


  }

  Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading) async{

    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>
      {
        "app_id": '59da150b-27d9-41e0-9fea-3c3245c3f8da',//kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList,//tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color":"FF9976D2",

//        "small_icon":"ic_stat_onesignal_default",

        "large_icon":"https://icons.iconarchive.com/icons/martz90/circle/256/messages-icon.png",

        "headings": {"en": heading},

        "contents": {"en": contents},


      }),
    );
  }



  Future<void> sendImgMessage(String imgUrl) async{
    final currUser = FirebaseAuth.instance.currentUser;
    final DateTime msgDateTime = DateTime.now();
      final Message msg = Message(
        authorId: currUser!.uid,
        msgDateTimeInMilis: msgDateTime.millisecondsSinceEpoch,
        text: "",
        //TODO IMG URL NULL
        imgUrl: imgUrl,
      );
      final currAppUser = await UserDao().returnAppUser(currUser.uid);
      List<AppUser> users = [];
      if (currAppUser.uid.compareTo(otherUser.uid) == -1) {
        users = [currAppUser, otherUser];
      } else {
        users = [otherUser, currAppUser];
      }

      SingleUserAllConversations()
          .addMessageToChatRoom(msg, docIdGenerator(), users);

  }

  @override
  Widget build(BuildContext context) {
    print("Create Message has received user2 as ${otherUser.userName}");
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 0, 8),
            child: TextFormField(
              controller: myController,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
          child: InkWell(
            child: Icon(
              Icons.add_a_photo,
              size: 35,
            ),
            onTap: () async {
              _showPicker(context);
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
          child: InkWell(
            child: Icon(
              Icons.send_rounded,
              size: 35,
            ),
            onTap: () async {
              await sendMessage();
            },
          ),
        )
      ],
    );
  }
}
