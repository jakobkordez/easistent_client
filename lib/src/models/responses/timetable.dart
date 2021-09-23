typedef Json = Map<String, dynamic>;

class ClassroomResponse {
  final int id;
  final String name;

  ClassroomResponse.fromJson(Json json)
      : id = int.parse(json['id']),
        name = json['name'];
}

class TeacherResponse {
  final int id;
  final String name;

  TeacherResponse.fromJson(Json json)
      : id = int.parse(json['id']),
        name = json['name'];
}

class SubjectResponse {
  final int id;
  final String name;

  SubjectResponse.fromJson(Json json)
      : id = int.parse(json['id']),
        name = json['name'];
}

class DepartmentResponse {
  final int id;
  final String name;

  DepartmentResponse.fromJson(Json json)
      : id = int.parse(json['id']),
        name = json['name'];
}

class GroupResponse {
  final int id;
  final String name;
  final bool? selected;

  GroupResponse.fromJson(Json json)
      : id = int.parse(json['id']),
        name = json['name'],
        selected = json['selected'];
}

class LocationResponse {
  final String? name;
  final String? shortName;

  LocationResponse.fromJson(Json json)
      : name = json['name'],
        shortName = json['short_name'];
}

class TimeRangeResponse {
  final String from;
  final String to;

  TimeRangeResponse.fromJson(Json json)
      : from = json['from'],
        to = json['to'];
}

class TimeTableHourResponse {
  final int id;
  final String name;
  final String shortName;
  final TimeRangeResponse time;
  final String type;

  TimeTableHourResponse.fromJson(Json json)
      : id = json['id'],
        name = json['name'],
        shortName = json['name_short'],
        time = TimeRangeResponse.fromJson(json['time']),
        type = json['type'];
}

class SchoolHourTimeResponse {
  final int fromId;
  final int toId;
  final DateTime date;

  SchoolHourTimeResponse.fromJson(Json json)
      : fromId = json['from_id'],
        toId = json['to_id'],
        date = DateTime.parse(json['date']);
}

class SchoolHourEventResponse {
  final SchoolHourTimeResponse time;
  // TODO videokonferenca
  final int eventId;
  final String color;
  final SubjectResponse subject;
  final bool completed;
  final String? hourSpecialType;
  final List<DepartmentResponse> departments;
  final ClassroomResponse classroom;
  final List<TeacherResponse> teachers;
  final List<GroupResponse> groups;
  // TODO info

  SchoolHourEventResponse.fromJson(Json json)
      : time = SchoolHourTimeResponse.fromJson(json['time']),
        eventId = json['event_id'],
        color = json['color'],
        subject = SubjectResponse.fromJson(json['subject']),
        completed = json['completed'],
        hourSpecialType = json['hour_special_type'],
        departments = (json['departments'] as List)
            .map((e) => DepartmentResponse.fromJson(e))
            .toList(),
        classroom = ClassroomResponse.fromJson(json['classroom']),
        teachers = (json['teachers'] as List)
            .map((e) => TeacherResponse.fromJson(e))
            .toList(),
        groups = (json['groups'] as List)
            .map((e) => GroupResponse.fromJson(e))
            .toList();
}

class TimeTableDayResponse {
  final String name;
  final String shortName;
  final DateTime date;

  TimeTableDayResponse.fromJson(Json json)
      : name = json['name'],
        shortName = json['short_name'],
        date = DateTime.parse(json['date']);
}

class EventResponse {
  final int id;
  final String name;
  final TimeRangeResponse time;
  final DateTime date;
  final int eventType;
  final LocationResponse location;

  EventResponse.fromJson(Json json)
      : id = json['id'],
        name = json['name'],
        time = TimeRangeResponse.fromJson(json['time']),
        date = DateTime.parse(json['date']),
        eventType = json['event_type'],
        location = LocationResponse.fromJson(json['location']);
}

class AllDayEventResponse {
  final int id;
  final String name;
  final DateTime date;
  final int eventType;
  final LocationResponse location;

  AllDayEventResponse.fromJson(Json json)
      : id = json['id'],
        name = json['name'],
        date = DateTime.parse(json['date']),
        eventType = json['event_type'],
        location = LocationResponse.fromJson(json['location']);
}

class TimeTableResponse {
  final List<TimeTableHourResponse> timeTableHours;
  final List<TimeTableDayResponse> dayTable;
  final List<SchoolHourEventResponse> schoolHourEvents;
  final List<EventResponse> events;
  final List<AllDayEventResponse> allDayEvents;

  TimeTableResponse.fromJson(Json json)
      : timeTableHours = (json['time_table'] as List)
            .map((hour) => TimeTableHourResponse.fromJson(hour))
            .toList(),
        dayTable = (json['day_table'] as List)
            .map((day) => TimeTableDayResponse.fromJson(day))
            .toList(),
        schoolHourEvents = (json['school_hour_events'] as List)
            .map((event) => SchoolHourEventResponse.fromJson(event))
            .toList(),
        events = (json['events'] as List)
            .map((event) => EventResponse.fromJson(event))
            .toList(),
        allDayEvents = (json['all_day_events'] as List)
            .map((event) => AllDayEventResponse.fromJson(event))
            .toList();
}
