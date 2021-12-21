import 'package:easistent_client/easistent_client.dart';
import 'package:easistent_client/src/models/responses/refresh_token.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JWT', () {
    test('Empty exp', () {
      const tokenStr =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTYifQ.vXM9gneXonthFK9MJGKBowhIRIEY_I0qJZdQmT8U9Lc';

      final token = JWToken(tokenStr);
      expect(token.userId, '123456');
      expect(token.exp, isNull);
    });

    test('With exp', () {
      const tokenStr =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTYiLCJleHAiOiIyMDIxLTA5LTE1VDIyOjAwOjAwKzAyOjAwIn0.zKnRZbQCn4pL-mw38-DzQ9JIzVK9pkW4aj4o-H8sZMs';

      final token = JWToken(tokenStr);
      expect(token.userId, '123456');
      expect(token.exp, '2021-09-15T22:00:00+02:00');
    });
  });

  group('AccessToken', () {
    test('Expired constructor', () {
      final accessToken = AccessToken.expired();
      expect(accessToken.token, isEmpty);
      expect(accessToken.isExpired(), isTrue);
    });

    test('Default constructor', () {
      const tokenStr =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTYiLCJleHAiOiIyMDIxLTA5LTE1VDIyOjAwOjAwKzAyOjAwIn0.zKnRZbQCn4pL-mw38-DzQ9JIzVK9pkW4aj4o-H8sZMs';

      final accessToken = AccessToken(tokenStr);
      expect(accessToken.token, tokenStr);
      expect(accessToken.isExpired(), isTrue);
    });

    test('fromJson', () {
      const tokenStr =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTYiLCJleHAiOiIyMDIxLTA5LTE1VDIyOjAwOjAwKzAyOjAwIn0.zKnRZbQCn4pL-mw38-DzQ9JIzVK9pkW4aj4o-H8sZMs';

      final accessToken = AccessToken.fromJson({'token': tokenStr});
      expect(accessToken.token, tokenStr);
      expect(accessToken.isExpired(), isTrue);
    });
  });

  group('User', () {
    test('fromJson', () {
      final json = {
        'id': 12345,
        'language': 'lang',
        'type': 'typ',
        'username': 'user',
      };

      final user = User.fromJson(json);
      expect(user.id, 12345);
      expect(user.language, 'lang');
      expect(user.type, 'typ');
      expect(user.username, 'user');
    });
  });

  group('Login', () {
    test('fromRefreshToken', () {
      const tokenStr =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTYifQ.vXM9gneXonthFK9MJGKBowhIRIEY_I0qJZdQmT8U9Lc';

      final login = Login.fromRefreshToken(tokenStr);
      expect(login.accessToken.isExpired(), isTrue);
      expect(login.accessToken.token, isEmpty);
      expect(login.platform, Platform.mobile);
      expect(login.refreshToken, tokenStr);
      expect(login.user.id, 123456);
    });
  });
}
