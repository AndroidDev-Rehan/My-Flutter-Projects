import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_app_flutter/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostTile extends StatelessWidget {
  // final AllPosts allPosts;
  // final int index;
  final Post post;
  const PostTile(this.post);

  final String str = 'I dont know what am I writing but i intend to write something very long for testing purpose. I hope its long enough for 2,3 lines atleast. so whats going on? how was the day and everything else. we can be lol ENOUGH!!!!!!';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: [
          Row(
            children: [
            // Image(
            //   image: NetworkImage('https://live.staticflickr.com/5576/15030055391_c1c22ae3c6_b.jpg'),
            //   height: 40,
            // ),
            CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(post.user.imageUrl)
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.user.displayName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '2 hours ago',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                )
              ],
            )
          ],
        ),
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.fromLTRB(5,0,0,0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  post.postText,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
                    Row(
                    children: [
                      LikeButtonIcon(post : post),
                      Text(
                        post.likedBy.length.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w300
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
    }
}

class LikeButtonIcon extends StatefulWidget {
  final Post post;
  const LikeButtonIcon({required this.post });

  @override
  _LikeButtonIconState createState() => _LikeButtonIconState();
}

class _LikeButtonIconState extends State<LikeButtonIcon> {


  final currUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    if(widget.post.likedBy.contains(currUserId)) {
      return IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        onPressed: () {
//          widget.post.postUnliked(currUserId);

        },
      );
    }
    else{
      return IconButton(
          icon: Icon(
           Icons.favorite,
//           color: Colors.black38,
          color: Colors.black38,
          ),
        onPressed: (){
//          widget.post.postLiked(currUserId);
        },
      );
    }
  }
}

