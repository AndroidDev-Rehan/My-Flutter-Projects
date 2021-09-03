class AppUser{
  final String uid;
  final String displayName;
  final String imageUrl;

  AppUser({required this.uid, required this.displayName,required this.imageUrl});

  factory AppUser.fromMap(Map<String,dynamic> map){
    return AppUser(
        uid: map['uid'],
        displayName: map['displayName'],
        imageUrl: map['imageUrl']
    );

  }

  Map<String,dynamic> toMap(){
    return {
      'uid' : uid,
      'displayName' : displayName,
      'imageUrl'    : imageUrl
    };
  }

}