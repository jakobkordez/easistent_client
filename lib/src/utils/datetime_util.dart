extension DateExtractor on DateTime {
  String getDateString() => toIso8601String().substring(0, 10);

  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  DateTime extractDateWith([
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) =>
      DateTime(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
}
