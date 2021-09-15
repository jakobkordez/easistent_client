import 'dart:convert';

import 'package:easistent_client/src/models/errors.dart';
import 'package:easistent_client/src/models/login.dart';
import 'package:easistent_client/src/models/timetable_response.dart';
import 'package:easistent_client/src/utils/datetime_util.dart';
import 'package:http/http.dart' as http;

import 'api.dart';

Map<String, String> getAuthHeaders(Login login, [Platform? platform]) => {
      ...headers[platform ?? login.platform]!,
      'authorization': 'Bearer ${login.accessToken.token}',
      'x-child-id': '${login.user.id}',
    };

Future<TimeTableResponse> getTimeTable(
  DateTime from,
  DateTime to,
  Login login,
) async {
  final res = await http.get(
    Uri.parse(
        '$eAsUrl/m/timetable/weekly?from=${from.getDateString()}&to=${to.getDateString()}'),
    headers: getAuthHeaders(login, Platform.web),
  );

  final json = jsonDecode(res.body);

  if (res.statusCode != 200) throw EAsError.fromJson(json['error']);

  return TimeTableResponse.fromJson(json);
}
