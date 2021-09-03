import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sm_app_flutter/models/all_posts.dart';
import 'package:sm_app_flutter/screens/create_post_screen.dart';
import 'package:sm_app_flutter/screens/sign_in_screen.dart';
import 'package:sm_app_flutter/utils/authentication.dart';
import 'package:sm_app_flutter/widgets/posts_builder.dart';
//import 'package:provider/provider.dart';


class NewsFeedScreen extends StatefulWidget {

  final User? user;
  final AllPosts allPosts;

  const NewsFeedScreen({required this.user,required this.allPosts});

  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(allPosts: widget.allPosts,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return
      // ChangeNotifierProvider<AllPosts>(
      // create: (context) => widget.allPosts,
      // child:
      MaterialApp(
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("NewsFeedScreen"),
            ),
            body: (
                Column(
                  children: [
                    Container(
                     child: Text(widget.user!.uid.toString()),
                    ),
                    Container(
                      child: Text(widget.user!.displayName.toString()),
                    ),
                    Container(
                      child: Text(widget.user!.email.toString()),
                    ),
                    Center(
                      child:(!_isSigningOut)?
                      ElevatedButton(
                        child: Text("Sign Out"),
                          onPressed: () async {
                            setState(() {
                              _isSigningOut = true;
                            });
                            await Authentication.signOut(context: context);
                            setState(() {
                              _isSigningOut = false;
                            });
                            Navigator.of(context)
                                .pushReplacement(_routeToSignInScreen());
                          }
                      ) :
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    ),
                    // Consumer(
                    //   builder: (context,AllPosts data,child) {
                    //     return
                          Expanded(
                            child: PostsBuilder(allPosts: widget.allPosts,)
                        )
                      // }
                      // )
                  ],
                )
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CreatePost(
                      user: widget.user,
                      allPosts: widget.allPosts,
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.add
              ),
            ),
          ),
        ),
      );
//    );
  }
}


