library easistent_client;

import 'package:easistent_client/src/utils/datetime_util.dart';
import 'package:easistent_client/src/utils/timetable_adapters.dart';

import 'src/models/enums/platform.dart';
import 'src/models/login.dart';
import 'src/models/responses/refresh_token.dart';
import 'src/models/timetable.dart';
import 'src/api/api.dart' as api;
import 'src/api/authenticated_api.dart' as auth_api;

export 'src/models/enums/platform.dart';
export 'src/models/enums/special_hour_type.dart';
export 'src/models/errors.dart';
export 'src/models/login.dart';
export 'src/models/timetable.dart';

class EAsClient {
  final Map<int, TimeTable> _cache = {};

  static Future<Login> userLogin(String username, String password) async {
    return api.apiLogin(username, password, Platform.mobile);
  }

  static Future<Login> tokenLogin(String token) async {
    final jwt = JWToken(token);
    final tokens = await api.refreshToken(token);
    return Login(
      Platform.mobile,
      tokens.accessToken,
      tokens.refreshToken,
      User(int.parse(jwt.userId)),
    );
  }

  static Future<Login> refreshToken(Login login) async {
    final tokens = await api.refreshToken(login.refreshToken);
    return login.copyWith(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
  }

  void clearCache() => _cache.clear();

  Future<TimeTable> getTimeTable(
    Login login,
    DateTime date, [
    bool clearCache = false,
  ]) async {
    final cacheKey = date.extractDateWith().millisecondsSinceEpoch;
    if (!clearCache && _cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    final weekStart = date.extractDateWith(day: date.day - date.weekday + 1);
    final weekEnd = date.extractDateWith(day: date.day - date.weekday + 7);

    final timetableRes = await auth_api.getTimeTable(weekStart, weekEnd, login);
    final timetable = TimeTableAdapter.from(timetableRes);

    for (var ttDay in timetableRes.dayTable) {
      _cache[ttDay.date.millisecondsSinceEpoch] = TimeTable(
        timetable.schoolHourEvents
            .where((e) => e.timeFrom.isSameDate(ttDay.date)),
        timetable.events.where((e) => e.timeFrom.isSameDate(ttDay.date)),
        timetable.allDayEvents.where((e) => e.date.isSameDate(ttDay.date)),
      );
    }

    for (int i = 0; i < 7; ++i) {
      _cache.putIfAbsent(
        weekStart
            .extractDateWith(day: weekStart.day + i)
            .millisecondsSinceEpoch,
        () => TimeTable([], [], []),
      );
    }

    return _cache[cacheKey]!;
  }
}
