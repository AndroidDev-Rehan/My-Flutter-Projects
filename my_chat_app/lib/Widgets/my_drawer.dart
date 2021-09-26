import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/Models/Daos/user_dao.dart';
import 'package:my_chat_app/Models/app_user.dart';

class MyDrawer extends StatelessWidget {

  final AppUser appUser;

  const MyDrawer({Key? key, required this.appUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final imageUrl = user.imgUrl;
    return           Drawer(
          child: Container(
            color: Colors.redAccent,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: UserAccountsDrawerHeader(
                    margin: EdgeInsets.zero,
                    accountName: Text(appUser.userName),
                    accountEmail: Text(FirebaseAuth.instance.currentUser!.phoneNumber!),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(appUser.imgUrl),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.home,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Home",
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.profile_circled,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Profile",
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.mail,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Email me",
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
    //   }
    // );
  }
}