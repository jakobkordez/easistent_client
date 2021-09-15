An eAsistent client Flutter package

## Usage

```dart
// Login with username and password
var login = await EAsClient.userLogin('username', 'password');

// Or login with token
var login = await EAsClient.tokenLogin('refreshToken');

// Create the client
final client = EAsClient();

// If needed refresh the access token
if (login.accessToken.isExpired())
  login = await EAsClient.refreshToken(login);

// Get a timetable
final timetable = await client.getTimeTable(login, DateTime.now());
```
