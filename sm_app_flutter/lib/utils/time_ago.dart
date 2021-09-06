
class TimeAgo {
  final secondMillis = 1000;
  final minuteMillis = 60000;
  final hourMillis = 3600000;
  final dayMillis = 86400000;

  String? getTimeAgo(int time) {
  final int now = DateTime.now().millisecondsSinceEpoch;
  if (time > now || time <= 0) {
  return null;
  }

  final diff = now - time;
   if (diff < minuteMillis) {
     return "just now";
  } else if (diff < 2 * minuteMillis) {
  return "a minute ago";
  } else if (diff < 50 * minuteMillis) {
  return (diff / minuteMillis).floor().toString() + " minutes ago";
  } else if (diff < 90 * minuteMillis) {
  return "an hour ago";
  } else if (diff < 24 * hourMillis) {
  return (diff / hourMillis).floor().toString() + " hours ago";
  } else if (diff < 48 * hourMillis) {
  return "yesterday";
  } else {
  return ((diff / dayMillis).floor()).toString() + " days ago";
  }
}

}