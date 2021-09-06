import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sm_app_flutter/models/all_posts.dart';
import 'package:sm_app_flutter/models/post.dart';
import 'package:sm_app_flutter/models/user.dart';
import 'package:sm_app_flutter/screens/newsfeed_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class CreatePost extends StatefulWidget {
  const CreatePost();

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  bool uploading = false;

  XFile? _xFileImage;
  String postText = "";
  bool addImgButtonDisable = false;
//  String? postImgUrl;

  ImagePicker picker = ImagePicker();

  _imgFromCamera() async{
    XFile? image = await  picker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    if(image!=null)
    {
      setState(() {
        _xFileImage = image;
      });
    }

  }

  _imgFromGallery() async {
    XFile? image = await  picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

  if(image!=null)
    {
      setState(() {
        _xFileImage = image;
      });
    }
  }

  Future<String> uploadImageToFirebase(BuildContext context) async {

    File imgFile = File(_xFileImage!.path);

    FirebaseStorage storage = FirebaseStorage.instance;

    final ref = storage.ref(Uuid().v4().toString());

//    await storage.ref(_xFileImage!.path).putFile(imgFile);
//    return await storage.ref(_xFileImage!.path).getDownloadURL();

    await ref.putFile(imgFile);
    return await ref.getDownloadURL();

  }




  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery '),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return
     MaterialApp(
       home: SafeArea(
         child: Scaffold(
           appBar: AppBar(
             backgroundColor: Colors.deepPurple,
             title: Text('Creating Post'),
             actions: [
               Padding(
                 padding: EdgeInsets.all(8),
                 child: ElevatedButton(
                   child: Text("POST"),

                   onPressed: () async{
                     setState(() {
                       uploading = true;
                     });
                     if((postText != "") || (_xFileImage!=null)) {
                       Fluttertoast.showToast(msg: "Uploading Post...");
                       User? userF = FirebaseAuth.instance.currentUser;
                       AppUser appUser = AppUser(uid: userF!.uid, displayName: userF.displayName!, imageUrl: userF.photoURL.toString());

                       String? postImgUrl;
                       if(_xFileImage!=null){
                         postImgUrl =await uploadImageToFirebase(context);
                       }

                       Post post = Post(user: appUser,postText: postText.trim(), postImgUrl: postImgUrl,postTime: DateTime.now().millisecondsSinceEpoch,likedBy: [], postId: Uuid().v4().toString());
                       AllPosts allPosts =await AllPosts.create();
                       await allPosts.insertPost(post);
                       Navigator.of(context).pushReplacement(
                         MaterialPageRoute(
                           builder: (context) => NewsFeedScreen(
                             user: userF,
                           ),
                         ),
                       );
                     }
                   },
                   style: ElevatedButton.styleFrom(
                     primary: Colors.blue
                   ),
                 ) ,
             )],
           ),

           //In the body I wrapped my column with listView for scrolling.
           //It was working fine without it too.

           body:
           (!uploading)?
           ListView(
             children: [
               Column(
                 children: [
                Container(
                  height: 240,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                    ),
                  ),
                  child: TextFormField(

                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                        EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Whats on your mind? Write Here!"),
                    maxLines: null,
                    onChanged: (value){
                      postText = value.toString();
                      },
                  ),
                ),
                   (_xFileImage == null) ? SizedBox(height: 0,)
                       :
                   Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Container(
                       child: Image.file(File(_xFileImage!.path))
                     ),
                   ),

                   ElevatedButton(
                    onPressed: (){
                      _showPicker(context);
                    },
                    child: Text("Add Image")
                   ),
                   // SizedBox(
                   //   height: 300,
                   //   child: Padding(
                   //     padding: const EdgeInsets.all(20.0),
                   //     child: Container(
                   //       color: Colors.red,
                   //     ),
                   //   ),
                   //
                   // )

          ],
        ),
             ],
           )
                 :
           Center(
               child : CircularProgressIndicator()
           )
      ),
       ),

      );
  }
}

