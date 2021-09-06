import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sm_app_flutter/models/post.dart';

class PostDao{

  final db = FirebaseFirestore.instance;

  addLikeToPost(Post post, String uid) {
    final Post newPost = post;
    db.collection('posts').doc(post.postId).set(newPost.toMap());
  }

  removeLikeFromPost(Post post, String uid){
    final Post newPost = post;
    db.collection('posts').doc(post.postId).set(newPost.toMap());

  }

}