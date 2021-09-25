import 'enums/platform.dart';
import 'responses/refresh_token.dart';

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
      : platform = platform ?? Platform.values[json['platform'] ?? 0],
        accessToken = AccessToken.fromJson(json['access_token']),
        refreshToken = json['refresh_token'],
        user = User.fromJson(json['user']);

  Login.fromRefreshToken(String token)
      : platform = Platform.mobile,
        accessToken = AccessToken.expired(),
        refreshToken = token,
        user = User(int.parse(JWToken(token).userId));

  Map<String, dynamic> toJson() => {
        'platform': platform.index,
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
