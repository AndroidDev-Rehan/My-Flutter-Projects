import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sm_app_flutter/models/user.dart';

class Post{
  final AppUser user;
  final String postText;
  final int postTime;
  final String? postImgUrl;

  final List<String> likedBy;

  Post({required this.user, required this.postText, required this.postTime,required this.postImgUrl,required this.likedBy});

  factory  Post.fromMap(Map<String,dynamic> map){
    return Post(
        user: AppUser.fromMap(map['user']),
        postText: map['postText'],
        postTime: map['postTime'],
        postImgUrl: map['postImgUrl'],
        likedBy: List<String>.generate(map['likedBy'].length, (index) => map['likedBy'][index])
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'user' : user.toMap(),
      'postText' : postText,
      'postTime' : postTime,
      'postImgUrl': postImgUrl,
      'likedBy' : likedBy

    };
  }

  // postLiked(String uid){
  //   likedBy.add(uid);
  //   notifyListeners();
  // }
  //
  // postUnliked(String uid){
  //   likedBy.remove(uid);
  //   notifyListeners();
  // }

}

//      'likedBy' : List<String>.generate(likedBy.length, (index) => likedBy[index])
//      likedBy: map['likedBy'] as List<String>,
