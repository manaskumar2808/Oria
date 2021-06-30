Duration getTimeDifference(String timeString) {
  final timeDifference = DateTime.now().difference(DateTime.parse(timeString));
  return timeDifference;
}

String getTime(String timeString) {
  final timeDifference = getTimeDifference(timeString);
  final time = timeDifference.inSeconds < 60
      ? timeDifference.inSeconds
      : timeDifference.inMinutes < 60
          ? timeDifference.inMinutes
          : timeDifference.inHours < 24
              ? timeDifference.inHours
              : timeDifference.inDays;
  return time.toStringAsFixed(0);
}

String getAbbreviation(String timeString, [bool full = false]) {
  final timeDifference = getTimeDifference(timeString);
  String abbreviation;
  if (full) {
    abbreviation = timeDifference.inSeconds < 60
        ? 'seconds'
        : timeDifference.inMinutes < 60
            ? 'minutes'
            : timeDifference.inHours < 24 ? 'hours' : 'days';
  } else {
    abbreviation = timeDifference.inSeconds < 60
        ? 's'
        : timeDifference.inMinutes < 60
            ? 'm'
            : timeDifference.inHours < 24 ? 'h' : 'd';
  }

  return abbreviation;
}
