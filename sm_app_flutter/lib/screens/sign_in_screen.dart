import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sm_app_flutter/models/all_posts.dart';
import 'package:sm_app_flutter/models/user.dart';
import 'package:sm_app_flutter/utils/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'newsfeed_screen.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen();

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  // Future<void> initFirebase() async{
  //   await Authentication(widget.allPosts).initializeFirebase(context: context);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text("Login Screen"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: FutureBuilder(
          future: Authentication.initializeFirebase(context: context,fromSignOut: true),
//        future: initFirebase(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error initializing Firebase');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return GoogleSignInButton();
            }
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.orange,
              ),
            );
          },
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton();

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool isSigningIn = false;

  onSignInPressed(BuildContext context) async{
    setState(() {
      isSigningIn = true;
    });

    User? user =
    await Authentication.signInWithGoogle(context: context);

    setState(() {
      isSigningIn = false;
    });

    if (user != null) {

      AppUser appUser = AppUser(uid: user.uid, displayName: user.displayName!, imageUrl: user.photoURL.toString());

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => NewsFeedScreen(
            user: user,
          ),
        ),
      );
      await FirebaseFirestore.instance.collection('users').doc(appUser.uid).set(appUser.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isSigningIn)
    // return IconButton(
    //     icon: Image.asset('assets/images/google_logo.png'),
    //     onPressed: () async {
    //     onSignInPressed(context);
    //     }

      return Container(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: InkWell(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            onTap: () async{
             onSignInPressed(context);
            },
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.circular(15),
        ),
      );
    
      // return ElevatedButton.icon(
      //   icon: Icon(
      //     Icons.login,
      //     color: Colors.orange,
      //     size: 24.0,
      //   ),
      //   label: Text('Sign In With Google'),
      //   onPressed: () async{
      //     onSignInPressed(context);
      //     },
      // );

    else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }

  }
}


