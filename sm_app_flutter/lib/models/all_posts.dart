import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sm_app_flutter/models/post.dart';

//class AllPosts extends ChangeNotifier{
class AllPosts {
  List<Post> _postsList = [];


  // final FirebaseFirestore db = FirebaseFirestore.instance;
  // final postCollection = db.collection('posts');

  AllPosts._create();

  List<Post> get getList {
    return _postsList;
  }

  // TODO: Fill this postsList by fetching data from firebase. 
  static Future<AllPosts> create() async {
    var allPosts = AllPosts._create();
    await allPosts.fillList();
    return allPosts;
  }
  
  fillList() async{
    //Note : This was the old way I was doing it
    // final QuerySnapshot<Map<String,dynamic>> allDocs = await FirebaseFirestore.instance.collection('posts').get();
    // _postsList = allDocs.docs.map(
    //         (doc) => Post.fromMap(doc.data())
    // ).toList();

    //Note: New Way of doing it.
     final QuerySnapshot<Map<String,dynamic>> allDocs =await FirebaseFirestore.instance.collection('posts').orderBy('postTime',descending: true).get();
    _postsList = allDocs.docs.map(
            (doc) => Post.fromMap(doc.data())
    ).toList();


  }




  Future<void> insertPost(Post post) async{
//    _postsList.add(post);
    _postsList.insert(0, post);

    final db = FirebaseFirestore.instance;
    await db.collection('posts').add(post.toMap());
//    notifyListeners();
  }

}
