import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_app_flutter/models/all_posts.dart';
import 'package:sm_app_flutter/models/post.dart';
import 'package:sm_app_flutter/widgets/post_tile.dart';

class PostsBuilder extends StatefulWidget {


  const PostsBuilder();

  @override
  _PostsBuilderState createState() => _PostsBuilderState();
}

class _PostsBuilderState extends State<PostsBuilder> {

  late final AllPosts allPosts;
  late final List<Post> postsList;

  // @override
  // void initState() {
  //   super.initState();
  //   initAllPosts();
  // }

  Future<void> initAllPosts() async {
    allPosts = await AllPosts.create();
    postsList = allPosts.getList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initAllPosts(),
      builder: (ctx,snapshot){
        if(snapshot.connectionState==ConnectionState.done){
          // if(snapshot.hasError){
          //   return Center(
          //     child: Text("Error Loading Posts. Check Your internet Connection!",
          //     style: TextStyle(color: Colors.red),
          //     )
          //   );
          // }
          // else {
            return ListView.builder(
                itemCount: postsList.length,
                itemBuilder: (context, index) {
                  final post = postsList[index];
                  return ChangeNotifierProvider<Post>.value(
//                    create: (context) => post,
                  value: post,
                    child: PostTile(post),

                  );
                }
            );
//          }

        }
        return Center(
          child: CircularProgressIndicator(),
        );


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


