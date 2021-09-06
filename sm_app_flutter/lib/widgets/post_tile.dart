import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_app_flutter/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sm_app_flutter/utils/post_dao.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:sm_app_flutter/utils/time_ago.dart';


class PostTile extends StatelessWidget {
  // final AllPosts allPosts;
  // final int index;
  final Post post;
  const PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
            child: Row(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
//                    (post.user.displayName.contains(' ') || post.user.displayName.contains('-'))?
                      post.user.displayName.toLowerCase().capitalizeFirstOfEach ,
//                    post.user.displayName,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (TimeAgo().getTimeAgo(post.postTime)!=null)?
                        TimeAgo().getTimeAgo(post.postTime)! :
                        "NULL TIME"
                        ,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
        ),
          ),
            SizedBox(height: 15,),
            (post.postText=="")?
                SizedBox(height: 0):
            Padding(
              padding: EdgeInsets.fromLTRB(8,0,0,0),
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
            (post.postImgUrl!=null)?
            Container(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: CachedNetworkImage(
                imageUrl: post.postImgUrl!,
                placeholder: (context, url) => CircularProgressIndicator(color: Colors.pink,),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
//              child : Text("Post Image Url is ${post.postImgUrl}"),

            ): SizedBox(height: 0),
            SizedBox(height: 10,),
                    Consumer<Post>(
                      builder: (context,Post data, child) {
                        return Row(
                        children: [
                          LikeButtonIcon(post : post),
                          Text(
                            post.likedBy.length.toString(),
                  style: TextStyle(
                          fontWeight: FontWeight.w300
                  ),
                )
              ],
            );
                      }
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
  final postDao = PostDao();

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
          widget.post.postUnliked(currUserId);
          postDao.removeLikeFromPost(widget.post, currUserId);

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
        onPressed: ()async{
          widget.post.postLiked(currUserId);
          postDao.addLikeToPost(widget.post, currUserId );
        },
      );
    }
  }
}

extension CapExtension on String {
  String get inCaps => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstOfEach => this.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ");
}

class ShowPostImage extends StatefulWidget {
  final String url;
  const ShowPostImage({required this.url}) ;

  @override
  _ShowPostImageState createState() => _ShowPostImageState();
}

class _ShowPostImageState extends State<ShowPostImage> {

  @override
  Widget build(BuildContext context) {
    return Image.network(widget.url);
  }
}
