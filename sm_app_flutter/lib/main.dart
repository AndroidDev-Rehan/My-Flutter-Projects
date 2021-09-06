import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sm_app_flutter/models/all_posts.dart';

import 'screens/sign_in_screen.dart';

//TODO : remove error from widgets_test file by declaring allPosts global
//TODO: !navigator.debug_locked not true

late final AllPosts allPosts;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  allPosts = await AllPosts.create();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterFire Samples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.purple,
          ),
        ),
      ),
      home: SignInScreen(),
    );
  }
}