import 'dart:ui';

import 'package:easistent_client/src/models/enums/special_hour_type.dart';
import 'package:easistent_client/src/models/responses/timetable.dart';
import 'package:easistent_client/src/models/timetable.dart';
import 'package:easistent_client/src/utils/datetime_util.dart';
import 'package:flutter/foundation.dart';

extension SchoolHourAdapter on SchoolHour {
  static SchoolHour from(TimeTableHourResponse res) => SchoolHour(
        res.name,
        res.shortName,
        Time.parse(res.time.from),
        Time.parse(res.time.to),
        res.type,
      );
}

extension SchoolHourEventAdapter on SchoolHour {
  static SchoolHourEvent from(
    SchoolHourEventResponse res,
    Map<int, SchoolHour> schoolHours,
  ) =>
      SchoolHourEvent(
        res.time.date.extractDateWith(
          hour: schoolHours[res.time.fromId]!.timeFrom.hour,
          minute: schoolHours[res.time.fromId]!.timeFrom.minute,
        ),
        res.time.date.extractDateWith(
          hour: schoolHours[res.time.toId]!.timeTo.hour,
          minute: schoolHours[res.time.toId]!.timeTo.minute,
        ),
        _hexToColor(res.color),
        res.subject.name,
        SpecialHourType.values
            .firstWhere((e) => describeEnum(e) == res.hourSpecialType),
        List.unmodifiable(res.departments.map((e) => e.name)),
        res.classroom.name,
        List.unmodifiable(res.teachers.map((e) => e.name)),
        List.unmodifiable(res.groups.map((e) => e.name)),
      );

  static Color _hexToColor(String color) =>
      Color(int.parse('ff${color.replaceFirst('#', '')}', radix: 16));
}

extension EventAdapter on Event {
  static Event from(EventResponse res) {
    final timeFrom = Time.parse(res.time.from);
    final timeTo = Time.parse(res.time.to);

    return Event(
      res.name,
      res.date.extractDateWith(
        hour: timeFrom.hour,
        minute: timeFrom.minute,
      ),
      res.date.extractDateWith(
        hour: timeTo.hour,
        minute: timeTo.minute,
      ),
      res.location.name,
    );
  }
}

extension AllDayEventAdapter on Event {
  static AllDayEvent from(AllDayEventResponse res) => AllDayEvent(
        res.name,
        res.date.extractDateWith(),
        res.location.name,
      );
}

extension TimeTableAdapter on TimeTable {
  static TimeTable from(TimeTableResponse res) {
    Map<int, SchoolHour> schoolHours = Map.fromEntries(
      res.timeTableHours.map((e) => MapEntry(e.id, SchoolHourAdapter.from(e))),
    );

    return TimeTable(
      res.schoolHourEvents
          .map((e) => SchoolHourEventAdapter.from(e, schoolHours)),
      res.events.map((e) => EventAdapter.from(e)),
      res.allDayEvents.map((e) => AllDayEventAdapter.from(e)),
    );
  }
}
