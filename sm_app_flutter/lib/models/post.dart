import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sm_app_flutter/models/user.dart';

class Post extends ChangeNotifier{
  final AppUser user;
  final String postText;
  final int postTime;
  final String? postImgUrl;

  final List<String> likedBy;

  final String postId;

  Post({required this.user, required this.postText, required this.postTime,required this.postImgUrl,required this.likedBy,required this.postId});

  factory  Post.fromMap(Map<String,dynamic> map){
    return Post(
        user: AppUser.fromMap(map['user']),
        postText: map['postText'],
        postTime: map['postTime'],
        postImgUrl: map['postImgUrl'],
        likedBy: List<String>.generate(map['likedBy'].length, (index) => map['likedBy'][index]),
        postId: map['postId'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'user' : user.toMap(),
      'postText' : postText,
      'postTime' : postTime,
      'postImgUrl': postImgUrl,
      'likedBy' : likedBy,
      'postId' : postId,

    };
  }

  postLiked(String uid){
    likedBy.add(uid);
    notifyListeners();
  }

  postUnliked(String uid){
    likedBy.remove(uid);
    notifyListeners();
  }

}

//      'likedBy' : List<String>.generate(likedBy.length, (index) => likedBy[index])
//      likedBy: map['likedBy'] as List<String>,
