import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_user.dart';

class UserDao{

  Future<void> insertUser(AppUser appUser) async{
    FirebaseFirestore.instance.collection('users').doc(appUser.uid).set(appUser.toMap());
  }

  Future<AppUser> returnAppUser(String uid) async{
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return AppUser.fromMap(doc.data()!);
  }

  Future<bool> userExistOrNot(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.exists;
  }

}