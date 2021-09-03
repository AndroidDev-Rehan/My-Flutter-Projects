import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:sm_app_flutter/models/all_posts.dart';
import 'package:sm_app_flutter/models/post.dart';
import 'package:sm_app_flutter/models/user.dart';
import 'package:sm_app_flutter/screens/newsfeed_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({required this.user,required this.allPosts});

  final User? user;
  final AllPosts allPosts;

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String postText = "";

  @override
  Widget build(BuildContext context) {
    return
     MaterialApp(
       home: SafeArea(
         child: Scaffold(
           appBar: AppBar(
             title: Text('Create Post'),
           ),
           body: Column(
             children: [
            Container(
              height: 240,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                ),
              ),
              child: TextFormField(

                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Whats on your mind? Write Here!"),
                maxLines: null,
                onChanged: (value){
                  postText = value.toString();
                },
              ),
            ),
            ElevatedButton(
                onPressed: (){},
                child: Text("Post")
            )
          ],
        ),
           bottomNavigationBar: ElevatedButton(
             child: Text("Post"),
             onPressed: () async{
//              await AllPosts
            if(postText != ""){
              User? userF = FirebaseAuth.instance.currentUser;
              AppUser appUser = AppUser(uid: userF!.uid, displayName: userF.displayName!, imageUrl: userF.photoURL.toString());

              Post post = Post(user: appUser,postText: postText.trim(), postImgUrl: null,postTime: DateTime.now().millisecondsSinceEpoch,likedBy: []);
 //               AllPosts allPosts =await AllPosts.create();
              await widget.allPosts.insertPost(post);

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => NewsFeedScreen(
                    user: widget.user,
                    allPosts: widget.allPosts,
                  ),
                ),
              );
            }
          },
        ),
      ),
       ),
      );
  }
}
