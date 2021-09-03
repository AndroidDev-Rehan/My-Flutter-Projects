import 'package:flutter/material.dart';
import 'package:sm_app_flutter/models/all_posts.dart';
import 'package:sm_app_flutter/models/post.dart';
import 'package:sm_app_flutter/widgets/post_tile.dart';

class PostsBuilder extends StatefulWidget {

  final AllPosts allPosts;

  const PostsBuilder({required this.allPosts});

  @override
  _PostsBuilderState createState() => _PostsBuilderState();
}

class _PostsBuilderState extends State<PostsBuilder> {


  List<Post> postsList = [];

  @override
  void initState() {
    super.initState();
    initAllPosts();
  }

  void initAllPosts() async {
    postsList = widget.allPosts.getList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: postsList.length,
//        itemCount : 0,
        itemBuilder: (context, index) {
          return PostTile(postsList[index]);
        }
    );
  }

// @override
// Widget build(BuildContext context) {

//     return FutureBuilder(
//       future: initAllPosts(),
//       builder: (ctx, snapshot) {
//         // Checking if future is resolved or not
//         if (snapshot.connectionState == ConnectionState.done) {
//           // If we got an error
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 '${snapshot.error} occured',
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//
//             // if we got our data
// //          } else if (snapshot.hasData) {
//           } else {
//             // Extracting data from snapshot object
//             return ListView.builder(
//                 itemCount: postsList.length,
// //                itemCount : 0,
//                 itemBuilder:(context,index){
//                   return PostTile(postsList[index]);
//                 }
//             );
//           }
//         }
//         // Displaying LoadingSpinner to indicate waiting state
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
}


