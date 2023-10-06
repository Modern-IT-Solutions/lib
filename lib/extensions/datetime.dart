extension DateTimeExtension on DateTime {
  String getFormattedDuration() {
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(this);

    if (difference < Duration(days: 1)) {
      int hours = difference.inHours;
      int minutes = difference.inMinutes.remainder(60);
      String duration = (hours > 0)
          ? '$hours ${hours == 1 ? 'hour' : 'hours'}'
          : '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';

      return duration; // Returns: X hours or X minutes
    } else {
      int days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'}'; // Returns: X days
    }
  }
}