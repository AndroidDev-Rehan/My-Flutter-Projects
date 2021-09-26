import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {

  final int milliSeconds;

  const DateWidget({required this.milliSeconds});

  String returnDate(){
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(milliSeconds);
    if(date.day==now.day && date.month==now.month && date.year==now.year){
      return "Today";
    }
     if((date.day==(now.day-1)) && date.month==now.month && date.year==now.year)
       {
         return "Yesterday";
       }
     return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            returnDate(),
            style: TextStyle(
            ),
          )
        ],
      ),
    );
  }
}
