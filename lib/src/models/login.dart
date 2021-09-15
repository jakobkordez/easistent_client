import 'dart:convert';

enum Platform { web, mobile }

extension PlatformSerializer on Platform {
  static const _all = [Platform.web, Platform.mobile];

  static Platform fromInt(int value) => _all[value];
  int asInt() => _all.indexOf(this);
}

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

class User {
  final int id;
  final String language;
  final String type;
  final String username;

  User(this.id, [this.language = '', this.type = '', this.username = '']);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        language = json['language'],
        type = json['type'],
        username = json['username'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'language': language,
        'type': type,
        'username': username,
      };
}

class Login {
  final Platform platform;
  final AccessToken accessToken;
  final User user;
  final String refreshToken;

  Login(this.platform, this.accessToken, this.refreshToken, this.user);

  Login.fromJson(Map<String, dynamic> json, [Platform? platform])
      : platform =
            platform ?? PlatformSerializer.fromInt(json['platform'] ?? 0),
        accessToken = AccessToken.fromJson(json['access_token']),
        refreshToken = json['refresh_token'],
        user = User.fromJson(json['user']);

  Login.fromRefreshToken(String token)
      : platform = Platform.mobile,
        accessToken = AccessToken.expired(),
        refreshToken = token,
        user = User(int.parse(JWToken(token).userId));

  Map<String, dynamic> toJson() => {
        'platform': platform.asInt(),
        'access_token': accessToken.token,
        'refresh_token': refreshToken,
        'user': user,
      };

  Login copyWith({
    AccessToken? accessToken,
    String? refreshToken,
    User? user,
  }) =>
      Login(
        platform,
        accessToken ?? this.accessToken,
        refreshToken ?? this.refreshToken,
        user ?? this.user,
      );
}
