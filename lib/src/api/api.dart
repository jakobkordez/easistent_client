import 'dart:convert';

import 'package:easistent_client/src/models/enums/platform.dart';
import 'package:easistent_client/src/models/errors.dart';
import 'package:easistent_client/src/models/login.dart';
import 'package:easistent_client/src/models/responses/refresh_token.dart';
import 'package:easistent_client/src/utils/metadata_util.dart';
import 'package:http/http.dart' as http;

const String eAsUrl = 'https://www.easistent.com';

Map<Platform, Map<String, String>> get headers => const {
      Platform.web: {
        'content-type': 'application/json',
        'x-app-name': 'family',
        'x-client-version': '13',
        'x-client-platform': 'web',
      },
      Platform.mobile: {
        'content-type': 'application/json',
        'x-app-name': 'family',
        'x-client-version': '20001',
        'x-client-platform': 'android',
      }
    };

Future<Login> apiLogin(
  String username,
  String password,
  Platform platform,
) async {
  final res = await http.post(
    Uri.parse('$eAsUrl/m/login'),
    headers: headers[platform],
    body: jsonEncode({
      'username': username,
      'password': password,
      'supported_user_types': ['child'],
    }),
  );

  final json = jsonDecode(res.body);

  if (res.statusCode != 200) throw EAsError.fromJson(json['error']);

  return Login.fromJson(json, platform);
}

Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
  final res = await http.post(
    Uri.parse('$eAsUrl/m/refresh_token'),
    headers: headers[Platform.mobile],
    body: jsonEncode({'refresh_token': refreshToken}),
  );

  final json = jsonDecode(res.body);

  if (res.statusCode != 200) throw EAsError.fromJson(json['error']);

  return RefreshTokenResponse.fromJson(json);
}

Future<Login> ajaxLogin(String username, String password) async {
  final client = http.Client();

  final loginRes = await client.post(
    Uri.parse('$eAsUrl/p/ajax_prijava'),
    body: {
      'uporabnik': username,
      'geslo': password,
    },
  );

  final loginJson = jsonDecode(loginRes.body);

  if (loginRes.statusCode != 200 || loginJson['status'] != 'ok') {
    throw EAsError(400, loginJson['status'], loginJson['message']);
  }

  final cookie = loginRes.headers['set-cookie']!;

  final tokenRes = await client.get(
    Uri.parse(eAsUrl),
    headers: {
      'cookie': cookie.substring(0, cookie.indexOf(';')),
    },
  );

  client.close();

  final data = parseMetadata(tokenRes.body);

  if (!data.containsKey('access-token') ||
      !data.containsKey('refresh-token') ||
      !data.containsKey('x-child-id')) throw Error();

  return Login(
    Platform.web,
    AccessToken(data['access-token']!),
    data['refresh-token']!,
    User(int.parse(data['x-child-id']!)),
  );
}
