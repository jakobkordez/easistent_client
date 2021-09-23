import 'dart:convert';

class JWToken {
  late final String userId;
  late final String? exp;

  JWToken(String token) {
    final payloadString = base64.normalize(token.split('.')[1]);
    final payload = jsonDecode(utf8.decode(base64.decode(payloadString)));
    userId = payload['userId'];
    exp = payload['exp'];
  }
}

class AccessToken {
  final String token;
  final DateTime _exp;

  AccessToken(this.token) : _exp = DateTime.parse(JWToken(token).exp!);

  AccessToken.expired()
      : token = '',
        _exp = DateTime.now().subtract(const Duration(days: 1));

  AccessToken.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        _exp = DateTime.parse(JWToken(json['token']).exp!);

  bool isExpired() =>
      _exp.isBefore(DateTime.now().subtract(const Duration(seconds: 10)));
}

class RefreshTokenResponse {
  final AccessToken accessToken;
  final String refreshToken;

  RefreshTokenResponse.fromJson(Map<String, dynamic> json)
      : accessToken = AccessToken.fromJson(json['access_token']),
        refreshToken = json['refresh_token'];
}
