import 'dart:ui';

class Time {
  final int minute;
  final int hour;

  Time([this.hour = 0, this.minute = 0]);

  Time.parse(String source)
      : assert(source.split(':').length == 2),
        hour = int.parse(source.split(':').first),
        minute = int.parse(source.split(':').last);
}

class SchoolHour {
  final String name;
  final String shortName;
  final Time timeFrom;
  final Time timeTo;
  final String type; // TODO types as enum

  SchoolHour(this.name, this.shortName, this.timeFrom, this.timeTo, this.type);
}

class SchoolHourEvent {
  final DateTime timeFrom;
  final DateTime timeTo;
  final Color color;
  final String subject;
  final String? specialHourType; // TODO types as enum
  final List<String> departments;
  final String classroom;
  final List<String> teachers;
  final List<String> groups;

  SchoolHourEvent(
    this.timeFrom,
    this.timeTo,
    this.color,
    this.subject,
    this.specialHourType,
    List<String> departments,
    this.classroom,
    List<String> teachers,
    List<String> groups,
  )   : departments = List.unmodifiable(departments),
        teachers = List.unmodifiable(teachers),
        groups = List.unmodifiable(groups);
}

class Event {
  final String name;
  final DateTime timeFrom;
  final DateTime timeTo;
  // int eventType
  final String? location;

  Event(this.name, this.timeFrom, this.timeTo, this.location);
}

class AllDayEvent {
  final String name;
  final DateTime date;
  // int eventType
  final String? location;

  AllDayEvent(this.name, this.date, this.location);
}

class TimeTable {
  final List<SchoolHourEvent> schoolHourEvents;
  final List<Event> events;
  final List<AllDayEvent> allDayEvents;

  TimeTable(
    Iterable<SchoolHourEvent> schoolHourEvents,
    Iterable<Event> events,
    Iterable<AllDayEvent> allDayEvents,
  )   : schoolHourEvents = List.unmodifiable(
          List<SchoolHourEvent>.from(schoolHourEvents, growable: false)
            ..sort((a, b) => a.timeFrom.compareTo(b.timeFrom)),
        ),
        events = List.unmodifiable(
          List<Event>.from(events, growable: false)
            ..sort((a, b) => a.timeFrom.compareTo(b.timeFrom)),
        ),
        allDayEvents = List.unmodifiable(
          List<AllDayEvent>.from(allDayEvents, growable: false)
            ..sort((a, b) => a.date.compareTo(b.date)),
        );
}
