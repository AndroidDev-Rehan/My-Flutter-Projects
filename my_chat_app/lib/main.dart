import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_chat_app/screens/coversation_list_screen.dart';
import 'package:my_chat_app/screens/home_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification!.title);
}


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  ///OneSignal initialization
  OneSignal.shared.setAppId('59da150b-27d9-41e0-9fea-3c3245c3f8da');
  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    // Display Notification, send null to not display, send notification to display
    event.complete(null);
  });

  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MyApp());


}

class MyApp extends StatelessWidget {


  Future<bool> checkLoggedInStatus() async{
    final User? currUser = FirebaseAuth.instance.currentUser;
    if(currUser==null) {
      return false;
    }
    else if(!(await checkIfDocExists(currUser.uid))){
      return false;
    }
    return true;
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: AnimatedSplashScreen.withScreenFunction(
        splash: Icons.chat,
        screenFunction: ()async{
          await Future.delayed(Duration(seconds: 3));
          return SafeArea(
              child: (
                  await checkLoggedInStatus())? ConversationsListScreen()
              : MyHomePage(title: 'Registration Screen')
          );
        },
        splashTransition: SplashTransition.rotationTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
      ),

      //Comment the routes afterwords
      // initialRoute: MyRoutes.chatHeadsList,
      // routes: {
      //   MyRoutes.chatRoomScreeen : (context) => ChatRoomScreen(),
      // },

    );
  }
}




