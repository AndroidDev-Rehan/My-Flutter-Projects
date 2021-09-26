import 'package:flutter/material.dart';

//msgDate is actually date + time of message

class Message{
  final String text;
  final int msgDateTimeInMilis;
  final String authorId;
  final String? imgUrl;

  Message({required this.text, required this.msgDateTimeInMilis,required this.authorId,required this.imgUrl});

  Map<String,dynamic> toMap(){
    return {
      'text' : text,
      //TODO msgDate.toString
      'msgDateTimeInMilis' : msgDateTimeInMilis,
      'authorId' : authorId,
      'imgUrl'   : imgUrl
    };
  }

  factory Message.fromMap(Map<String,dynamic> map){
    return Message(
        text: map['text'],
        msgDateTimeInMilis: map['msgDateTimeInMilis'],
        authorId: map['authorId'],
        imgUrl:  map['imgUrl']
    );
  }

}