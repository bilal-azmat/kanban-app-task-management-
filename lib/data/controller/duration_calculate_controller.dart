import 'dart:math';


class DurationCalculator {

  Duration calculateTimeDifference(DateTime startTime, DateTime endTime) {
    return endTime.difference(startTime);
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(
        2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

}



